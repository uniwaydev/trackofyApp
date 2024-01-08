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

  void updateAlert(alertId, notify) async {
    await ApiService.updateAlert(
        widget.serviceId.toString(), "$alertId", notify);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Update Successfully.")));
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
                          Text(alertData["alert_name"]),
                        ],
                      ),
                      Switch(
                        onChanged: (value) {
                          alertData["alert_type"] = value ? 1 : 0;
                          updateAlert(alertData["alert_id"], value);
                          setState(() {});
                        },
                        value: alertData["alert_type"] == 1,
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
