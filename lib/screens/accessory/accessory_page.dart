import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hd/blocs/accessory_bloc.dart';
import 'package:hd/components/skeleton.dart';
import 'package:hd/models/accessory/accessory_model.dart';
import 'package:hd/models/accessory_image/accessory_image_model.dart';
import 'package:hd/models/accessory_image/accessory_image_response_model.dart';
import 'package:hd/models/category/category_model.dart';
import 'package:hd/screens/accessory/accessories_page.dart';

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
  bool isCaptured;
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
    this.isCaptured = false;
    accessory = widget.accessory;
    bloc.findAccessoryImage(accessory);
  }

  void _toggleCapture() {
    setState(() {
      this.isCaptured = !this.isCaptured;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _accessoryImage(AccessoryImageModel accessoryImage) => Expanded(
          child: Container(
            constraints: new BoxConstraints.expand(
              height: 200.0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(accessoryImage.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );

    final Widget _cameraPlaceHolder = GestureDetector(
      child: Container(
        constraints: new BoxConstraints.expand(
          height: 200.0,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.keh.com/skin/frontend/keh/default/images/placeholder-min.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () => _toggleCapture(),
    );

    final Widget _capturedImage = Container(
      constraints: new BoxConstraints.expand(
        height: 200.0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://kuongngan.com/wp-content/uploads/2017/01/bugi-xe-m%C3%A1y-6.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () => _toggleCapture(),
              child: Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final Widget _saveCapturedImageButton = RaisedButton(
      onPressed: () => _toggleCapture(),
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
    );

    Widget _setCaptureImageWidget() {
      return this.isCaptured ? _capturedImage : _cameraPlaceHolder;
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
                          _accessoryImage(snapshot.data.result),
                          Expanded(
                            child: _setCaptureImageWidget(),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      this.isCaptured ? _saveCapturedImageButton : Container(),
                    ],
                  );
                } else {
                  return Skeleton();
                }
              }),
        ),
      ),
    );
  }
}
