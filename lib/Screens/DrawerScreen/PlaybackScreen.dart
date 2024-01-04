import 'dart:async';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/DrawerScreen/AlertSettingScreen.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaybackScreen extends StatefulWidget {
  var serviceId;
  PlaybackScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
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
  String startDate = "";
  String endDate = "";
  TextEditingController stoppageCtrl = TextEditingController();
  TextEditingController overspeedCtrl = TextEditingController();
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    stoppageCtrl.text = "10";
    overspeedCtrl.text = "60";
    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
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

  playback() async {
    if (isPlay == false) {
      isPlay = true;
      setState(() {});
      await ApiService.playback(
          widget.serviceId.toString(), startDate, endDate);
    } else {
      isPlay = false;
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
          title: Text(
            "Playback",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21,
              color: ThemeColor.primarycolor,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text("Stoppage(mins)",
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: stoppageCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Overspeed(kmph)",
                          style: TextStyle(color: Colors.white)),
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: TextFormField(
                          controller: overspeedCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xffc0c0c0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      DateTimeRange? pickedDate = await showDateRangePicker(
                        context: context,
                        initialDateRange: DateTimeRange(
                          start: DateTime.now(),
                          end: DateTime.now(),
                        ),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400.0,
                                ),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );

                      if (pickedDate != null) {
                        TimeOfDay? startPickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        TimeOfDay? endPickedTime = await showTimePicker(
                            context: context, initialTime: TimeOfDay.now());
                        print(pickedDate.start);
                        print(pickedDate.end);
                        print(startPickedTime.toString().padLeft(2, '0'));
                        setState(() {
                          startDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDate.start) +
                              " " +
                              (startPickedTime == null
                                  ? "00:00"
                                  : '${startPickedTime.hour.toString().padLeft(2, '0')}:${startPickedTime.minute.toString().padLeft(2, '0')}');
                          endDate = DateFormat('yyyy-MM-dd')
                                  .format(pickedDate.end) +
                              " " +
                              (endPickedTime == null
                                  ? "00:00"
                                  : '${endPickedTime.hour.toString().padLeft(2, '0')}:${endPickedTime.minute.toString().padLeft(2, '0')}');
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate,
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
                          endDate,
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      playback();
                    },
                    child: Icon(isPlay ? Icons.stop : Icons.play_arrow,
                        color: Colors.white, size: 48),
                  ),
                ],
              ),
            ),
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
          ],
        ),
      ),
    );
  }
}
