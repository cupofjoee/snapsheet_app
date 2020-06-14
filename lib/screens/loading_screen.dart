import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/models/user_data.dart';
import 'package:snapsheetapp/services/scanner.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = 'loading_screen';

  List<Asset> images;
  int index;

  LoadingScreen(this.images, this.index);

  @override
  State<StatefulWidget> createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  void getLocationData() async {
    UserData userData = Provider.of<UserData>(context);
    Scanner scanner = Scanner(userData);
    await scanner.bulkProcess(widget.images, widget.index);
    scanner.clearResource();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}