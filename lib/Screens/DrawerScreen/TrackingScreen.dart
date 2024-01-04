import 'dart:async';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/HomeScreen/HomeScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 14.0, tilt: 0, bearing: 0);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapCtrl;

  var selected;
  late List selectedList;

  late Timer _timer;

  @override
  void initState() {
    super.initState();

    fetchVehicles();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void fetchData(serviceId) async {
    data = await ApiService.liveTracking(serviceId);
    _markers.clear();
    if (data.isNotEmpty) {
      Timer.periodic(Duration(milliseconds: 5000), (timer) {
        var e = data[0];
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
        setState(() {});
      });
    }
  }

  void fetchVehicles() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();
    setState(() {});
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
                scaffoldKey.currentState!.openDrawer();
              },
              child: Icon(
                Icons.menu,
                color: Color(0xff1574a4),
              )),
          centerTitle: false,
          title: Container(
            width: Get.width * 0.7,
            child: Row(
              children: [
                Text(
                  "Tracking",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Container(
                  width: Get.width * 0.4,
                  child: PopupMenuButton(
                    onSelected: (item) {
                      setState(() {
                        print(item);
                        selected = item;
                        fetchData(item["serviceId"].toString());
                      });
                    },
                    itemBuilder: (BuildContext context) => vehicles
                        .map((e) => PopupMenuItem(
                              value: e,
                              child: Text(e["vehReg"] ?? ""),
                            ))
                        .toList(),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                          selected == null ? "Select Name" : selected["vehReg"],
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
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
                  SizedBox(
                    width: Get.size.width * 0.04,
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
        child: GoogleMap(
          initialCameraPosition: _kInitialPosition,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (controller) {
            mapCtrl = controller;
          },
        ),
      ),
    );
  }
}
