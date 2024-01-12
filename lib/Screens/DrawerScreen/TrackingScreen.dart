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

  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      print("==== Start Tracking ====");
      data = await ApiService.liveTracking(serviceId);
      var e = data[0];
      _markers.clear();
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/red_car.png");
      _markers.add(Marker(
        markerId: MarkerId(e["vehicle_name"]),
        icon: markerIcon,
        position: LatLng(double.parse(e["lat"]), double.parse(e["lng"])),
      ));

      mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(double.parse(e["lat"]), double.parse(e["lng"])), 14));
      setState(() {});
      print("==== End Tracking ====");
    });
  }

  @override
  void dispose() {
    print("dispose");

    _timer?.cancel();
    super.dispose();
  }

  void fetchVehicles() async {
    SmartDialog.showLoading(msg: "Loading...");
    vehicles = await ApiService.vehicles();
    SmartDialog.dismiss();

    // vehicles.insert(0, {'serviceId': "all", 'vehReg': "ALL"});

    await initMap();

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
          titleSpacing: 0,
          title: Container(
            width: Get.width * 0.9,
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
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
                            selected == null
                                ? "Select Name"
                                : selected["vehReg"],
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 12.0),
          //     child: Row(
          //       children: [
          //         GestureDetector(
          //             onTap: () {
          //               Get.to(() => HomeScreen());
          //             },
          //             child: Icon(
          //               Icons.home,
          //               color: ThemeColor.primarycolor,
          //               size: 27,
          //             )),
          //         SizedBox(
          //           width: Get.size.width * 0.04,
          //         ),
          //       ],
          //     ),
          //   ),
          // ],
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
            fetchVehicles();
          },
        ),
      ),
    );
  }

  initMap() async {
    _markers.clear();
    for (int i = 0; i < vehicles.length; i++) {
      print(vehicles[i]);
      var trackingRes =
          await ApiService.liveTracking(vehicles[i]["serviceId"].toString());
      if (trackingRes.isNotEmpty) {
        var trackingInfo = trackingRes[0];
        print(trackingInfo);
        BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/red_car.png");
        _markers.add(Marker(
          markerId: MarkerId(trackingInfo["vehicle_name"]),
          icon: markerIcon,
          position: LatLng(double.parse(trackingInfo["lat"]),
              double.parse(trackingInfo["lng"])),
        ));

        if (i == 0) {
          mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(double.parse(trackingInfo["lat"]),
                  double.parse(trackingInfo["lng"])),
              14));
        }
      }
    }
  }
}
