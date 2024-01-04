import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/constants.dart';

class RunningSummary extends StatefulWidget {
  const RunningSummary({Key? key}) : super(key: key);

  @override
  State<RunningSummary> createState() => _RunningSummaryState();
}

class _RunningSummaryState extends State<RunningSummary> {
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

    startDate = endDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    fetchVehicle();
  }

  void fetchVehicle() async {
    vehicles = await ApiService.vehicles();
  }

  void fetchData() async {
    if (selectedVehicleIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select Vehicles")));
      return;
    }
    data = await ApiService.runningSummaryReport(
        selectedVehicleIds.join(","), startDate, endDate);

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
                "Running Summary",
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
                MaterialButton(
                  color: Color(0xffd6d7d7),
                  onPressed: () {
                    fetchData();
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
                        "Please apply to see Running Summary",
                        style: TextStyle(
                            color: Color(
                              0xff757575,
                            ),
                            fontSize: 15),
                      )
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: data.map((e) => stoppageItem(e)).toList(),
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget stoppageItem(e) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(1, 1),
              blurRadius: 2,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            e["vehiclename"],
            style: TextStyle(
                fontSize: 18,
                color: Colors.blue[300],
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Get Address",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          SizedBox(
            height: 8,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            border: TableBorder.all(width: 1, color: Colors.black),
            children: [
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Halt Time"),
                      Text("${e["totalhalttime"] ?? "N/A"}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Max Halt"),
                      Text("${e["maxhalt"] ?? "N/A"}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Halt Duration"),
                      Text("${e["halt_start_time"] ?? "N/A"} - "),
                      Text("${e["halt_end_time"] ?? "N/A"}"),
                    ],
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Distance"),
                      Text("${e["total_distance"] ?? "N/A"}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Running Time"),
                      Text("${e["totalrunningtime"] ?? "N/A"}"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Total Idle Time"),
                      Text("${e["totalidletime"] ?? "N/A"}"),
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
