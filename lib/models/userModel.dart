import 'package:flutter/foundation.dart';
import '../../backend/firestore.dart';

class UserModel extends ChangeNotifier {
  User? _user;
  final _firestoreService = FirestoreService();

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<User?> fetchUser(String uid) async {
    _user = await _firestoreService.getUser(uid);
    notifyListeners();
    return _user;
  }

  void updateApplicant(String fullName, String bio, Industry industry, List<String> skills) {
    if (_user is Applicant) {
      (_user as Applicant).fullName = fullName;
      (_user as Applicant).bio = bio;
      (_user as Applicant).industry = industry as Industry;
      (_user as Applicant).skills = skills;
      _firestoreService.updateApplicant(_user as Applicant);
      notifyListeners();
    }
  }
}
