import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
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
  Offset tmpPoint = Offset(0, 0);
  OpenPainter(List<Offset> _list, Offset _tmpPoint) {
    this.list = _list;
    this.tmpPoint = _tmpPoint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paintO = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Color.fromRGBO(255, 0, 0, 0.75)
      ..isAntiAlias = true;
    if (tmpPoint != Offset(0, 0)) {
      canvas.drawRect(
          Rect.fromPoints(tmpPoint, Offset(tmpPoint.dx + 2, tmpPoint.dy + 2)),
          paintO);
    }
    for (var i = 0; i < list.length; i += 2) {
      var point1 = list[i];
      if (list.length != i + 1) {
        var point2 = list[i + 1];
        //canvas.drawLine(point1, point2, paintO);
        canvas.drawRect(Rect.fromPoints(point1, point2), paintO);
      } else {}
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
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

// {
//   path: "imagePath",
//   width: 100,
//   height: 100,
//   elements:[
//     {
//       label : "switcher",
//       x: 10,
//       y: 10,
//       height: 10,
//       width: 10
//     },
//     ...
//   ]
// }

class Element {
  final String name;
  final double x0;
  final double y0;
  final double x1;
  final double y1;

  Element(this.name, this.x0, this.y0, this.x1, this.y1);

  Element.fromJson(Map<String, dynamic> json)
      : name = json['label'],
        x0 = json['x0'],
        y0 = json['y0'],
        x1 = json['x1'],
        y1 = json['y1'];

  Map<String, dynamic> toJson() => {
        'label': name,
        'x0': x0,
        'y0': y0,
        'x1': x1,
        'y1': y1,
      };

  Map<Offset, Offset> toOffset() {
    Map<Offset, Offset> ret = {};
    ret.addAll({Offset(x0, y0): Offset(x1, y1)});
    return ret;
  }
}

class Information {
  String path;
  double width;
  double height;
  List<Element> elements;

  Information(this.path, this.width, this.height, this.elements);

  Information.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        width = json['width'],
        height = json['height'],
        elements = json['elements'];

  Map<String, dynamic> toJson() => {
        'path': path,
        'width': width,
        'height': height,
        'elements': json.encode(elements)
      };

  List<Offset> toListOffset() {
    List<Offset> ret = [];
    elements.forEach((element) => {
          ret.addAll(
              [Offset(element.x0, element.y0), Offset(element.x1, element.y1)])
        });
    return ret;
  }
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ImagePicker _picker = ImagePicker();
  final myController = TextEditingController();
  double x = 0.0;
  double y = 0.0;

  XFile? imageXF = XFile("");
  bool isPicked = false;

  Image? imageI;
  int? imageHeight = 0;
  int? imageWidth = 0;
  int counter = 0;

  double kToolbarHeight = 100;

  bool getJSONst = false;
  Information info = Information("path", 0, 0, []);
  Offset tmpPoint = Offset(0, 0);

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
          title: Text('Dashboard Generator'),
          toolbarHeight: kToolbarHeight,
        ),
        body: Center(
          child: Stack(children: [
            Container(
              child: imageI,
              key: key1,
            ),
            Container(
                height: isPicked ? imageI?.height?.toDouble() : 0,
                width: isPicked ? imageI?.width?.toDouble() : 0,
                child: CustomPaint(
                  painter: OpenPainter(info.toListOffset(), tmpPoint),
                  willChange: true,
                )),
            Container(
                child: MouseRegion(
                    onHover: _updateLocation,
                    child: GestureDetector(
                      onTap: () {
                        print('x:' + x.toString() + ' y:' + y.toString());
                        print(key1.currentContext!.size);
                        if (tmpPoint != Offset(0, 0)) {
                          info.elements.add(Element((counter++).toString(), x,
                              y - kToolbarHeight, tmpPoint.dx, tmpPoint.dy));
                          tmpPoint = Offset(0, 0);
                        } else {
                          tmpPoint = Offset(x, y - kToolbarHeight);
                        }
                        print("tmp" + tmpPoint.toString());
                      },
                    ))),
            Container(
                child: getJSONst
                    ? Container(
                        color: Colors.green,
                        width: 500,
                        height: 500,
                        child: Text(info.toJson().toString()))
                    : null)
          ]),
        ),
        persistentFooterButtons: [
          Text('x:' + x.toString() + ' y:' + y.toString()),
          Text('width:' +
              (imageI == null ? "0" : (imageWidth.toString())) +
              ' height:' +
              (imageI == null ? "0" : (imageHeight.toString()))),
          TextButton.icon(
            icon: Icon(Icons.texture),
            label: Text("Get JSON"),
            onPressed: () async {
              getJSONst = !getJSONst;
            },
          ),
          TextButton.icon(
              icon: Icon(Icons.image),
              label: Text("Pick Image"),
              onPressed: () async {
                imageXF = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imageI = Image.network(imageXF!.path);
                  info.path = imageXF!.path;
                  info.elements = [];
                  isPicked = true;
                });
              }),
          TextButton.icon(
              icon: Icon(Icons.update), label: Text("0"), onPressed: () {}),
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
                          info.width = image!.width.toDouble();
                          info.height = image.height.toDouble();
                          return new Text('${image.width}x${image.height}');
                        } else {
                          return new Text('Loading...');
                        }
                      })
                  : Text('No image'))
        ]);
  }
}
