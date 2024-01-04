import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class AddGeofence extends StatefulWidget {
  const AddGeofence({Key? key}) : super(key: key);

  @override
  State<AddGeofence> createState() => _AddGeofenceState();
}

class _AddGeofenceState extends State<AddGeofence> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicleIds = [];

  List<Map<String, dynamic>> parkingData = [];
  String startTime = "";
  String endTime = "";

  @override
  void initState() {
    super.initState();
    startTime = endTime = DateFormat('HH:mm:ss').format(DateTime.now());
    fetchVehicle();
  }

  void fetchVehicle() async {
    vehicles = await ApiService.vehicles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add GeoFence",
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
                  GestureDetector(
                      onTap: () {
                        Get.to(() => HomeScreen());
                      },
                      child: Icon(
                        Icons.home,
                        color: ThemeColor.primarycolor,
                        size: 27,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                var p = await PlacesAutocomplete.show(
                    context: context,
                    mode: Mode.overlay,
                    apiKey: "AIzaSyAO-EodE9fDBFSL1q3-9fORq9ijwdbqwN8");
                print(p);
                // displayPrediction(p);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: Stack(alignment: Alignment.centerLeft, children: [
                  Icon(Icons.search, color: Colors.green),
                  Center(
                      child: Text("Search Location",
                          style: TextStyle(fontSize: 16)))
                ]),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                label: Text(
                  "Fence name",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child:
                    Text("No Place Selected", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    label: Text(
                      "Enter Radius(KM)",
                      style: TextStyle(
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              color: Color(0xffc0c0c0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      TimeOfDay? startPickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      TimeOfDay? endPickedTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      print(startPickedTime.toString().padLeft(2, '0'));
                      setState(() {
                        startTime = (startPickedTime == null
                            ? "00:00"
                            : '${startPickedTime.hour.toString().padLeft(2, '0')}:${startPickedTime.minute.toString().padLeft(2, '0')}');
                        endTime = (endPickedTime == null
                            ? "00:00"
                            : '${endPickedTime.hour.toString().padLeft(2, '0')}:${endPickedTime.minute.toString().padLeft(2, '0')}');
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startTime,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                        SizedBox(width: 24),
                        Text(
                          "to",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                        SizedBox(width: 24),
                        Text(
                          endTime,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    color: Color(0xffd6d7d7),
                    onPressed: () {},
                    child: Text(
                      "MAP",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  return CheckboxListTile(
                      value: selectedVehicleIds
                          .contains("${vehicles[index]["serviceId"]}"),
                      title: Text(vehicles[index]["vehReg"]),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedVehicleIds
                              .add("${vehicles[index]["serviceId"]}");
                        } else {
                          selectedVehicleIds.removeWhere((element) =>
                              element == "${vehicles[index]["serviceId"]}");
                        }

                        setState(() {});
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
