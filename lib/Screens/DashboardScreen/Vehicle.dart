import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/VehicleDetailScreen.dart';
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
    filteredItems = vehiclesData;
    SmartDialog.dismiss();
    setState(() {});
  }

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
              width: double.infinity,
              alignment: Alignment.center,
              child: new Stack(alignment: Alignment.center, children: <Widget>[
                Image(
                  image: AssetImage('assets/images/search.png'),
                  width: Get.width * 0.8,
                ),
                TextField(
                  textAlign: TextAlign.start,
                  autocorrect: false,
                  controller: searchCtrl,
                  onChanged: (e) {
                    print(e.toString());
                    search(e);
                  },
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: Get.width * 0.23),
                    hintText: 'Search Vehicle',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: filteredItems.isEmpty
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
                      return InkWell(
                        onTap: () {
                          Get.to(() => VehicleDetailScreen(
                                serviceId: vehicle["VehicleId"],
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 3,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Image.network(
                                    '${vehicle['icon_url']}',
                                    width: 50,
                                  ),
                                  Text("${vehicle['TotalDistance'].toString()}km"),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            vehicle['Name'],
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 20),
                                          ),
                                        ),
                                        onIgnitionData(vehicle['Ignition']),
                                        SizedBox(width: 16),
                                        vehicle['signal_percent'] != "0"
                                            ? Image.asset(
                                                "assets/images/rsz_signal_tower_off.png",
                                                height: 27,
                                                width: 27,
                                                color: Colors.red,
                                              )
                                            : Image.asset(
                                                "assets/images/rsz_signal_tower_off.png",
                                                height: 27,
                                                width: 27,
                                              ),
                                        SizedBox(width: 16),
                                        onACData(vehicle['AC']),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${vehicle["LastContact"]}',
                                          style: TextStyle(
                                              color: Colors.yellow[800],
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    FutureBuilder(
                                        future: placemarkFromCoordinates(
                                            vehicle["Latitude"],
                                            vehicle["Longitude"]),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData &&
                                              snapshot.data != null) {
                                            var place = snapshot.data![0];
                                            return Text(
                                                '${place.street ?? ""}, ${place.name ?? ""} ${place.subLocality ?? ""}, ${place.subAdministrativeArea ?? ""}, ${place.postalCode ?? ""}, ${place.country ?? ""}',
                                                style: TextStyle(fontSize: 16));
                                          }
                                          return Text("Loading...");
                                        })
                                  ],
                                ),
                              ),
                            ],
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

  onIgnitionData(ignition) {
    String ignitionTxt = "rsz_battery_no_data";
    if (ignition == null ||
        ignition == "battery_no_data" ||
        ignition == "plug_no_data") {
      ignitionTxt = "rsz_battery_no_data";
    } else if (ignition == "Off") {
      ignitionTxt = "rsz_battery_ignition_off";
    } else if (ignition == "On") {
      ignitionTxt = "rsz_battery_ignition_on";
    } else if (ignition == "Idle") {
      ignitionTxt = "rsz_battery_ignition_idle";
    }

    return Image.asset(
      "assets/images/$ignitionTxt.png",
      width: 27,
    );
  }

  onACData(ac) {
    String acTxt = "freezer-safe";
    if (ac == null) {
      acTxt = "freezer-safe";
    } else if (ac == "OFF") {
      acTxt = "freezer-safe1";
    } else if (ac == "ON") {
      acTxt = "freezer-safe2";
    }

    return Image.asset(
      "assets/images/$acTxt.png",
      width: 27,
    );
  }
}
