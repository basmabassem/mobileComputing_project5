import 'package:flutter/material.dart';
import 'package:motion_sensors/motion_sensors.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: appPage(),
    );
  }
}

class appPage extends StatefulWidget {
  const appPage({Key? key}) : super(key: key);

  @override
  State<appPage> createState() => _appPageState();
}

class _appPageState extends State<appPage> {
  double _force = 0.0;
  bool _isSwinging = false;
  static const double PHONE_MASS = 0.192; //mass of phone in kg
  double angle_x = 0.0;
  double angle_y = 0.0;
  double angle_z = 0.0;
  void initState() {
    super.initState();
    motionSensors.gyroscope.listen((GyroscopeEvent event) {
      if (_isSwinging) {
        setState(() {
          //update rotation values and convert the rotation angle from radian to degree
          angle_x = (event.x) * (180 / pi);
          angle_y = (event.y) * (180 / pi);
          angle_z = (event.z) * (180 / pi);
        });
      }
    });
    motionSensors.accelerometer.listen((AccelerometerEvent event) {
      if (_isSwinging) {
        setState(() {
          //update the acceleration values
          double ax = event.x;
          double ay = event.y;
          double az = event.z;

          //calculate force (in Newtons) based on acceleration values ---- > f = m * sqrt(ax^2 + ay^2 + ax^2)
          _force = PHONE_MASS * sqrt(pow(ax, 2) + pow(ay, 2) + pow(az, 2));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 98, 1, 72),
            title: Text('Tennis Racket App',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ))),
        body: _isSwinging
            ? Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                    ),
                    Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            ),
                            BoxShadow(
                              color: Color.fromARGB(255, 98, 1, 72),
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0,
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            showResults(
                              result: "Force: ${_force.toStringAsFixed(3)} N",
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            showResults(
                              result:
                                  "AngleX: ${angle_x.toStringAsFixed(3)} degree",
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            showResults(
                              result:
                                  "AngleY: ${angle_y.toStringAsFixed(3)} degree",
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            showResults(
                              result:
                                  "AngleZ: ${angle_z.toStringAsFixed(3)} degree",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 135,
                    ),
                    swinging(
                        onPressed: () {
                          setState(() {
                            _isSwinging = false;
                          });
                        },
                        button: "Stop")
                  ],
                ),
              )
            : Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tennis1.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: swinging(
                    onPressed: () {
                      setState(() {
                        _isSwinging = true;
                      });
                    },
                    button: "start")));
  }
}

class showResults extends StatelessWidget {
  final String result;

  showResults({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyanAccent.shade700,
      width: 300,
      height: 35,
      child: Center(
        child: Text(
          result,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class swinging extends StatelessWidget {
  final String button;
  Function()? onPressed;
  swinging({
    required this.onPressed,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 98, 1, 72),
            onPrimary: Colors.white,
          ),
          child: Text("$button"),
          onPressed: onPressed,
        )
      ],
    );
  }
}
