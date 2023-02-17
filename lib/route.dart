import 'package:login_registration/login.dart';
import 'package:login_registration/profile_page.dart';

// const String welcomeRoute = "/welcome";
const String homeRoute = "/home";
const String loginRoute = "/login";
// const String splashRoute = "/splash";

final routes = {
  // welcomeRoute: (context) => welcomeScreen(),
  homeRoute: (context) => const ProfilePage(),
  loginRoute: (context) => const LoginScreen(),
  // splashRoute: (context) => splashScreen()
};
