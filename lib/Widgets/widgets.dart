import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackofyapp/constants.dart';

customtextField(context, txt, img, ic) {
  return Container(
    color: ThemeColor.primarycolor,
    height: MediaQuery.of(context).size.height * 0.07,
    width: MediaQuery.of(context).size.width * 0.85,
    child: Row(
      children: [
        Image.asset(
          img,
          height: 40,
          width: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 04),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.60,
            child: TextFormField(
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                label: Text("Username*"),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

materialButton(context, onpressed, txt, c) {
  return MaterialButton(
    onPressed: onpressed,
    enableFeedback: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    height: 45.0,
    minWidth: MediaQuery.of(context).size.width * 0.95,
    elevation: 0.3,
    color: c,
    child: Text(
      txt,
      style: TextStyle(
          color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
  );
}

materialButton2(context, onpressed, txt, c, w, h) {
  return MaterialButton(
    onPressed: onpressed,
    enableFeedback: true,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
    height: h,
    minWidth: w,
    elevation: 0.3,
    color: c,
    child: Text(
      txt,
      style: TextStyle(
          color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
  );
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.scale(
          scale: 1,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Color(0xff524f54),
            activeTrackColor: Color(0xffa8b8c7),
            inactiveThumbColor: Color(0xffececec),
            inactiveTrackColor: Color(0xff8ea0ad),
          )),
    ]);
  }
}

searchbox(context, onchanged, txt, h, w, c) {
  return Container(
    height: h,
    width: w,
    color: c,
    alignment: Alignment.center,
    child: new Stack(alignment: Alignment.center, children: <Widget>[
      Image(
        image: AssetImage('assets/images/search.png'),
        width: 300,
      ),
      TextField(
          textAlign: TextAlign.center,
          autocorrect: false,
          decoration:
              //disable single line border below the text field
              new InputDecoration.collapsed(
                  hintText: 'Search Vehicle',
                  hintStyle: TextStyle(color: Colors.grey))),
    ]),
  );
}

searchbox2(context, onpressed, txt, c) {
  return Container(
    // height: h,
    width: Get.size.width * 0.9,
    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.only(left: 15),
      child: TextFormField(
        decoration: InputDecoration(
          isDense: true,
          hintText: "Search Vehicle",
          hintStyle: TextStyle(color: Color(0xffadadad)),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    ),
  );
}
