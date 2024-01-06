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
import 'package:syncfusion_flutter_maps/maps.dart';

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
  MapType mapType = MapType.normal;

  String selectedMap = "Google";

  var vehicleData;
  var selected;
  late List selectedList;

  @override
  void initState() {
    super.initState();
    // SmartDialog.showLoading(msg: "Loading...");
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
      BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), "assets/images/red_car.png");
      _markers.add(Marker(
        markerId: MarkerId(e["vehicle_name"]),
        icon: markerIcon,
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
          titleSpacing: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Color(0xff1574a4),
                size: 24,
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
                    fontSize: 15,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  "${vehicleData != null ? vehicleData["lastcontact"] : "Last Contact"}",
                  style: TextStyle(
                    fontSize: 11,
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
                      showSelectMapDialog();
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.map,
                          size: 27,
                        ),
                        Text(
                          "Select Map",
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
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
                          "PLAYBACK",
                          style: TextStyle(
                            fontSize: 10,
                            color: ThemeColor.primarycolor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8,
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
                          "ALERT",
                          style: TextStyle(
                            fontSize: 10,
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
              child: Stack(
                children: [
                  onMap(),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        showMapTypeDialog();
                      },
                      child: Icon(
                        Icons.map,
                        size: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {
                        Get.to(() => PlaybackScreen(
                              serviceId: widget.serviceId,
                            ));
                      },
                      child: Icon(
                        Icons.my_location,
                        size: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 120,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {},
                      child: Icon(
                        Icons.share,
                        size: 27,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 170,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      mini: true,
                      onPressed: () {},
                      child: Icon(
                        Icons.car_repair,
                        size: 27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 12,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onVerticalDragStart: (details) {
                print("asd");
              },
              child: Container(
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
                        Text(
                          "Ignition",
                          style: TextStyle(fontSize: 10),
                        ),
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
                          "Battery(${vehicleData != null ? vehicleData["battery_percent_val"] : "0"})",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.grey,
                        ),
                        Text(
                          "AC",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        Icon(
                          Icons.door_back_door_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          "Door",
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Odometer (km)",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("1.72")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Today Distance (km)",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Speed (kmph)",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("0")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Last Parked",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Idle Since",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Max Speed (kmph)",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Vehicle Status",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Unit Battery",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Permit",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Insurance",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("1.72")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(
                            "Pollution",
                            style: TextStyle(fontSize: 10),
                          ),
                          Text("N/A")
                        ],
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: SizedBox.shrink(),
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
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  SizedBox(width: 16),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Alert!"),
                              titlePadding: EdgeInsets.all(16),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              content: Text(
                                  "Do you want to Immobilize your vehicle?\n!! When Immobilize, the vehicle will be in ARM state !!"),
                              actionsPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                              actions: [
                                TextButton(
                                  child: Text("NO"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text("YES"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 20,
                        ),
                        Text("To Immobilize",
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showMapTypeDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Normal"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.normal;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Satelite"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.satellite;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Terrain"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.terrain;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text("Hybrid"),
                    onTap: () {
                      setState(() {
                        mapType = MapType.hybrid;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  showSelectMapDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Google Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "Google";
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Bing Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "Bing";
                        Navigator.pop(context);
                      });
                    },
                  ),
                  ListTile(
                    title: Text("OpenStreet Map"),
                    onTap: () {
                      setState(() {
                        selectedMap = "OpenStreet";
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  onMap() {
    if (selectedMap == "Google") {
      return GoogleMap(
        initialCameraPosition: _kInitialPosition,
        markers: Set<Marker>.of(_markers),
        mapType: mapType,
        onMapCreated: (controller) {
          mapCtrl = controller;
          fetchData();
        },
      );
    } else if (selectedMap == "Bing") {
      return FutureBuilder(
          future: getBingUrlTemplate(
              'https://dev.virtualearth.net/REST/V1/Imagery/Metadata/RoadOnDemand?output=json&uriScheme=https&include=ImageryProviders&key=${BING_MAP_KEY}'),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              return SfMaps(
                layers: [
                  MapTileLayer(
                    initialZoomLevel: 14,
                    zoomPanBehavior: MapZoomPanBehavior(),
                    initialFocalLatLng: MapLatLng(28.644800, 77.216721),
                    initialMarkersCount: 1,
                    markerBuilder: (BuildContext context, int index) {
                      return MapMarker(
                        latitude: 28.644800,
                        longitude: 77.216721,
                        iconColor: Colors.white,
                        iconStrokeColor: Colors.black,
                        iconStrokeWidth: 2,
                        child: Image.asset(
                          "assets/images/red_car.png",
                          width: 30,
                        ),
                      );
                    },
                    urlTemplate: snapshot.data as String,
                  ),
                ],
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
    }
    return SfMaps(
      layers: [
        MapTileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          initialZoomLevel: 14,
          initialFocalLatLng: MapLatLng(28.644800, 77.216721),
          zoomPanBehavior: MapZoomPanBehavior(),
          initialMarkersCount: 1,
          markerBuilder: (BuildContext context, int index) {
            return MapMarker(
              latitude: 28.644800,
              longitude: 77.216721,
              iconColor: Colors.white,
              iconStrokeColor: Colors.black,
              iconStrokeWidth: 2,
              child: Image.asset(
                "assets/images/red_car.png",
                width: 30,
              ),
            );
          },
        ),
      ],
    );
  }
}