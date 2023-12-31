import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/new_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:http/http.dart" as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String? mtoken;

  // Go to you Project settings -> Cloud Messaging -> Enable Cloud Messaging API -> Copy paste your token here (Avoid pushing to public repo)
  String serverKey = "";

  @override
  void initState() {
    requestPermission();
    getToken();
    initInfo();
    super.initState();
  }

  void initInfo() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    var androidInitialise = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialise = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialise, iOS: iOSInitialise);

    await flutterLocalNotificationsPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (notification) {
        try {
          final payload = notification.payload;
          if (payload != null && payload.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return NewPage(info: payload.toString());
              }),
            );
          } else {
            //
          }
        } catch (e) {
          //
        }
      },
    );

    /// To listen to incoming notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      /// This is the only part that has to do with firebase notifications
      print("---------------------------onMessage------------------------");
      print("onMessage: ${message.notification?.title}/${message.notification?.body}");

      /// Everything from this section has to do with flutter local notifications
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification?.title.toString(),
        htmlFormatTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "dbfood",
        "dbfood",
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,

        /// save custom sound in
        /// android -> src -> res -> create a folder(raw) -> put sound there and paste exact name here
        sound: const RawResourceAndroidNotificationSound("chat"),
      );

      NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      // show the notification message
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

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

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(
          <String, dynamic>{
            "priority": "high",
            "data": <String, dynamic>{
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "status": "done",
              "title": title,
              "body": body,
            },
            "notification": <String, dynamic>{
              "title": title,
              "body": body,
              "android_channnel_id": "dbfood",
            },
            "to": token,
          },
        ),
      );

      print("Message sent successfully");
    } catch (e) {
      print("Error sending push notication message$e");
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
                  onTap: () async {
                    String name = usernameController.text.trim();
                    String titleText = titleController.text.trim();
                    String bodyText = bodyController.text.trim();

                    if (name != "") {
                      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(name).get();

                      final token = snap['token'];

                      print(token);

                      sendPushMessage(token, bodyText, titleText);
                    }
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
