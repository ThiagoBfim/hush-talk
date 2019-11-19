import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraSelectUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';
import 'package:hush_talk/word_cards/card_page/ScrollBackMenuListView.dart';
import 'package:screen/screen.dart';

abstract class ListAbsctractPage extends StatefulWidget {
  ListAbsctractPage();

  @override
  ListAbsctractPageState createState();
}

abstract class ListAbsctractPageState extends State<ListAbsctractPage>  with WidgetsBindingObserver {
  dynamic scanResults;
  CameraMLController camera;
  ScrollBackMenuListView controller;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = initScrollController();
    Screen.keepOn(true);
    _initCamera();
    WidgetsBinding.instance.addObserver(this);
  }

  Future _initCamera() async {
    camera = await onNewCameraSelected(camera, scaffoldKey, updateStateCamera);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (camera == null || !camera.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      camera?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (camera != null) {
        _initCamera();
      }
    }
  }


  @protected
  ScrollBackMenuListView initScrollController();

  updateStateCamera(result) {
    setState(() {
      scanResults = result;
    });
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: camera == null
          ? const Center(
              child: Text(
                'Inicializando a camera...',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                ),
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                createList(),
              ],
            ),
    );
  }

  @protected
  Widget createList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      primary: false,
      appBar: EmptyAppBar(),
      body: _buildImage(),
    );
  }
}
