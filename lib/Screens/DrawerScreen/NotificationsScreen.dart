import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  List<NotificationMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getNotifications();
  }

  Future<void> _getNotifications() async {
    SmartDialog.showLoading(msg: "Loading...");
    messages = await ApiService.getNotifications();
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldkey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                scaffoldkey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notification",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => HomeScreen());
                    },
                    child: Icon(
                      Icons.home,
                      color: ThemeColor.primarycolor,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              height: Get.size.height * 0.03,
              width: Get.size.width * 0.99,
              child: Center(
                  child: Text(
                "You have ${messages.length} unread notifications",
                style: TextStyle(color: ThemeColor.greycolor),
              )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 05.0),
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: messages.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final message = messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Material(
                          elevation: 3,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        "assets/images/Screenshot_2022-09-17_154834-removebg-preview.png",
                                        height: 40),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 22.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Sent ON ${message.sentOn}",
                                              style: TextStyle(
                                                  color: ThemeColor.bluecolor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              message.message,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      // ListView.builder(
      //   itemCount: messages.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     final message = messages[index];
      //     return ListTile(
      //       title: Text(message.msgStatus),
      //       subtitle: Text(message.message),
      //       trailing: Text(message.sentOn),
      //     );
      //   },
      // ),
    );
  }
}

class NotificationMessage {
  final int id;
  final String msgStatus;
  final String message;
  final String sentOn;

  NotificationMessage({
    required this.id,
    required this.msgStatus,
    required this.message,
    required this.sentOn,
  });
}
