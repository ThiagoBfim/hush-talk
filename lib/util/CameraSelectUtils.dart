import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';

Future<CameraMLController> onNewCameraSelected(CameraMLController camera,
    GlobalKey<ScaffoldState> scaffoldKey, Function updateStateCamera) async {
  if (camera != null) {
    await camera.dispose();
  }
  return _initializeCamera(camera, scaffoldKey, updateStateCamera);
}

CameraLensDirection _direction = CameraLensDirection.front;

Future<CameraMLController> _initializeCamera(CameraMLController camera,
    GlobalKey<ScaffoldState> scaffoldKey, Function updateStateCamera) async {
  CameraDescription description = await getCamera(_direction);
  camera = CameraMLController(description, updateStateCamera);
  return camera;
}

void showInSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
