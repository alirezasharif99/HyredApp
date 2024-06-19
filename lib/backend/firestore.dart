import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

const String _usersCollection = 'Users';
const String _jobPostsCollection = 'JobPosts';

abstract class User {
  final String email;
  final bool applicant;
  final String uid;

  User({
    required this.email,
    required this.applicant,
    required this.uid,
  });
}

enum Industry {
  Software,
  Finance,
  Pharmaceuticals,
  Other,
  None
}

class Applicant extends User {
  String bio;
  String fullName;
  List<dynamic> skills;
  Industry industry;

  Applicant({
    required super.uid,
    required super.email,
    this.industry = Industry.None,
    required this.bio,
    super.applicant = true,
    required this.fullName,
    this.skills = const [],
  });

  // From JSON to convert firestore doc to Applicant object
  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      uid: json['uid'],
      email: json['email'],
      bio: json['bio'],
      fullName: json['fullName'],
      skills: json['skills'],
      industry: Industry.values.firstWhere((industry) => industry.toString() == json['industry']),
    );
  }
}

class Organization extends User {
  String fullName;
  List<dynamic> posts;

  Organization({
    required super.uid,
    required super.email,
    super.applicant = false,
    required this.fullName,
    this.posts = const [],
  });

  // From JSON to convert firestore doc to Organization object
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      uid: json['uid'],
      email: json['email'],
      fullName: json['fullName'],
      posts: json['posts'],
    );
  }
}


class JobPost {
  final String uid;
  final String organizationUid;
  final Organization organization;
  final String title;
  final String description;
  final String location;
  final String imageURL;
  final double salary;
  final Industry industry;
  List<dynamic> applicantLikes;
  List<dynamic> organizationLikes;

  JobPost({
    required this.organizationUid,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.salary,
    required this.location,
    required this.organization,
    required this.industry,
    String? uid,
    this.applicantLikes = const [],
    this.organizationLikes = const [],
  }) : this.uid = uid ?? generateUid();

  static String generateUid() {
    return Random().nextInt(1000000000).toRadixString(32);
  }

  // From JSON to convert firestore doc to JobPost object
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      organizationUid: json['organizationUid'],
      title: json['title'],
      description: json['description'],
      imageURL: json['imageURL'],
      salary: json['salary'],
      industry: Industry.values.firstWhere((industry) => industry.toString() == json['industry']),
      location: json['location'],
      organization: json['organization'],
      applicantLikes: json['applicantLikes'],
      organizationLikes: json['organizationLikes'],
    );
  }
}


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> getUser(String uid) async {
    try {
      var userData = await _db.collection('Users').doc(uid).get();
      if (userData.exists) {

        if (userData['applicant'] == true) {
          return Applicant(
            uid: userData.id,
            email: userData['email'],
            bio: userData['bio'],
            fullName: userData['fullName'],
            skills: userData['skills'],
          );
        } else {
          return Organization(
            uid: userData.id,
            email: userData['email'],
            applicant: userData['applicant'],
            fullName: userData['fullName'],
            posts: userData['posts'],
          );
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Applicant?> getApplicant(String uid) {
    return _db.collection(_usersCollection).doc(uid).get().then((doc) {
      if (doc.exists && doc['applicant'] == true) {
        return Applicant(
          uid: doc.id,
          email: doc['email'],
          bio: doc['bio'],
          fullName: doc['fullName'],
          skills: doc['skills'],
        );
      }
      return null;
    });
  }


  Future<Organization?> getOrganization(String uid) {
    return _db.collection(_usersCollection).doc(uid).get().then((doc) {
      if (doc.exists && doc['applicant'] == false) {
        return Organization(
          uid: doc.id,
          email: doc['email'],
          fullName: doc['fullName'],
          posts: doc['posts'],
        );
      }
      return null;
    });
  }

  Future<List<JobPost>> getOrganizationJobPosts(String orgUid) async {
    final organization = await getOrganization(orgUid);
    if (organization == null) {
      return [];
    }

    return _db.collection(_jobPostsCollection).where('organizationUid', isEqualTo: orgUid).get().then((snapshot) {
      return snapshot.docs.map((doc) {
        return JobPost(
          organization: organization,
          organizationUid: doc['organizationUid'],
          title: doc['title'],
          description: doc['description'],
          imageURL: doc['imageURL'],
          salary: doc['salary'],
          industry: Industry.values.firstWhere((industry) => industry.toString() == doc['industry']),
          location: doc['location'],
          applicantLikes: doc['applicantLikes'],
          organizationLikes: doc['organizationLikes'],
          uid: doc.id,
        );
      }).toList();
    });
  }

  Future<List<JobPost>> getUnlikedJobPosts(String uid) async {
    final snapshot = await _db.collection(_jobPostsCollection).get();
    final organizationList = await Future.wait(snapshot.docs.map((doc) async {
      final organization = await getOrganization(doc['organizationUid']);
      return JobPost(
        organization: organization!,
        organizationUid: doc['organizationUid'],
        title: doc['title'],
        description: doc['description'],
        imageURL: doc['imageURL'],
        salary: doc['salary'],
        industry: Industry.values.firstWhere((industry) => industry.toString() == doc['industry']),
        location: doc['location'],
        applicantLikes: doc['applicantLikes'],
        organizationLikes: doc['organizationLikes'],
        uid: doc.id,
      );
    }));
    return organizationList.where((jobPost) => !jobPost.applicantLikes.contains(uid)).toList();
  }

  Future<List<Applicant>> getUnlikedApplicants(JobPost jobPost) async {
    final snapshot = await _db.collection(_usersCollection).where('applicant', isEqualTo: true).get();
    final applicantList = await Future.wait(snapshot.docs.map((doc) async {
      return Applicant.fromJson(doc.data());
    }));
    return applicantList.where((applicant) => !jobPost.organizationLikes.contains(applicant.uid) && !jobPost.applicantLikes.contains(applicant.uid)).toList();
  }
  
  Future<void> createApplicant(Applicant applicant) async {
    try {
      await _db.collection(_usersCollection).doc(applicant.uid).set({
        'email': applicant.email,
        'applicant': applicant.applicant,
        'uid': applicant.uid,
        'bio': applicant.bio,
        'fullName': applicant.fullName,
        'skills': applicant.skills,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createOrganization(Organization organization) async {
    try {
      await _db.collection(_usersCollection).doc(organization.uid).set({
        'email': organization.email,
        'applicant': false,
        'uid': organization.uid,
        'fullName': organization.fullName,
        'posts': organization.posts,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> createJobPost(JobPost jobPost) async {
    try {
      await _db.collection(_jobPostsCollection).doc(jobPost.uid).set({
        'organizationUid': jobPost.organizationUid,
        'title': jobPost.title,
        'description': jobPost.description,
        'imageURL': jobPost.imageURL,
        'salary': jobPost.salary,
        'industry': jobPost.industry.toString(),
        'location': jobPost.location,
        'applicantLikes': jobPost.applicantLikes,
        'organizationLikes': jobPost.organizationLikes,
        'uid': jobPost.uid,
      });

      await _db.collection(_usersCollection).doc(jobPost.organizationUid).update({
        'posts': FieldValue.arrayUnion([jobPost.uid]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateApplicant(Applicant applicant) async {
    try {
      await _db.collection(_usersCollection).doc(applicant.uid).update({
        'bio': applicant.bio,
        'fullName': applicant.fullName,
        'skills': applicant.skills,
        'industry': applicant.industry.toString(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkForMatch(String jobPostUid, String applicantUid) async {
    final jobPost = await _db.collection(_jobPostsCollection).doc(jobPostUid).get();
    if (jobPost.exists) {
      return jobPost['applicantLikes'].contains(applicantUid) && jobPost['organizationLikes'].contains(jobPost['organizationUid']);
    }

    return false;
  }

  Future<void> likeJobPost(String jobPostUid, String applicantUid) async {
    try {
      await _db.collection(_jobPostsCollection).doc(jobPostUid).update({
        'applicantLikes': FieldValue.arrayUnion([applicantUid]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> likeApplicant(String jobPostUid, String applicantUid) async {
    try {
      await _db.collection(_jobPostsCollection).doc(jobPostUid).update({
        'organizationLikes': FieldValue.arrayUnion([applicantUid]),
      });
    } catch (e) {
      print(e);
    }
  }
}
