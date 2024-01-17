import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class Vehicle extends StatefulWidget {
  const Vehicle({Key? key}) : super(key: key);

  @override
  State<Vehicle> createState() => _VehicleState();
}

class _VehicleState extends State<Vehicle> {
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
              (item) => item['Name'].toLowerCase().contains(
                    _query.toLowerCase(),
                  ),
            )
            .toList();
      },
    );
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: 'Loading...');
    vehiclesData = await ApiService.getVehicles();
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
                "Vehicles",
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
              alignment: Alignment.center,
              child: new Stack(alignment: Alignment.center, children: <Widget>[
                Image(
                  image: AssetImage('assets/images/search.png'),
                  width: 400,
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
                        //  shrinkWrap: true,
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
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Image.network(
                                          '${vehicle['icon_url']}',
                                          width: 70,
                                          height: 120,
                                        ),
                                        Text("${vehicle['Speed']}km"),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                vehicle['Name'],
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20),
                                              ),
                                              vehicle['AC'] != "OFF"
                                                  ? Image.asset(
                                                      "assets/images/freezer-safe1.png",
                                                      height: 27,
                                                      width: 27,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/freezer-safe.png",
                                                      height: 27,
                                                      width: 27,
                                                    ),
                                              vehicle['signal_percent'] != "0"
                                                  ? Image.asset(
                                                      "assets/images/rsz_signal_tower_off.png",
                                                      height: 27,
                                                      width: 27,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/rsz_signal_tower_off.png",
                                                      height: 27,
                                                      width: 27,
                                                    ),
                                              vehicle['Ignition'] !=
                                                      'plug_no_data'
                                                  ? vehicle['Ignition'] !=
                                                          'plug_ignition_on'
                                                      ? vehicle['Ignition'] !=
                                                              'plug_ignition_off'
                                                          ? Image.asset(
                                                              "assets/images/rsz_plug_no_data.png",
                                                              height: 27,
                                                              width: 27,
                                                            )
                                                          : Image.asset(
                                                              "assets/images/rsz_plug_ignition_on.png",
                                                              height: 27,
                                                              width: 27,
                                                            )
                                                      : Image.asset(
                                                          "assets/images/rsz_plug_ignition_off.png",
                                                          height: 27,
                                                          width: 27,
                                                        )
                                                  : Image.asset(
                                                      "assets/images/rsz_plug_ignition_idle.png",
                                                      height: 27,
                                                      width: 27,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${vehicle["LastContact"]}',
                                                style: TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(vehicle['Address']),
                                        ],
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Image.network(
                                      '${vehicle['icon_url']}',
                                      width: 70,
                                      height: 120,
                                    ),
                                    Text("${vehicle['Speed']}km"),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            vehicle['Name'],
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: vehicle['AC'] != "OFF"
                                                ? Image.asset(
                                                    "assets/images/freezer-safe1.png",
                                                    height: 27,
                                                    width: 27,
                                                  )
                                                : Image.asset(
                                                    "assets/images/freezer-safe.png",
                                                    height: 27,
                                                    width: 27,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          vehicle['signal_percent'] != "0"
                                              ? Image.asset(
                                                  "assets/images/rsz_signal_tower_off.png",
                                                  height: 27,
                                                  width: 27,
                                                )
                                              : Image.asset(
                                                  "assets/images/rsz_signal_tower_off.png",
                                                  height: 27,
                                                  width: 27,
                                                ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          vehicle['Ignition'] != 'plug_no_data'
                                              ? vehicle['Ignition'] !=
                                                      'plug_ignition_on'
                                                  ? vehicle['Ignition'] !=
                                                          'plug_ignition_off'
                                                      ? Image.asset(
                                                          "assets/images/rsz_plug_no_data.png",
                                                          height: 27,
                                                          width: 27,
                                                        )
                                                      : Image.asset(
                                                          "assets/images/rsz_plug_ignition_on.png",
                                                          height: 27,
                                                          width: 27,
                                                        )
                                                  : Image.asset(
                                                      "assets/images/rsz_plug_ignition_off.png",
                                                      height: 27,
                                                      width: 27,
                                                    )
                                              : Image.asset(
                                                  "assets/images/rsz_plug_ignition_idle.png",
                                                  height: 27,
                                                  width: 27,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${vehicle["LastContact"]}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(vehicle['Address']),
                                    ],
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
