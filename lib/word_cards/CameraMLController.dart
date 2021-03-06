import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';

class CameraMLController extends CameraController {
  static final ResolutionPreset _resolutionPreset = _getResolution();
  final Function _updateStateCamera;
  bool _isDetecting = false;
  bool _notFoundFace = false;

  CameraMLController(_description, this._updateStateCamera)
      : super(_description, _resolutionPreset);

  init() {
    initializeImageStream();
  }

  void initializeImageStream() {
    ImageRotation rotation = rotationIntToImageRotation(
    description.sensorOrientation,
    );
    startImageStream((CameraImage image) {
      if (_isDetecting) return;
      _isDetecting = true;
      detect(image, _getDetectionMethod(), rotation).then(
        (dynamic result) {
          if (result.length > 0) {
            Function.apply(_updateStateCamera, result);
            _notFoundFace = false;
          } else {
            _notFoundFace = true;
          }
          _isDetecting = false;
        },
      ).catchError(
        (ex) {
          _isDetecting = false;
          print(ex);
        },
      );
    });
  }

  Face getFaceDetected(_scanResults) {
    if (_scanResults == null || !value.isInitialized) {
      return null;
    }
    if (_scanResults is! List<Face>) {
      if (_scanResults is Face) {
        return _scanResults;
      }
      return null;
    }
    List<Face> faces = _scanResults;
    if (faces.length > 0) {
      return faces[0];
    }
    return null;
  }

  HandleDetection _getDetectionMethod() {
    final FirebaseVision mlVision = FirebaseVision.instance;
    return mlVision
        .faceDetector(
            FaceDetectorOptions(enableClassification: true))
        .processImage;
  }

  static _getResolution() {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? ResolutionPreset.low
        : ResolutionPreset.medium;
  }

  void stop() {
    print('stopping');
    try {
      if (value.isStreamingImages) {
        stopImageStream();
      }
      if (value.isRecordingVideo) {
        stopVideoRecording();
      }
    } catch (e) {
      print('Ocorreceu um erro ao tentar parar o a camera.');
    }
  }

  bool get notFoundFace => _notFoundFace;


}
