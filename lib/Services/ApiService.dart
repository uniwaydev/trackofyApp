import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackofyapp/Models/User.dart';
import 'package:trackofyapp/Screens/DrawerScreen/NotificationsScreen.dart';

class ApiService {
  static var client = http.Client();
  // static var BASE_URL = "http://trackofy.fasttracksoft.us";
  static var BASE_URL = "https://trackofy.com";
  static var API_URL = BASE_URL + "/API/trackofy_app.php";
  static var USER_API_URL = BASE_URL + "/API/user_api.php";
  static User? currentUser;

  static showMessage(title, content) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future login(String username, String password) async {
    try {
      var response = await client.get(Uri.parse(
          API_URL + "?method=login&username=$username&sys_password=$password"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        User user = User.fromJson(data['user_detail'][0]);
        print(response.body);
        if (user.sys_username.toLowerCase() == username && user.id != 0) {
          currentUser = user;
          return true;
        } else {
          showMessage('Login Error', data['msg']);
        }
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Somthing went wrong.');
    }
  }

  static Future getMenu() async {
    try {
      var response = await client.get(Uri.parse(
          API_URL + "?method=get_user_menu&user_id=${currentUser!.id}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Somthing went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> vehicles() async {
    try {
      var response = await client.post(Uri.parse(USER_API_URL), body: {
        'method': 'get_user_vehicles',
        'user_id': currentUser!.id.toString()
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data.map((item) => {
              'serviceId': item['service_id'],
              'vehReg': item['veh_reg'],
              'created': item['sys_created'],
              'renewalDue': item['sys_renewal_due'],
              'imei': item['imei'],
              'mobileNo': item['mobile_no'],
              'mobileNo1': item['mobile_no1'],
              'is_selected': false,
            }));
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Somthing went wrong.');
      return List.empty();
    }
  }

  static Future vehicleInfo(vehicleId) async {
    try {
      var response = await client.get(Uri.parse(API_URL +
          "?method=vehicle_info&userid=${currentUser!.id}&vehid=${vehicleId}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future userDetail() async {
    try {
      var response = await client.get(Uri.parse(
          API_URL + "?method=user_more_detail&userid=${currentUser!.id}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future vehicleSummaryStatus() async {
    try {
      var response = await client.post(
          Uri.parse(
              BASE_URL + "/API/trackofy_app.php?method=vehicle_summary_status"),
          body: {"user_id": currentUser?.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future haltDuration() async {
    try {
      var response = await client.post(
          Uri.parse(
              BASE_URL + "/API/dashboard_api.php?method=get_halt_duration"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 00:00:00"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future runningDuration() async {
    try {
      var response = await client.post(
          Uri.parse(
              BASE_URL + "/API/dashboard_api.php?method=get_run_duration"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 00:00:00"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future idleDuration() async {
    try {
      var response = await client.post(
          Uri.parse(
              BASE_URL + "/API/dashboard_api.php?method=get_idle_duration"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 00:00:00"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future alertData() async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/dashboard_api.php?method=get_alert_count"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 23:59:59",
            "alert_type": "All"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List.from(data)[0];
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future overSpeed() async {
    try {
      var response = await client.post(
          Uri.parse(
              BASE_URL + "/API/dashboard_api.php?method=get_overspeed_count"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 00:00:00"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future maintenance() async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/dashboard_api.php?method=maintenance_reminder&user_id=${currentUser?.id.toString()}&due_in_days=30"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future deviceRenewal() async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/dashboard_api.php?method=get_device_renewal_count&user_id=${currentUser?.id.toString()}&expiry_in_days=15"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future geoFenceAlert() async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/dashboard_api.php?method=get_alert_count"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 23:59:59",
            "alert_type": "Geofence"
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List.from(data)[0];
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future getServiceLimitCount() async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/dashboard_api.php?method=get_service_limit_counts&user_id=${currentUser?.id.toString()}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future getVehiclePerformance() async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL +
              "/API/trackofy_app.php?method=get_vehicle_performance"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 23:59:59",
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future getHaltStatus() async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=get_halt_status"),
          body: {
            "user_id": currentUser?.id.toString(),
            "start_date": "2023-10-12 00:00:00",
            "end_date": "2023-10-12 23:59:59",
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future getDistanceDetail() async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/dashboard_api.php?method=get_distance_detail&user_id=${currentUser?.id.toString()}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return null;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getVehicleAlerts() async {
    try {
      var response = await client.get(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=get_all_alerts"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<bool> updateAlert(serviceId, alertId, notify) async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=create_alert"),
          body: {
            "user_id": currentUser?.id.toString(),
            "sys_service_id": serviceId,
            "alert_id": alertId,
            "notification_on": notify.toString()
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future vehicleStatus() async {
    try {
      var response = await client.get(Uri.parse(
          API_URL + "?method=vehcicle_status_data&userid=${currentUser!.id}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> liveTracking(serviceId) async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=live_tracking"),
          body: {
            "user_id": currentUser?.id.toString(),
            "service_id": serviceId
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<bool> playback(serviceId, sdate, edate) async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=playback_api"),
          body: {
            "user_id": currentUser?.id.toString(),
            "service_id": serviceId,
            "start_date": sdate,
            "end_date": edate
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future dateFormat(inputDate) async {
    try {
      var response = await client.get(Uri.parse(API_URL +
          "?method=dateFormat&user_id=${currentUser!.id}&input_date=$inputDate"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> getTodayDistance() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=get_today_distance"),
          body: {"user_id": currentUser!.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data.map((item) => {
              'veh_name': item['Vehiclename'],
              'distance': item['TotalDistance'],
            }));
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future<List<Map<String, dynamic>>> fleetSummar() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=fleet_summar_api"),
          body: {"user_id": currentUser!.id.toString()});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var vehiclesData = List<Map<String, dynamic>>.from(data.map((item) => {
              'veh_name': item['veh_name'],
              'last_contact': item['lastcontact'],
              'lat_long': item['latlong'],
              'speed': item['speed'],
              'distance': item['distance'],
              'idealtime': item['idle_time'],
              'halttime': item['halt_time'],
            }));
        return vehiclesData;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future getAlertCount() async {
    try {
      var response = await client.get(Uri.parse(
          API_URL + "?method=get_alert_count&UserId=${currentUser!.id}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future getDistanceRange(sdate, edate) async {
    try {
      var response = await client.get(Uri.parse(API_URL +
          "?method=get_distance_range_report&UserId=${currentUser!.id}&sdate=$sdate&edate=$edate"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> vehicleSummaryReport(
      sdate, edate) async {
    try {
      var response = await client
          .post(Uri.parse(API_URL + "?method=vehicle_summary_report"), body: {
        "user_id": currentUser!.id.toString(),
        "start_date": sdate,
        "end_date": edate
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future<List<Map<String, dynamic>>> speedReport(
      sid, sdate, edate) async {
    print(sid);
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=speed_report"),
          body: {
            "sys_service_id": sid,
            "start_date": sdate,
            "end_date": edate
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> runningSummaryReport(
      sids, sdate, edate) async {
    try {
      var response = await client
          .post(Uri.parse(API_URL + "?method=running_summary_report"), body: {
        "user_id": currentUser?.id.toString(),
        "start_date": sdate,
        "end_date": edate,
        "sys_service_id": sids,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> stoppageSummaryReport(
      sids, sdate, edate) async {
    try {
      var response = await client
          .post(Uri.parse(API_URL + "?method=stoppage_summary_report"), body: {
        "user_id": currentUser?.id.toString(),
        "start_date": sdate,
        "end_date": edate,
        "sys_service_id": sids,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> tripReport(
      sids, sdate, edate) async {
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "start_date": sdate,
        "end_date": edate,
        "sys_service_id": sids,
        "method": "get_trip_report"
      });
      print({
        "user_id": currentUser?.id.toString(),
        "start_date": sdate,
        "end_date": edate,
        "sys_service_id": sids,
        "method": "get_trip_report"
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data["tripDetail"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getDrivers() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=get_driver_details"),
          body: {"user_id": currentUser?.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> AddDriverPerfermance(
    pid,
  ) async {
    try {
      var response = await client
          .post(Uri.parse(API_URL + "?method=save_driver_performance"), body: {
        "user_id": currentUser?.id.toString(),
        "criteria": [
          //   "position_id":""
        ]
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future getDriverDetails(driverId) async {
    try {
      var response = await client.get(Uri.parse(API_URL +
          "?method=get_driver_details&Userid=${currentUser!.id}&driver_id=$driverId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> driverReport(
      driverId, sdate, edate) async {
    try {
      var response = await client
          .post(Uri.parse(API_URL + "?method=driver_report"), body: {
        "driver_id": "$driverId",
        "start_date": sdate,
        "end_date": edate,
        "user_id": currentUser?.id.toString(),
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> driverPerformance() async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/vehicle_assignedto_drivers.php?user_id=${currentUser?.id.toString()}"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return List<Map<String, dynamic>>.from(data);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future saveFenceAlert() async {
    try {
      var response =
          await client.get(Uri.parse(API_URL + "?method=save_fence_alert"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future getAddress(lat, lng) async {
    try {
      var response = await client
          .get(Uri.parse(API_URL + "?method=get_address&lat=$lat&lng=$lng"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["result"];
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
    }
  }

  static Future<List<Map<String, dynamic>>> idleSummaryReport(
      sids, sdate, edate) async {
    try {
      var response =
          await client.post(Uri.parse(API_URL + "?method=idle_summary"), body: {
        "user_id": currentUser?.id.toString(),
        "start_date": sdate,
        "end_date": edate,
        "service_id": sids,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data["result"]);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getGeofences() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=get_geofences"),
          body: {"user_id": currentUser!.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future<List<NotificationMessage>> getNotifications() async {
    try {
      var response = await client.post(Uri.parse(USER_API_URL), body: {
        "method": "get_notification",
        "all": "true",
        "user_id": currentUser!.id.toString(),
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final notifications = data.map((e) => NotificationMessage(
              id: e['id'],
              msgStatus: e['msg_status'],
              message: e['message'],
              sentOn: e['sent_on'],
            ));
        return notifications;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future<List<Map<String, dynamic>>> getVehicleParkingMode() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=get_vehicle_parking_mode"),
          body: {"user_id": currentUser!.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          return List<Map<String, dynamic>>.from(data['result']);
        } else {
          print("NOT Connected");
          return List.empty();
        }
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return List.empty();
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return List.empty();
    }
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      var response = await client.post(
          Uri.parse(API_URL + "?method=user_profile"),
          body: {"user_id": currentUser!.id.toString()});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          return List<Map<String, dynamic>>.from(data['user_detail']).first;
        } else {
          print("NOT Connected");
          return {};
        }
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return {};
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return {};
    }
  }

  static changePassword(curPwd, newPwd) async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/trackofy_app.php?method=change_password"),
          body: {
            "user_id": currentUser!.id.toString(),
            "current_Password": curPwd,
            "newPass": newPwd
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static changeDateFormat(newFormat) async {
    try {
      var response = await client.get(Uri.parse(BASE_URL +
          "/API/trackofy_app.php?method=dateFormat&user_id=${currentUser?.id.toString()}&input_date=${newFormat}"));

      if (response.statusCode == 200) {
        return true;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getScheduleReportType() async {
    try {
      var response = await client
          .post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "get_scheduled_report"
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static saveScheduleReport(vehicleIds, frequency, reportId, scheduleTill,
      scheduleTime, emailString) async {
    print("==========");
    print(vehicleIds);
    print(frequency);
    print(reportId);
    print(scheduleTill);
    print(scheduleTime);
    print(emailString);
    print("==========");
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "email_string": emailString,
        "schedule_time": scheduleTime,
        "scheduleTill": scheduleTill,
        "report_id": reportId,
        "frequency": frequency,
        "vehicle_ids": vehicleIds,
        "method": "schedule_report",
        "user_id": currentUser?.id.toString(),
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        showMessage('Network Error',
            'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getPoiLocation() async {
    try {
      var response = await client.post(
          Uri.parse(BASE_URL + "/API/user_api.php"),
          body: {"user_id": currentUser?.id.toString(), "method": "get_poi"});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static savePoiAlert(
      vehIds, pois, notify, mob1, mob2, mob3, email1, email2, email3) async {
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "save_poi_alert",
        "veh_ids": vehIds,
        "pois": pois,
        "notification_on": notify,
        "mobile_1": mob1,
        "mobile_2": mob2,
        "mobile_3": mob3,
        "email_1": email1,
        "email_2": email2,
        "email_3": email3,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getPerformanceCategory() async {
    try {
      var response = await client
          .post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "get_performance_category"
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static Future<bool> saveVehiclePerformanceSetting(
      distanceRange, haltRange, runningRange, idleRange, category) async {
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "save_performance",
        "distance_range": distanceRange,
        "halt_range": haltRange,
        "running_range": runningRange,
        "idle_range": idleRange,
        "isEdit": "false",
        "Category": category,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<bool> saveControlLocation(locationName) async {
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "save_control_location",
        "location_name": locationName,
        "isEdit": "false",
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<bool> assignLocationToVehicle(locationId, vehicleIds) async {
    try {
      var response =
          await client.post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "assign_location",
        "location_id": locationId,
        "service_id": vehicleIds,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return false;
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getControlLocations() async {
    try {
      var response = await client
          .post(Uri.parse(BASE_URL + "/API/user_api.php"), body: {
        "user_id": currentUser?.id.toString(),
        "method": "get_controllocation"
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        // showMessage('Network Error',
        //     'An error occurred while communicating with the server.');
        return [];
      }
    } catch (e) {
      print(e);
      // showMessage('Network Error', 'Something went wrong.');
      return [];
    }
  }

  static addDriver(driverName, dob, contact, email, dlNo, dlIssuedDate,
      dlExpiryDate, address, emergencyContact, file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("<url>"));
      //add text fields
      request.fields["user_id"] = currentUser!.id.toString();
      request.fields["driver_name"] = driverName;
      request.fields["dob"] = dob;
      request.fields["contact"] = contact;
      request.fields["email"] = email;
      request.fields["dl_no"] = dlNo;
      request.fields["dl_issued_date"] = dlIssuedDate;
      request.fields["dl_expiry_date"] = dlExpiryDate;
      request.fields["address"] = address;
      request.fields["emergency_contact"] = emergencyContact;
      request.fields["is_edit"] = "false";
      var pic = await http.MultipartFile.fromPath("dl_copy", file.path);
      request.files.add(pic);
      var response = await request.send();

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print(responseString);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
