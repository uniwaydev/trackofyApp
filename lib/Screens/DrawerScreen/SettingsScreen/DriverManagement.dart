import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/AddDriverScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/ConfigureDriver.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class DriverManagement extends StatefulWidget {
  const DriverManagement({Key? key}) : super(key: key);

  @override
  State<DriverManagement> createState() => _DriverManagementState();
}

class _DriverManagementState extends State<DriverManagement> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.getDrivers();
    SmartDialog.dismiss();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Driver Management",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => AddDriverScreen());
                    },
                    child: Container(
                      height: Get.size.height * 0.08,
                      //           width: Get.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xffd6d7d7),
                          borderRadius: BorderRadius.circular(05)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/Untitled_design__4_-removebg-preview.png",
                            height: 23,
                          ),
                          Text(
                            "ADD DRIVER",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.size.width * 0.02,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ConfigureDriver());
                  },
                  child: Container(
                    height: Get.size.height * 0.08,
                    // width: Get.size.width * 0.55,
                    decoration: BoxDecoration(
                        color: Color(0xffd6d7d7),
                        borderRadius: BorderRadius.circular(05)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/Untitled_design__4_-removebg-preview.png",
                            height: 23,
                          ),
                          Text(
                            "CONFIGURE DRIVER PERFORMANCE",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var driverData = data[index];
                  return Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 3)
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(driverData["name"],
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("(${driverData["dob"]})",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("Address: ${driverData["address"]}",
                            style: TextStyle(fontSize: 15)),
                        Text("Mobile: ${driverData["mobile"]}",
                            style: TextStyle(fontSize: 15)),
                        Text("Email: ${driverData["email"]}",
                            style: TextStyle(fontSize: 15)),
                        Text(
                            "Emergency Contact: ${driverData["emergency_contact_no"]}",
                            style: TextStyle(fontSize: 15)),
                        Text("DL No: ${driverData["dl_no"]}",
                            style: TextStyle(fontSize: 15)),
                        Text("DL Issued Date: ${driverData["dl_issued"]}",
                            style: TextStyle(fontSize: 15)),
                        Text("DL Expiry Date: ${driverData["dl_expiry"]}",
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
