import 'dart:async';
import 'dart:math';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Screens/DrawerScreen/AlertSettingScreen.dart';
import 'package:trackofyapp/Screens/DrawerScreen/MapHelper.dart';
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
  double vLat = 19.018255973653343, vLng = 72.84793849278007;

  var vehicleData;

  var selected;
  late List selectedList;
  String startDate = "";
  String endDate = "";
  TextEditingController stoppageCtrl = TextEditingController();
  TextEditingController overspeedCtrl = TextEditingController();
  bool isPlay = false;
  int playbackSeep = 1;
  List<Map<String, dynamic>> playbackHist = [];
  List<LatLng> points = [];

  Set<Polyline> polylines = Set.from([]);
  int backIndex = 0;
  var curPlayHist;

  @override
  void initState() {
    super.initState();
    stoppageCtrl.text = "10";
    overspeedCtrl.text = "60";
    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  void fetchData() async {
    SmartDialog.showLoading(msg: "Loading...");
    playbackHist = await ApiService.playback(
        widget.serviceId.toString(), startDate, endDate);
    SmartDialog.dismiss();
    for (int i = 0; i < playbackHist.length; i++) {
      var histItem = playbackHist[i];
      LatLng histPos = LatLng(histItem["lat"], histItem["lng"]);
      points.add(histPos);
      if (i == 0) {
        BitmapDescriptor markerIcon = await MapHelper.getMarkerImageFromUrl(
            histItem["rotation_full_url"]);
        _markers.add(Marker(
            markerId: MarkerId(i.toString()),
            icon: markerIcon,
            position: histPos));
        mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(histPos, 14));
        curPlayHist = histItem;
      }
    }
    polylines = Set.from([
      Polyline(
        polylineId: PolylineId('1'),
        points: points,
        color: Colors.black,
        width: 4,
      )
    ]);
    setState(() {});
  }

  playback() async {
    isPlay = !isPlay;

    if (isPlay) {
      onBackTracking();
    }
    setState(() {});
  }

  onBackTracking() async {
    backIndex += playbackSeep * 2;

    var histItem = playbackHist[backIndex];
    curPlayHist = histItem;
    LatLng histPos = LatLng(histItem["lat"], histItem["lng"]);
    BitmapDescriptor markerIcon =
        await MapHelper.getMarkerImageFromUrl(histItem["rotation_full_url"]);
    _markers.clear();
    _markers.add(Marker(
        markerId: MarkerId(backIndex.toString()),
        icon: markerIcon,
        position: histPos,
        anchor: Offset(0.5, 0.5)));
    mapCtrl.animateCamera(CameraUpdate.newLatLngZoom(histPos, 14));
    setState(() {});

    Future.delayed(Duration(seconds: 1), () {
      onBackTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerClass(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
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
                color: Colors.black45,
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
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                  PopupMenuButton(
                    onSelected: (item) {
                      setState(() {
                        playbackSeep = int.parse(item.substring(0, 1));
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        ["1x", "2x", "3x", "4x", "5x"]
                            .map((e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Text("${playbackSeep}x",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      playback();
                    },
                    child: Icon(isPlay ? Icons.pause : Icons.play_arrow,
                        color: Colors.white, size: 48),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: curPlayHist == null
                  ? SizedBox.shrink()
                  : Text(
                      "Date: ${curPlayHist["date"]} Speed: ${curPlayHist["speed"]} ${"\n"} Odometer: ${curPlayHist["odometer"]}",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: _kInitialPosition,
                markers: Set<Marker>.of(_markers),
                polylines: polylines,
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

  // double getBearing(LatLng begin, LatLng end) {
  //   double lat = (begin.latitude - end.latitude).abs();

  //   double lng = (begin.longitude - end.longitude).abs();

  //   if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
  //     return degrees(atan(lng / lat));
  //   } else if (begin.latitude >= end.latitude &&
  //       begin.longitude < end.longitude) {
  //     return (90 - degrees(atan(lng / lat))) + 90;
  //   } else if (begin.latitude >= end.latitude &&
  //       begin.longitude >= end.longitude) {
  //     return degrees(atan(lng / lat)) + 180;
  //   } else if (begin.latitude < end.latitude &&
  //       begin.longitude >= end.longitude) {
  //     return (90 - degrees(atan(lng / lat))) + 270;
  //   }

  //   return -1;
  // }
}
