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
  List<String> selectedGroups = [];
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
    SmartDialog.showLoading(msg: 'Loading...');
    vehicles = await ApiService.vehiclesByGroup();
    SmartDialog.dismiss();
  }

  void fetchMaxSpeed() async {
    if (selectedVehicleIds.isEmpty) {
      SmartDialog.showToast("Please select Vehicles.");
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
                      onSelectVehicleDialog();
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
                          Expanded(
                            child: Text(
                                selectedVehicle.isEmpty
                                    ? "Select Vehicle"
                                    : selectedVehicle.join(","),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xffadadad))),
                          )
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              startDate,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ],
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 20,
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

  onSelectVehicleDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.all(16),
            title: Text("Select Vehicle"),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            content: Container(
              height: 400,
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter alertState) {
                return SingleChildScrollView(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: vehicles.length,
                      itemBuilder: (BuildContext context, int index) {
                        var groupInfo = vehicles[index];
                        var groupVehicles = List<Map<String, dynamic>>.from(
                            (groupInfo["result"]).map((item) => {
                                  'serviceId': item['service_id'],
                                  'vehReg': item['veh_reg'],
                                  'created': item['sys_created'],
                                  'renewalDue': item['sys_renewal_due'],
                                  'imei': item['imei'],
                                  'mobileNo': item['mobile_no'],
                                  'mobileNo1': item['mobile_no1'],
                                  'is_selected': false,
                                }));
                        print(groupInfo);
                        return Column(
                          children: [
                            CheckboxListTile(
                                contentPadding: EdgeInsets.all(0),
                                value: selectedGroups
                                    .contains(groupInfo["location"]),
                                title: Text(
                                  groupInfo["location"],
                                  style: TextStyle(
                                      color: ThemeColor.primarycolor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    selectedGroups.add(groupInfo["location"]);

                                    for (var vInfo in groupVehicles) {
                                      selectedVehicle.add(vInfo["vehReg"]);
                                      selectedVehicleIds
                                          .add("${vInfo["serviceId"]}");
                                    }
                                  } else {
                                    selectedGroups.removeWhere((element) =>
                                        element == groupInfo["location"]);
                                    for (var vInfo in groupVehicles) {
                                      selectedVehicle.removeWhere((element) =>
                                          element == vInfo["vehReg"]);
                                      selectedVehicleIds.removeWhere(
                                          (element) =>
                                              element ==
                                              "${vInfo["serviceId"]}");
                                    }
                                  }
                                  alertState(() {});
                                }),
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: groupVehicles.length,
                                itemBuilder:
                                    (BuildContext context, int vIndex) {
                                  var vehicleInfo = groupVehicles[vIndex];
                                  print(vehicleInfo);
                                  return Column(
                                    children: [
                                      CheckboxListTile(
                                          value: selectedVehicle
                                              .contains(vehicleInfo["vehReg"]),
                                          title: Text(
                                            vehicleInfo["vehReg"],
                                          ),
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              selectedVehicle
                                                  .add(vehicleInfo["vehReg"]);
                                              selectedVehicleIds.add(
                                                  "${vehicleInfo["serviceId"]}");
                                            } else {
                                              selectedVehicle.removeWhere(
                                                  (element) =>
                                                      element ==
                                                      vehicleInfo["vehReg"]);
                                              selectedVehicleIds.removeWhere(
                                                  (element) =>
                                                      element ==
                                                      "${vehicleInfo["serviceId"]}");
                                            }
                                            alertState(() {});
                                          }),
                                    ],
                                  );
                                })
                          ],
                        );
                      }),
                );
              }),
            ),
            actionsPadding: EdgeInsets.all(0),
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
  }
}
