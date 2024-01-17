import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class FleetSummary extends StatefulWidget {
  const FleetSummary({Key? key}) : super(key: key);

  @override
  State<FleetSummary> createState() => _FleetSummaryState();
}

class _FleetSummaryState extends State<FleetSummary> {
  List<Map<String, dynamic>> vehiclesData = [];
  List<Map<String, dynamic>> filteredItems = [];
  TextEditingController searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    searchCtrl.text = "";
    // Call the API when the widget is first created
    fetchData();
  }

  void search(String query) {
    setState(
      () {
        _query = query;
        filteredItems = vehiclesData
            .where(
              (item) => item['veh_name'].toLowerCase().contains(
                    _query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: 'Loading...');
    vehiclesData = await ApiService.fleetSummar();
    setState(() {});
    SmartDialog.dismiss();
  }

  // List<String> distance = ["90","90","90","90","90","90"];
  // List<String> idle = ["90","90","90","90","90","90"];
  // List<String> halt= ["90","90","90","90","90","90"];
  // var vehicleno = ["DL1ZB9393","DL1ZB9393","DL1ZB9393","DL1ZB9393","DL1ZB9393","DL1ZB9393",];
  // var contactdate =["09-23-2022","09-23-2022","09-23-2022","09-23-2022","09-23-2022","09-23-2022",];
  // var contacttime =["14:22","14:22","14:22","14:22","14:22","14:22",];
  // var adress = ["Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",
  //   "Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",
  //       "Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",
  //       "Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",
  //   "Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",
  //       "Indra Gandhi Rd, Police Colony, Mehram Nagar, New Delhi,\nDelhi 110010,india",];
  // var speed =["50","50","50","50","50","50",];

  //var distance = ["90","90","90","90","90","90"];
  // var idlesince = [90.9, 0, 0, 90, 90];
  // var Haltsince = [90.9, 0, 0, 90, 90];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
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
                "Fleet Summary",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: Get.size.height * 0.08,
              width: Get.size.width * 1.00,
              color: Color(0xffe2e2e2),
              alignment: Alignment.center,
              child: new Stack(alignment: Alignment.center, children: <Widget>[
                Image(
                  image: AssetImage('assets/images/search.png'),
                  width: Get.width * 0.8,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    autocorrect: false,
                    controller: searchCtrl,
                    onChanged: (e) {
                      print(e.toString());
                      search(e);
                    },
                    decoration:
                        //disable single line border below the text field
                        new InputDecoration.collapsed(
                            hintText: 'Search Vehicle',
                            hintStyle: TextStyle(color: Colors.grey))),
              ]),
            ),
          ),
          Container(
            height: Get.size.height * 0.78,
            child: filteredItems.isNotEmpty || _query.isNotEmpty
                ? filteredItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No Results Found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredItems.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final vehicle = filteredItems[index];
                          return Card(
                            elevation: 3,
                            child: Container(
                              height: Get.size.height * 0.2,
                              width: Get.size.width * 0.95,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        vehicle['veh_name'],
                                        style: TextStyle(
                                            color: Color(0xfff3c331),
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Last Contact:",
                                          style: TextStyle(
                                            color: Color(0xff464646),
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          vehicle['last_contact'],
                                          style: TextStyle(
                                            color: Color(0xff464646),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      vehicle['address'],
                                      style: TextStyle(
                                        color: Color(0xff2f9df4),
                                        fontSize: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Container(
                                        height: Get.size.height * 0.1,
                                        width: Get.size.width * 0.90,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.black)),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: Get.size.height * 0.1,
                                              width: Get.size.width * 0.2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Speed",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      vehicle['speed']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            VerticalDivider(
                                              thickness: 1,
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                            Container(
                                              height: Get.size.height * 0.1,
                                              width: Get.size.width * 0.22,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Distance",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      vehicle['distance']
                                                          .truncate()
                                                          .toString(),
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            VerticalDivider(
                                              thickness: 1,
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                            Container(
                                              height: Get.size.height * 0.1,
                                              width: Get.size.width * 0.22,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Idle Since",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      vehicle['idealtime'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            VerticalDivider(
                                              thickness: 1,
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                            Container(
                                              height: Get.size.height * 0.1,
                                              width: Get.size.width * 0.22,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Halt Since",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      vehicle['halttime'],
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff828282),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                : ListView.builder(
                    itemCount: vehiclesData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      final vehicle = vehiclesData[index];
                      return Card(
                        elevation: 3,
                        child: Container(
                          height: Get.size.height * 0.2,
                          width: Get.size.width * 0.95,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    vehicle['veh_name'],
                                    style: TextStyle(
                                        color: Color(0xfff3c331),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Last Contact:",
                                      style: TextStyle(
                                        color: Color(0xff464646),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      vehicle['last_contact'],
                                      style: TextStyle(
                                        color: Color(0xff464646),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  vehicle['address'],
                                  style: TextStyle(
                                    color: Color(0xff2f9df4),
                                    fontSize: 15,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    height: Get.size.height * 0.1,
                                    width: Get.size.width * 0.90,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: Get.size.height * 0.1,
                                          width: Get.size.width * 0.2,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Speed",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  vehicle['speed'].toString(),
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.1,
                                          width: Get.size.width * 0.22,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Distance",
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  vehicle['distance']
                                                      .truncate()
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.1,
                                          width: Get.size.width * 0.22,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Idle Since",
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  vehicle['idealtime'],
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          width: 1,
                                          color: Colors.black,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.1,
                                          width: Get.size.width * 0.22,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 6.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Halt Since",
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  vehicle['halttime'],
                                                  style: TextStyle(
                                                    color: Color(0xff828282),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
