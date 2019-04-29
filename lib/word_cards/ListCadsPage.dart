import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/util/EmptyAppBar.dart';
import 'package:hush_talk/word_cards/ListWords.dart';
import 'package:hush_talk/word_cards/ScrollBackMenuListView.dart';
import 'package:screen/screen.dart';

import '../main.dart';

class ListCardsPage extends StatefulWidget {
  ListCardsPage();

  @override
  _ListCardsPageState createState() => _ListCardsPageState();
}

class _ListCardsPageState extends State<ListCardsPage> {
  dynamic _scanResults;
  CameraController _camera;
  ScrollBackMenuListView _controller;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    _controller = ScrollBackMenuListView(_backMenu);
    _initializeCamera();
  }

  void _initializeCamera() async {
    CameraDescription description = await getCamera(_direction);
    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );

    _camera = CameraController(
      description,
      defaultTargetPlatform == TargetPlatform.iOS
          ? ResolutionPreset.low
          : ResolutionPreset.medium,
    );
    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      _isDetecting = true;

      detect(image, _getDetectionMethod(), rotation).then(
            (dynamic result) {
          setState(() {
            _scanResults = result;
          });
          _isDetecting = false;
        },
      ).catchError(
            (_) {
          _isDetecting = false;
        },
      );
    });
  }

  HandleDetection _getDetectionMethod() {
    final FirebaseVision mlVision = FirebaseVision.instance;
    return mlVision
        .faceDetector(FaceDetectorOptions(enableClassification: true))
        .processImage;
  }

  Face getFaceDetected() {
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return null;
    }

    if (_scanResults is! List<Face>) {
      return null;
    }
    List<Face> faces = _scanResults;
    if (faces.length > 0) {
      return faces[0];
    }
    return null;
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(
        child: Text(
          'Initializing Camera...',
          style: TextStyle(
            color: Colors.green,
            fontSize: 30.0,
          ),
        ),
      )
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ListWords(_scanResults, _camera, _controller),
//                _buildResults(),
        ],
      ),
    );
  }

  _backMenu(){
    var route = ModalRoute.of(context);
    if (route != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage()));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: EmptyAppBar(),
      body: _buildImage(),
    );
  }
}

