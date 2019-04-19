// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hush_talk/ml_widget/detector_face.dart';
import 'package:hush_talk/word_cards/ListItem.dart';
import 'package:hush_talk/word_cards/WordCard.dart';
import 'utils.dart';

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _scanResults;
  CameraController _camera;

  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
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

  void getFaceDetected(){
    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return null;
    }

    if (_scanResults is! List<Face>) {
      return null;
    }
    List<Face> faces = _scanResults;
    if(faces.length > 0) {
      Face face = faces[0];
      if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability <= 0.5) {
        _moveUp();
      }
      if (face.rightEyeOpenProbability != null && face.rightEyeOpenProbability <= 0.5) {
        _moveDown();
      }
    }
  }
  Widget _buildResults() {
    const Text noResultsText = const Text('No results!');

    if (_scanResults == null ||
        _camera == null ||
        !_camera.value.isInitialized) {
      return noResultsText;
    }

    CustomPainter painter;

    final Size imageSize = Size(
      _camera.value.previewSize.height,
      _camera.value.previewSize.width,
    );

    if (_scanResults is! List<Face>) return noResultsText;
    painter = FaceDetectorPainter(imageSize, _scanResults, context);
    return CustomPaint(
      painter: painter,
    );
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
//          ListCardsBuilder(),
          buildListWords(context),
//          transformListWords(), //IMAGE CAMERA VIEW.
          _buildResults(),
        ],
      ),
    );

  }

  Transform transformCameraPreview() {
    final size = MediaQuery
        .of(context)
        .size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: _camera.value.aspectRatio / deviceRatio / 2,
      child: Center(
        child: AspectRatio(
          aspectRatio: _camera.value.aspectRatio,
          child: CameraPreview(_camera),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hush Talk'),
        actions: <Widget>[
        ],
      ),
      body: _buildImage(),
    );
  }

  ScrollController _controller  = ScrollController();
  double itemSize = 100.0;

  _moveUp() {
    //_controller.jumpTo(_controller.offset - itemSize);
    print('up');
    _controller.animateTo(_controller.offset - itemSize,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  _moveDown() {
    print('down');
    //_controller.jumpTo(_controller.offset + itemSize);
    _controller.animateTo(_controller.offset + itemSize,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  Widget buildListWords(BuildContext context) {
    getFaceDetected();
    double height = MediaQuery.of(context).size.height;
    return Column(children: <Widget>[
      Container(
        height: height/4,
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                child: Text("up"),
                onPressed: _moveUp,
              ),
              RaisedButton(
                child: Text("down"),
                onPressed: _moveDown,
              )
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          controller: _controller,
          itemCount: wordCards.length,
          scrollDirection: Axis.vertical,
          itemExtent: itemSize,
          itemBuilder: (context, index) {
            final wordCard = wordCards[index];
//            return ListTile(title: Text(wordCard.title));
            return ListItem(
              wordCard: wordCard,
              height: height - height/4,
            );
          },
        ),
      )
    ]);
  }
}
