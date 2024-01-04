import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class MaximumSpeedChart extends StatefulWidget {
  const MaximumSpeedChart({Key? key}) : super(key: key);

  @override
  State<MaximumSpeedChart> createState() => _MaximumSpeedChartState();
}

class _MaximumSpeedChartState extends State<MaximumSpeedChart> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> vehicles = [];
  List<String> selectedVehicle = [];
  List<String> selectedVehicleIds = [];
  String startDate = "";
  String endDate = "";
  bool isApply = false;
  @override
  void initState() {
    super.initState();

    startDate = endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Call the API when the widget is first created
    fetchData();
  }

  void fetchData() async {
    vehicles = await ApiService.vehicles();
  }

  void fetchMaxSpeed() async {
    if (selectedVehicleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select Vehicles")));
      return;
    }
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.speedReport(
        selectedVehicleIds.join(","), startDate, endDate);
    SmartDialog.dismiss();
    print(data);
    setState(() {
      this.isApply = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe2e2e2),
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
                "Max Speed Chart",
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
          Stack(
            children: [
              Container(
                color: Color(0xffe2e2e2),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select Vehicle"),
                              content: Container(
                                width: 300,
                                height: 400,
                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter alertState) {
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: vehicles.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CheckboxListTile(
                                            value: selectedVehicle.contains(
                                                vehicles[index]["vehReg"]),
                                            title:
                                                Text(vehicles[index]["vehReg"]),
                                            onChanged: (bool? value) {
                                              if (value == true) {
                                                selectedVehicle.add(
                                                    vehicles[index]["vehReg"]);
                                                selectedVehicleIds.add(
                                                    "${vehicles[index]["serviceId"]}");
                                              } else {
                                                selectedVehicle.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        vehicles[index]
                                                            ["vehReg"]);
                                                selectedVehicleIds.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        "${vehicles[index]["serviceId"]}");
                                              }
                                              alertState(() {
                                                vehicles[index]["is_selected"] =
                                                    value;
                                              });
                                            });
                                      });
                                }),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text("Confirm")),
                              ],
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              selectedVehicle.isEmpty
                                  ? "Select Vehicle"
                                  : selectedVehicle.join(","),
                              style: TextStyle(color: Color(0xffadadad))),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
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
                      print(pickedDate.start);
                      print(pickedDate.end);
                      setState(() {
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
                MaterialButton(
                  color: Color(0xffd6d7d7),
                  onPressed: () {
                    fetchMaxSpeed();
                  },
                  child: Text(
                    "APPLY",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: !isApply
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/bluecar-removebg-preview.png",
                        height: 30,
                      ),
                      Text(
                        "Please apply to see MaxSpeed Report",
                        style: TextStyle(
                            color: Color(
                              0xff757575,
                            ),
                            fontSize: 15),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          rowChart("SN", "Vehicle Name", "1 Day", "2 Day",
                              "3 Day", Colors.blue),
                          for (int i = 0; i < data.length; i++)
                            rowChart(
                                "${i + 1}",
                                data[i]["vehicle"],
                                "${data[i]["days"][0]}",
                                "${data[i]["days"].length > 1 ? data[i]["days"][1] : 0}",
                                "${data[i]["days"].length > 2 ? data[i]["days"][2] : 0}",
                                Colors.black),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  rowChart(sn, vehiclename, oneDay, twoDay, threeDay, color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: Get.size.width * 0.1,
          child: Text(
            sn,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
        Container(
          width: Get.size.width * 0.35,
          child: Text(
            vehiclename,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
        Container(
          width: Get.size.width * 0.12,
          child: Text(
            oneDay,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
        Container(
          width: Get.size.width * 0.12,
          child: Text(
            twoDay,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
        Container(
          width: Get.size.width * 0.12,
          child: Text(
            threeDay,
            style: TextStyle(fontSize: 16, color: color),
          ),
        ),
      ],
    );
  }
}
