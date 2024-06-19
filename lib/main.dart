import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'signInLanding.dart';
import 'signInChoice.dart';
import 'signIn.dart';

import 'applicant/applicantSignUp.dart';
import 'applicant/applicantOnboarding.dart';
import 'applicant/applicantSwipe.dart';
import 'applicant/searchFilters.dart';
import 'applicant/applicantProfile.dart';
import 'applicant/applicantHome.dart';
import 'applicant/messaging.dart';
import 'applicant/applicantSettings.dart';

import 'organization/organizationSignUp.dart';
import 'organization/organizationHome.dart';
import 'organization/viewMatches.dart';
import 'organization/organizationSwipe.dart';
import 'organization/messaging.dart';
import 'organization/postNewJob.dart';

import 'models/userModel.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(), // Assuming User is your model class
      child: HyredApp(),
    ),
  );
}
class HyredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Hyred!',
      theme: ThemeData(
        primarySwatch: Colors.green,
        secondaryHeaderColor: Colors.green[700],
        hoverColor: Colors.green[100],
        splashColor: Colors.green[100],
        highlightColor: Colors.green[100],
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
        focusColor: Colors.green[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInScreen(),
        '/sign_in_choice': (context) => SignInChoiceScreen(),
        '/sign_in': (context) =>   SignIn(),

        // Applicant routes
        '/applicant_sign_in': (context) => ApplicantSignUp(),
        '/applicant_sign_up': (context) => ApplicantSignUp(),
        '/applicant_onboarding': (context) => ApplicantOnboardingScreen(),
        '/job_swipe': (context) => ApplicantSwipeScreen(),
        '/search_filters': (context) => SearchFiltersScreen(),
        '/applicant_profile': (context) => ApplicantProfileScreen(),
        '/applicant_home': (context) => ApplicantHomeScreen(),
        '/messaging': (context) => MessagingScreen(),
        '/applicant_settings': (context) => SettingsPage(),


        // Organization routes
        '/organization_sign_in': (context) => OrganizationSignUp(),
        '/organization_sign_up': (context) => OrganizationSignUp(),
        '/organization_home': (context) => OrganizationHomeScreen(),
        '/view_matches': (context) => MatchesForJobPostScreen(),
        '/organization_swipe': (context) => OrganizationSwipeScreen(),
        '/organization_messaging': (context) => OrganizationMessagingScreen(),
        '/post_new_job': (context) => PostNewJobScreen(),
      },
    );
  }
}
