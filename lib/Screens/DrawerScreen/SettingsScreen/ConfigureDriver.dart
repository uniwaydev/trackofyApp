import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/ControlLocation.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/DriverManagement.dart';
import 'package:trackofyapp/Screens/DrawerScreen/SettingsScreen/VehiclePerformanceManagement.dart';
import 'package:trackofyapp/constants.dart';

class ConfigureDriver extends StatefulWidget {
  const ConfigureDriver({Key? key}) : super(key: key);

  @override
  State<ConfigureDriver> createState() => _ConfigureDriverState();
}

class _ConfigureDriverState extends State<ConfigureDriver> {
  bool ol = false;
  bool dr = false;
  bool htr = false;
  bool rtr = false;
  bool itr = false;
  bool ha = false;
  bool hb = false;

  List<String> data = [
    "OverSpeed Limit",
    "Distance Range",
    "Halt Time Range",
    "Running Time Range",
    "Idle Time Range",
    "Harsh Acceleration",
    "Harsh Braking"
  ];
  List<String> userChecked = [];

  String dropdownname = 'Select Frequency';

  // List of items in our dropdown menu
  var names = [
    'Select Frequency',
    "Daily",
    "Weekly",
    "Monthly",
    "Custom",
  ];
  bool isVisible = false;

  bool checkBoxValue = false;
  bool checkBoxValue2 = false;
  bool checkBoxValue3 = false;
  bool checkBoxValue4 = false;
  bool checkBoxValue5 = false;
  bool checkBoxValue6 = false;
  bool checkBoxValue7 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
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
                "Configure Driver Performance",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: ThemeColor.primarycolor,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: Get.size.height * 0.07,
                width: Get.size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color(0xffcbd5d5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.5), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton(
                    isExpanded: true,

                    underline: SizedBox(),

                    // Initial Value
                    value: dropdownname,
                    // Down Arrow Icon
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    // Array list of items
                    items: names.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownname = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Container(
                height: Get.size.height * 0.07,
                width: Get.size.width * 0.95,
                decoration: BoxDecoration(
                  color: Color(0xffcbd5d5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.5), //(x,y)
                      blurRadius: 3.0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Select Criterion Below*",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: Get.size.height * 0.24,
              child: ListView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        ListTile(
                          title: Text("OverSpeed Limit"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: ol,
                            onChanged: (
                              bool? value,
                            ) {
                              checkBoxValue = value!;
                              setState(() {
                                ol = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Distance Range"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: dr,
                            onChanged: (bool? value) {
                              checkBoxValue2 = value!;
                              setState(() {
                                dr = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Halt Time Range"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: htr,
                            onChanged: (bool? value) {
                              checkBoxValue3 = value!;
                              setState(() {
                                htr = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Running Time Range"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: rtr,
                            onChanged: (bool? value) {
                              checkBoxValue4 = value!;
                              setState(() {
                                rtr = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Idle Time Range"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: itr,
                            onChanged: (bool? value) {
                              checkBoxValue5 = value!;
                              setState(() {
                                itr = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Harsh Acceleration"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: ha,
                            onChanged: (bool? value) {
                              checkBoxValue6 = value!;
                              setState(() {
                                ha = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: Text("Harsh Braking"),
                          trailing: Checkbox(
                            checkColor: Colors.white,
                            value: hb,
                            onChanged: (bool? value) {
                              checkBoxValue7 = value!;
                              setState(() {
                                hb = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
            Visibility(
                visible: checkBoxValue,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        minmaxfield(context, "OverSpeed Limit(In KM/H)*"),
                      ],
                    ))),
            Visibility(
                visible: checkBoxValue2,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        minmaxfield(context, "Distance Range(In KM)*"),
                      ],
                    ))),
            Visibility(
                visible: checkBoxValue3,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        minmaxfield(context, "Halt Time Range(In Hr)*"),
                      ],
                    ))),
            Visibility(
                visible: checkBoxValue4,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        minmaxfield(context, "Running Time Range(In Hr)*"),
                      ],
                    ))),
            Visibility(
                visible: checkBoxValue5,
                child: Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        minmaxfield(context, "Idle Time Range(In Hr)*"),
                      ],
                    ))),
            Visibility(
              visible: checkBoxValue6,
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: harshfield(context, "Harsh Acceleration(In Count)*"),
              ),
            ),
            Visibility(
              visible: checkBoxValue7,
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: harshfield(context, "Harsh Breaking(In Count)*"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: Container(
                height: Get.size.height * 0.06,
                width: Get.size.width * 0.75,
                child: MaterialButton(
                  color: ThemeColor.darkblue,
                  onPressed: () {},
                  child: Center(
                      child: Text(
                    "CREATE DRIVER PERFORMANCE",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }
}

class CheckboxModel {
  String title;
  bool value;
  bool shouldToggle = true;
  VoidCallback? onToggle;
  CheckboxModel({
    required this.title,
    required this.value,
    this.onToggle,
    this.shouldToggle = true,
  }) {
    onToggle = this.toggle;
  }
  void toggle() {
    if (shouldToggle) value = !value;
  }

  void enable(bool state) => shouldToggle = state;
  bool get isEnabled => shouldToggle;
  VoidCallback? handler() {
    if (shouldToggle) {
      return onToggle;
    } else {
      return null;
    }
  }
}

minmaxfield(context, txt) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          txt,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        width: Get.size.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // minmaxtextfield(context, "Mini"),
              // minmaxtextfield(context, "Max"),
            ],
          ),
        ),
      ),
    ],
  );
}

harshfield(context, txt) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Text(
          txt,
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Get.size.height * 0.05,
              width: Get.size.width * 0.28,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      hintText: "Count",
                      hintStyle:
                          TextStyle(fontSize: 18, color: Colors.grey.shade500)),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
