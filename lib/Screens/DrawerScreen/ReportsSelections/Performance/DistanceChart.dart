import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:http/http.dart' as http;

class DistanceChart extends StatefulWidget {
  const DistanceChart({Key? key}) : super(key: key);

  @override
  State<DistanceChart> createState() => _DistanceChartState();
}

class _DistanceChartState extends State<DistanceChart> {
  List<Map<String, dynamic>> vehiclesData = [];
  List<Map<String, dynamic>> filteredItems = [];
  String _query = '';
  String startDate = "";
  String endDate = "";

  @override
  void initState() {
    super.initState();

    // Call the API when the widget is first created
    fetchData();
    startDate = endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
    vehiclesData = await ApiService.getTodayDistance();
    setState(() {});
    SmartDialog.dismiss();
  }

  // var dlno =["DL1RTB8753","DL1ZA9366","DL1RTB8753","DL1ZA9366","DL1RTB8753","DL1ZA9366","DL1RTB8753","DL1ZA9366"];
  // var kms =["150.5","82.4","232.7","0","150.5","82.4","232.7","0"];

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
                "Distance Chart",
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
                      print(pickedDate.start);
                      print(pickedDate.end);

                      setState(() {
                        // dateinput.text =
                        //     formattedDate; //set output date to TextField value.
                        startDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate.start);
                        endDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate.end);
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            startDate,
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.calendar_month_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            endDate,
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: Color(0xffd6d7d7),
                  onPressed: () {
                    // setState(() {
                    //   filteredItems = vehiclesData
                    //       .sort()
                    //       .toList();
                    // });
                  },
                  child: Text(
                    "APPLY",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: Get.size.height * 0.07,
            width: Get.size.width,
            color: Color(0xffeeeeee),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Image.asset(
                    "assets/images/barpng-removebg-preview.png",
                    height: 30,
                  ),
                ),

                Container(
                  height: Get.size.height * 0.06,
                  width: Get.size.width * 0.80,
                  child:
                      new Stack(alignment: Alignment.center, children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/search.png'),
                      // width: 300,
                    ),
                    TextField(
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        onChanged: (value) {
                          search(value);
                        },
                        decoration:
                            //disable single line border below the text field
                            new InputDecoration.collapsed(
                                hintText: 'Search Vehicle',
                                hintStyle: TextStyle(color: Colors.grey))),
                  ]),
                ),
                // searchbox(context, (e) {
                //   search(e);
                // }, "Search Vehicle Name", Get.size.height * 0.06,
                //     Get.size.width * 0.80, Colors.transparent),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Vehicle Name",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff757575)),
                ),
                Text(
                  "Distance(in kms)",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff757575)),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: Get.size.height * 0.65,
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
                          //   scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final vehicle = filteredItems[index];
                            return Card(
                              elevation: 1,
                              child: Container(
                                width: Get.size.width * 0.95,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/car.png",
                                          height: 70,
                                        ),
                                        Text(
                                          vehicle['veh_name'],
                                          style: TextStyle(
                                              color: Color(0xff222222),
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Text(
                                        vehicle['distance']
                                            .truncate()
                                            .toString(),
                                        style: TextStyle(
                                            color: Color(0xff1666c0),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                  : ListView.builder(
                      itemCount: vehiclesData.length,
                      shrinkWrap: true,
                      //   scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final vehicle = vehiclesData[index];
                        return Card(
                          elevation: 1,
                          child: Container(
                            width: Get.size.width * 0.95,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/car.png",
                                      height: 70,
                                    ),
                                    Text(
                                      vehicle['veh_name'],
                                      style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                    vehicle['distance'].truncate().toString(),
                                    style: TextStyle(
                                        color: Color(0xff1666c0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
