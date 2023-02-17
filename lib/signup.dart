// ignore_for_file: nullable_type_in_catch_clause, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_registration/login.dart';
import 'package:login_registration/usermodel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  // string for displaying the error Message
  String? errorMessage;

  final String _fullname = '';
  String _userType = "Student";
  String _email = "";
  String _password = "";
  String _mobile = "";
  String _name = "";
  String _collegeName = "";
  int _year = 0;
  String _profilePicPath = "";
  String _resumePath = "";

  // our form key
  final _formKey = GlobalKey<FormState>();

  // editing Controller
  final fullnameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();

  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final List<String> _userTypes = ["Student", "Faculty", "Alumni"];

  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    void _submit() {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _formKey.currentState!.save();
    }

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xff3B3486),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: const Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Hello!\nSignup to\nget started',
                  style: GoogleFonts.playfairDisplay(
                      color: const Color(0xff3B3486),
                      fontSize: 34,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                    value: _userType,
                    items: _userTypes.map((userType) {
                      return DropdownMenuItem(
                        value: userType,
                        child: Text(userType),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _userType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.verified_user),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "User",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return "Password must be at least 6 characters long.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.local_phone),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Mobile",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty || value.length != 10) {
                      return "Please enter a valid 10-digit mobile number.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _mobile = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.portrait),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.school),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "College Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your college name.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _collegeName = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_userType == "Student")
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.portrait),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Admission Year",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your admission year.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _year = int.parse(value!);
                    },
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (_userType == "Alumni")
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.portrait),
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Pass-out Year",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your pass-out year.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _year = int.parse(value!);
                    },
                  ),
                const SizedBox(
                  height: 05,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.add_photo_alternate),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Profile Picture",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select a profile picture.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _profilePicPath = value!;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.attach_file),
                    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    hintText: "Resume(Optional)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSaved: (value) {
                    _resumePath = value!;
                  },
                ),
                const SizedBox(height: 16),
                signUpButton
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Color(0xff3B3486),
        ));
      },
    );

    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {afterThen()});
        //     .then((value) => {postDetailsToFirestore()});
        // Navigator.of(context).pop;
        // Navigator.of(context).pushReplacementNamed(loginRoute);
        Fluttertoast.showToast(msg: "User Successfully Registered")
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "Successfully Registered.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  void afterThen() {
    (value) => {postDetailsToFirestore()};
    // Navigator.of(context).pop;
    // Navigator.of(context).pushReplacementNamed(loginRoute);
    // Fluttertoast.showToast(msg: "User Successfully Registered");
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullName = fullnameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Navigator.of(context).pop;
    // Navigator.of(context).pushReplacementNamed();
    Fluttertoast.showToast(msg: "User Successfully Registered");
  }
}
