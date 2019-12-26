import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';
import 'package:hd/screens/accessory/components/accessory_image.dart';
import 'package:hd/screens/accessory/components/camera_placeholder_image.dart';
import 'package:hd/screens/accessory/components/captured_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class AccessoryPage extends StatefulWidget {
  static const String name = '/accessory';

  final CategoryModel category;
  final SubCategoryModel subCategory;
  final AccessoryModel accessory;

  AccessoryPage(
      {@required this.category,
      @required this.subCategory,
      @required this.accessory})
      : assert(category is CategoryModel),
        assert(subCategory is SubCategoryModel),
        assert(accessory is AccessoryModel);

  @override
  _AccessoryPageState createState() => _AccessoryPageState();
}

class _AccessoryPageState extends State<AccessoryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _widgetKey = new GlobalKey<ScaffoldState>();

  bool _isCaptured;
  File _capturedImage;
  bool _isSaved;
  AccessoryModel accessory;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _isCaptured = false;
    accessory = widget.accessory;
    _isSaved = false;
  }

  Future _capture() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _capturedImage = image;
      _isCaptured = true;
    });
  }

  Future _reCaptureImage() async {
    setState(() {
      _capturedImage = null;
      _isCaptured = false;
    });
    await _capture();
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      setState(() {
        _capturedImage = response.file;
      });
    }
  }

  void _showToast(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _saveCapturedImage() async {
    if (_capturedImage == null) {
      return;
    }

    try {
      await ImageGallerySaver.saveImage(await _capturedImage.readAsBytes());

      _showToast('Success to save image');
      setState(() {
        _isSaved = true;
      });
    } catch (error) {
      _showToast('Failed to save image');
    }
  }

  void captureWidget() async {
    RenderRepaintBoundary boundary =
        _widgetKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
  }

  @override
  Widget build(BuildContext context) {
    Widget _setCaptureImageWidget() {
      return _isCaptured && _capturedImage != null
          ? CapturedImage(
              capturedImage: _capturedImage,
            )
          : CameraPlaceHolderImage(
              onCapture: _capture,
            );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          accessory.name,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccessoriesPage(
                category: widget.category,
                subCategory: widget.subCategory,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 5.0,
          ),
          child: SingleChildScrollView(
            child: widget.subCategory.type == 1
                ? Row(
                    children: <Widget>[
                      AccessoryImage(
                        accessory: accessory,
                      ),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      RepaintBoundary(
                        key: _widgetKey,
                        child: Row(
                          children: <Widget>[
                            AccessoryImage(
                              accessory: accessory,
                            ),
                            Expanded(
                              child: _setCaptureImageWidget(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Visibility(
                        visible: !_isSaved,
                        child: RaisedButton(
                          onPressed: () => captureWidget(),
                          color: Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'save image'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _capturedImage != null,
                        child: RaisedButton(
                          onPressed: () => _reCaptureImage(),
                          color: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'recapture'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
