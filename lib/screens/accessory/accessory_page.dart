import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:hd/components/loading.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/models/sub_category/sub_category_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';
import 'package:hd/screens/accessory/components/accessory_description_image.dart';
import 'package:hd/screens/accessory/components/accessory_image.dart';
import 'package:hd/screens/accessory/components/camera_placeholder_image.dart';
import 'package:hd/screens/accessory/components/captured_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  static const DEFAULT_PIXEL_RATIO = 5.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey _widgetKey = new GlobalKey();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

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

  _checkPermission(PermissionGroup permissionGroup) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var _permissionCameraStatus = await _permissionHandler.checkPermissionStatus(permissionGroup);
    switch (_permissionCameraStatus) {
      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  _requestPermission(PermissionGroup permissionGroup) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    _permissionHandler.requestPermissions([permissionGroup]);
  }

  Future _capture() async {
    var _optionalPermission = Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos;
    if (await _checkPermission(_optionalPermission) == false) {
      await _requestPermission(_optionalPermission);
      return;
    }

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
      _isSaved = false;
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

  void _captureWidget() async {
    if (_capturedImage == null) {
      return;
    }

    try {
      Loading.showLoadingDialog(context, _keyLoader);
      RenderRepaintBoundary boundary =
          _widgetKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: DEFAULT_PIXEL_RATIO);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes));
      _showToast(FlutterI18n.translate(context, 'toast.success-save-image'));
      setState(() {
        _isSaved = true;
      });
      Navigator.of(
        _keyLoader.currentContext,
        rootNavigator: true,
      ).pop();
    } catch (error) {
      print(error);
      _showToast(FlutterI18n.translate(context, 'toast.failed-save-image'));
      Navigator.of(
        _keyLoader.currentContext,
        rootNavigator: true,
      ).pop();
    }
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Row(
                                children: <Widget>[
                                  AccessoryImage(
                                    accessory: accessory,
                                  ),
                                  Expanded(
                                    child: _setCaptureImageWidget(),
                                  ),
                                ],
                              ),
                            ),
                            AccessoryDescriptionImage(
                              accessory: accessory,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Visibility(
                        visible: !_isSaved,
                        child: RaisedButton(
                          onPressed: () => _captureWidget(),
                          color: Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              FlutterI18n.translate(context, 'btn.save-image')
                                  .toUpperCase(),
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
                              FlutterI18n.translate(context, 'btn.recapture')
                                  .toUpperCase(),
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
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
