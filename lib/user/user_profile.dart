import 'package:campuscrave/authentication/login_screen.dart';
import 'package:campuscrave/database/auth.dart';
import 'package:campuscrave/database/shared_pref.dart';
import 'package:campuscrave/user/user_feedback.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
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
            ? Center(child: const CircularProgressIndicator())
            : Container(
                child: Column(
                  children: [
                    // Stack(
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(top: 20.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             name!,
                    //             style: const TextStyle(
                    //               fontFamily: 'SF Pro Text',
                    //               fontSize: 23.0,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    buildInfoCard(Icons.person, 'Name', name!),
                    const SizedBox(
                      height: 30.0,
                    ),
                    buildInfoCard(Icons.email, 'Email', email!),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => FeedbackPage());
                      },
                      child: buildActionCard(Icons.star_rate_rounded, 'User Feedbacks'),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        AuthMethods().deleteuser();
                        Get.to(() => LoginScreen());
                      },
                      child: buildActionCard(Icons.delete, 'Delete Account'),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        AuthMethods().SignOut();
                        Get.to(() => LoginScreen());
                      },
                      child: buildActionCard(Icons.logout, 'LogOut'),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              const SizedBox(
                width: 20.0,
              ),
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
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionCard(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
