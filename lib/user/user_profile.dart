import 'package:campuscrave/authentication/login_screen.dart';
import 'package:campuscrave/database/auth.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/user/user_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email;

  @override
  void initState() {
    super.initState();
    onThisLoad();
  }

  Future<void> onThisLoad() async {
    await getSharedPref();
    setState(() {});
  }

  Future<void> getSharedPref() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
  }

  Future<void> _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
            ],
          );
        }
      },
    );
  }

  void _deleteAccount() {
    AuthMethods().deleteuser();
    Get.offAll(() => const LoginScreen()); // Navigate to LoginScreen with proper initialization
  }

  void _logout() {
    AuthMethods().SignOut();
    Get.offAll(() => const LoginScreen()); // Navigate to LoginScreen with proper initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Center(
        child: name == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    buildInfoCard(Icons.person, 'Name', name!),
                    const SizedBox(height: 10.0),
                    buildInfoCard(Icons.email, 'Email', email!),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2.0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        side: BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Get.to(() => FeedbackPage());
                      },
                      child: Row(
                        children: [
                          Icon(Icons.star_rate_rounded, color: Colors.black),
                          const SizedBox(width: 20.0),
                          const Text(
                            'User Feedbacks',
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        elevation: 2.0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        side: BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _showConfirmationDialog(
                          context,
                          'Delete Account',
                          'Are you sure you want to delete your account? This action cannot be undone.',
                          _deleteAccount,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          const SizedBox(width: 20.0),
                          const Text(
                            'Delete Account',
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        elevation: 2.0,
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        side: BorderSide(color: Colors.blue, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        _showConfirmationDialog(
                          context,
                          'Log Out',
                          'Are you sure you want to log out?',
                          _logout,
                        );
                      },
                      child: const  Row(
                        children: [
                          Icon(Icons.logout, color: Colors.blue),
                           SizedBox(width: 20.0),
                           Text(
                            'Log Out',
                            style: TextStyle(
                              fontFamily: 'SF Pro Text',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2), // Black border added
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
