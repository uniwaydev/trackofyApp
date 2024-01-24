import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/Services/ApiService.dart';
import 'package:trackofyapp/Widgets/drawer.dart';
import 'package:trackofyapp/Widgets/widgets.dart';
import 'package:trackofyapp/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AlertSettingScreen extends StatefulWidget {
  var serviceId;
  var vehicleName;
  AlertSettingScreen(
      {Key? key, required this.serviceId, required this.vehicleName})
      : super(key: key);

  @override
  State<AlertSettingScreen> createState() => _AlertSettingScreenState();
}

class _AlertSettingScreenState extends State<AlertSettingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print("======");
    print(widget.serviceId);
    print("======");
    SmartDialog.showLoading(msg: "Loading...");
    data = await ApiService.getVehicleAlerts(widget.serviceId.toString());
    print("======");
    print(data);
    print("======");
    SmartDialog.dismiss();

    setState(() {});
  }

  updateAlert(alertId, notify) async {
    SmartDialog.showLoading(msg: "Loading...");
    var res = await ApiService.updateAlert(
        widget.serviceId.toString(), "$alertId", notify);
    SmartDialog.dismiss();
    SmartDialog.showToast(res
        ? "Update Successfully"
        : "An error occurred while communicating with the server.");
    return res;
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
              )),
          centerTitle: false,
          title: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Alert Setting",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: ThemeColor.primarycolor,
                  ),
                ),
                Text(
                  widget.vehicleName,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeColor.primarycolor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var alertData = data[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                      )
                    ],
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Builder(builder: (context) {
                            String img = "assets/images/information.png";
                            if (alertData["alert_type"] == null) {
                              img = "assets/images/information.png";
                            } else if (alertData["alert_type"] == "Door") {
                              img = "assets/images/ic_door_new.PNG";
                            } else if (alertData["alert_type"] == "AC") {
                              img = "assets/images/ic_ac_new.PNG";
                            } else if (alertData["alert_type"] == "Ignition") {
                              img = "assets/images/ic_ignition_new.PNG";
                            } else if (alertData["alert_type"] ==
                                "Main Power") {
                              img = "assets/images/plug.png";
                            } else if (alertData["alert_type"] == "Panic") {
                              img = "assets/images/ic_speed_new.PNG";
                            } else if (alertData["alert_type"] == "Speed") {
                              img = "assets/images/stop-sign.png";
                            }
                            return Image.asset(img, width: 20);
                          }),
                          SizedBox(width: 8),
                          Text(alertData["alert_type"] ?? ""),
                        ],
                      ),
                      Switch(
                        onChanged: (value) async {
                          var res = await updateAlert(
                              alertData["alert_setting_id"],
                              value ? "true" : "false");
                          if (res) {
                            setState(() {
                              alertData["is_notification"] = value ? 1 : 0;
                            });
                          }
                        },
                        value: alertData["is_notification"] == 1,
                        activeColor: Color(0xff524f54),
                        activeTrackColor: Color(0xffa8b8c7),
                        inactiveThumbColor: Color(0xffececec),
                        inactiveTrackColor: Color(0xff8ea0ad),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
