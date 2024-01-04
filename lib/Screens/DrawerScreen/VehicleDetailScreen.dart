import 'dart:async';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/AlertSettingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/PlaybackScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleDetailScreen extends StatefulWidget {
  var serviceId;
  VehicleDetailScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 14.0, tilt: 0, bearing: 0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;

  var vehicleData;

  var selected;
  late List selectedList;

  @override
  void initState() {
    super.initState();
    SmartDialog.showLoading(msg: "Loading...");
  }

  void fetchData() async {
    print("======");
    print(widget.serviceId);
    print("======");
    data = await ApiService.liveTracking(widget.serviceId.toString());
    _markers.clear();
    if (data.isNotEmpty) {
      var e = data[0];
      vehicleData = e;
      print("~~~~~~~~~~~~~");
      print(e);
      print("~~~~~~~~~~~~~");
      // final Uint8List markIcons = await getImages(e["icon"], 100);
      _markers.add(Marker(
        markerId: MarkerId(e["vehicle_name"]),
        // icon: await MarkerIcon.downloadResizePictureCircle(e["icon"],
        //     size: 100,
        //     addBorder: true,
        //     borderColor: Colors.white,
        //     borderSize: 15),
        position: LatLng(double.parse(e["lat"]), double.parse(e["lng"])),
      ));
      mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(double.parse(e["lat"]), double.parse(e["lng"])), 14));
      SmartDialog.dismiss();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
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
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${vehicleData != null ? vehicleData["vehicle_name"] : "Vehicle"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  "${vehicleData != null ? vehicleData["lastcontact"] : "Last Contact"}",
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0, top: 4),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PlaybackScreen(
                            serviceId: widget.serviceId,
                          ));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/Untitled_design-removebg-preview.png",
                          height: 27,
                          width: 27,
                        ),
                        Text(
                          "Play Back",
                          style: TextStyle(
                            fontSize: 16,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.04,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AlertSettingScreen(
                            serviceId: widget.serviceId,
                            vehicleName: vehicleData != null
                                ? vehicleData["vehicle_name"]
                                : "",
                          ));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/Untitled_design__11_-removebg-preview.png",
                          height: 27,
                          width: 27,
                        ),
                        Text(
                          "Alert",
                          style: TextStyle(
                            fontSize: 16,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: _kInitialPosition,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (controller) {
                  mapCtrl = controller;
                  fetchData();
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.integration_instructions_rounded,
                        color: Colors.grey,
                      ),
                      Text("Ignition"),
                    ],
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Icon(
                        Icons.battery_0_bar,
                        color: Colors.grey,
                      ),
                      Text(
                          "Battery(${vehicleData != null ? vehicleData["battery_percent_val"] : "0"})"),
                    ],
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                      Text("AC"),
                    ],
                  ),
                  SizedBox(width: 8),
                  Column(
                    children: [
                      Icon(
                        Icons.door_back_door_outlined,
                        color: Colors.grey,
                      ),
                      Text("Door"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        "${vehicleData != null ? vehicleData["address"] : ""}",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 16),
                  Column(
                    children: [
                      Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      Text("To Immobilze",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
