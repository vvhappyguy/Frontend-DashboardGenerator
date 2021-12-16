/// Flutter code sample for GestureDetector

// This example contains a black light bulb wrapped in a [GestureDetector]. It
// turns the light bulb yellow when the "TURN LIGHT ON" button is tapped by
// setting the `_lights` field, and off again when "TURN LIGHT OFF" is tapped.

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _lightIsOn = false;
  final ImagePicker _picker = ImagePicker();
  final myController = TextEditingController();
  double x = 0.0;
  double y = 0.0;

  XFile? image = XFile("");

  Image? imageI;
  double? imageHeight = 0;
  double? imageWidth = 0;

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  // Future<ImageInfo> getImageInfo(Image? img) async {
  //   final c = new Completer<ImageInfo>();
  //   img?.image
  //       .resolve(new ImageConfiguration())
  //       .addListener(new ImageStreamListener((ImageInfo i, bool _) {
  //     c.complete(i);
  //   }));
  //   return c.future;
  // }

  @override
  Widget build(BuildContext context) {
    // imageI = Image.network(image.path);
    // Completer<ui.Image> completer = new Completer<ui.Image>();
    // imageI?.image
    //     .resolve(new ImageConfiguration())
    //     .addListener(new ImageStreamListener((ImageInfo image, bool _) {
    //   completer.complete(image.image);
    // }));

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
                    child: imageI))),
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
                image = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imageI = Image.network(image!.path);
                });
              }),
          TextButton.icon(
              icon: Icon(Icons.update),
              label: Text("0"),
              onPressed: () {
                setState(() {
                  _lightIsOn = !_lightIsOn;
                });
              }),
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
