/// Flutter code sample for GestureDetector

// This example contains a black light bulb wrapped in a [GestureDetector]. It
// turns the light bulb yellow when the "TURN LIGHT ON" button is tapped by
// setting the `_lights` field, and off again when "TURN LIGHT OFF" is tapped.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'dart:async';

void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Dashboard Generator';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

GlobalKey key1 = GlobalKey();

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class OpenPainter extends CustomPainter {
  List<Offset> list = [];
  OpenPainter(List<Offset> _list) {
    this.list = _list;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paintO = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Color.fromRGBO(0, 1, 0, 1)
      ..isAntiAlias = true;
    for (var i = 0; i < list.length; i += 2) {
      var point1 = list[i];
      if (list.length == i + 1) break;
      var point2 = list[i + 1];
      //canvas.drawLine(point1, point2, paintO);
      canvas.drawRect(Rect.fromPoints(point1, point2), paintO);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _lightIsOn = false;
  final ImagePicker _picker = ImagePicker();
  final myController = TextEditingController();
  double x = 0.0;
  double y = 0.0;

  XFile? imageXF = XFile("");
  bool isPicked = false;

  Image? imageI;
  int? imageHeight = 0;
  int? imageWidth = 0;

  List<Offset> points = [];

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  Future<ui.Image> getImageInfo() async {
    Completer<ui.Image> completer = new Completer<ui.Image>();
    new NetworkImage(imageXF!.path)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
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
                    print(key1.currentContext!.size);
                    points.add(Offset(x, y));
                  },
                  child: Stack(
                    children: [
                      Container(
                        child: imageI,
                        key: key1,
                      ),
                      Container(
                          height: imageHeight?.toDouble(),
                          width: imageWidth?.toDouble(),
                          child: CustomPaint(
                            painter: OpenPainter(points),
                          ))
                    ],
                  ))),
        ),
        persistentFooterButtons: [
          Text('x:' + x.toString() + ' y:' + y.toString()),
          Text('width:' +
              (imageI == null ? "0" : (imageWidth.toString())) +
              ' height:' +
              (imageI == null ? "0" : (imageHeight.toString()))),
          TextButton.icon(
              icon: Icon(Icons.image),
              label: Text("Pick Image"),
              onPressed: () async {
                imageXF = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imageI = Image.network(imageXF!.path);
                  isPicked = true;
                });
              }),
          TextButton.icon(
              icon: Icon(Icons.update),
              label: Text("0"),
              onPressed: () {
                points.forEach((element) {
                  print('Offset:' + element.toString());
                });
              }),
          Container(
              child: isPicked
                  ? new FutureBuilder<ui.Image>(
                      future: getImageInfo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<ui.Image> snapshot) {
                        if (snapshot.hasData) {
                          ui.Image? image = snapshot.data;
                          imageHeight = image?.height;
                          imageWidth = image?.width;

                          return new Text('${image?.width}x${image?.height}');
                        } else {
                          return new Text('Loading...');
                        }
                      })
                  : Text('No image'))
        ]);
  }
}
/*
Panels
id: int unique
path: string - локальный путь до картинки
width: int - ширина картинки
height: int - высота картинки

Elements
id: int unique
panel_id: int from Panels
width: int - ширина элемента
height:  int - высота элемента
x: int - отступ по Х относительно левого верхнего угла
y: int - отступ по Y относительно левого верхнего угла
label: string - название элемента
*/
