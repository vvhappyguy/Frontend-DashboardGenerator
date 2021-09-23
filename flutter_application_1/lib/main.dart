/// Flutter code sample for GestureDetector

// This example contains a black light bulb wrapped in a [GestureDetector]. It
// turns the light bulb yellow when the "TURN LIGHT ON" button is tapped by
// setting the `_lights` field, and off again when "TURN LIGHT OFF" is tapped.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _lightIsOn = false;
  // String _imagePath =
  //     'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg';
  String _imagePath =
      'https://studfile.net/html/26305/112/html_uKxp4MGMu5.4RBD/img-yRhNQd.png';
  final myController = TextEditingController();
  double x = 0.0;
  double y = 0.0;

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter ' + _lightIsOn.toString()),
        ),
        body: Center(
            child: MouseRegion(
          onHover: _updateLocation,
          child: GestureDetector(
            onTap: () {
              print('x:' + x.toString() + ' y:' + y.toString());
            },
            child: Container(
              child: Image(
                width: _lightIsOn ? 100 : 700,
                image: NetworkImage(_imagePath),
              ),
            ),
          ),
        )),
        bottomSheet: TextField(
          controller: myController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Enter image URL'),
        ),
        persistentFooterButtons: [
          Text('x:' + x.toString() + ' y:' + y.toString()),
          TextButton.icon(
              icon: Icon(Icons.add),
              label: Text("1"),
              onPressed: () {
                setState(() {
                  _imagePath = myController.text;
                  _lightIsOn = !_lightIsOn;
                });
              }),
          TextButton.icon(
              icon: Icon(Icons.remove),
              label: Text("2"),
              onPressed: () {
                setState(() {
                  _imagePath = '';
                  _lightIsOn = !_lightIsOn;
                });
              }),
        ]);
  }
}
