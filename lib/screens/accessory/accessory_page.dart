import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hd/blocs/accessory_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory_image/accessory_image_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';
import 'package:hd/screens/accessory/components/accessory_image.dart';
import 'package:hd/screens/accessory/components/camera_placeholder_image.dart';
import 'package:hd/screens/accessory/components/captured_image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class AccessoryPage extends StatefulWidget {
  static const String name = '/accessory';

  final CategoryModel category;
  final AccessoryModel accessory;

  AccessoryPage({@required this.category, @required this.accessory})
      : assert(category is CategoryModel),
        assert(accessory is AccessoryModel);

  @override
  _AccessoryPageState createState() => _AccessoryPageState();
}

class _AccessoryPageState extends State<AccessoryPage> {
  bool _isCaptured;
  File _capturedImage;
  bool _isSaved;
  AccessoryModel accessory;
  final AccessoryBloc bloc = AccessoryBloc();

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
    bloc.findAccessoryImage(accessory);
  }

  Future _capture() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _capturedImage = image;
      _isCaptured = true;
    });
  }

  void _deleteCapturedImage() {
    setState(() {
      _capturedImage = null;
      _isCaptured = false;
      _isSaved = false;
    });
  }

  void _showToast(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    void _saveCapturedImage(BuildContext context) async {
      if (_capturedImage == null) {
        return;
      }

      try {
        await ImageGallerySaver.saveImage(await _capturedImage.readAsBytes());

        _showToast(context, 'Success to save image');
        setState(() {
          _isSaved = true;
        });
      } catch (error) {
        _showToast(context, 'Failed to save image');
      }
    }

    Widget _setCaptureImageWidget() {
      return _isCaptured && _capturedImage != null
          ? CapturedImage(
              capturedImage: _capturedImage,
              onDeleteCapturedImage: _deleteCapturedImage,
            )
          : CameraPlaceHolderImage(
              onCapture: _capture,
            );
    }

    return Scaffold(
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
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 5.0,
          ),
          child: StreamBuilder<AccessoryImageResponse>(
            stream: bloc.subject.stream,
            builder: (BuildContext context,
                AsyncSnapshot<AccessoryImageResponse> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        AccessoryImage(
                          accessoryImage: snapshot.data.result,
                        ),
                        Expanded(
                          child: _setCaptureImageWidget(),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Visibility(
                      visible: !_isSaved,
                      child: RaisedButton(
                        onPressed: () => _saveCapturedImage(context),
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
                    )
                  ],
                );
              } else {
                return Skeleton();
              }
            },
          ),
        ),
      ),
    );
  }
}
