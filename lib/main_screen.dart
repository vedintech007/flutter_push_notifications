import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  String? mtoken;

  @override
  void initState() {
    requestPermission();
    getToken();
    initInfo();
    super.initState();
  }

  void initInfo() {}

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((String? token) {
      setState(() {
        mtoken = token;
        print("My token is $token");
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance.collection("UserTokens").doc("User2").set({
      "token": token,
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.getInitialMessage();

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission or permission has not been accepted");
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: inputFieldDecoration(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: titleController,
                      decoration: inputFieldDecoration(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: bodyController,
                      decoration: inputFieldDecoration(),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: () {
                    String name = usernameController.text.trim();
                    String titleText = titleController.text.trim();
                    String bodyText = bodyController.text.trim();
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.5),
                        ),
                      ],
                    ),
                    child: const Center(
                        child: Text(
                      "Button",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputFieldDecoration() {
    return const InputDecoration(
      filled: true,
      border: InputBorder.none,
      hintText: "Enter user name",
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }
}
