import 'package:camera_fix_exception/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/util/CameraUtils.dart';
import 'package:hush_talk/word_cards/CameraMLController.dart';

Future<CameraMLController> onNewCameraSelected(CameraMLController camera,
    GlobalKey<ScaffoldState> scaffoldKey, Function updateStateCamera) async {
  if (camera != null) {
    await camera.dispose();
  }
  return initializeCamera(camera, scaffoldKey, updateStateCamera);
}

CameraLensDirection _direction = CameraLensDirection.front;

Future<CameraMLController> initializeCamera(CameraMLController camera,
    GlobalKey<ScaffoldState> scaffoldKey, Function updateStateCamera) async {
  CameraDescription description = await getCamera(_direction);
  camera = CameraMLController(description, updateStateCamera);
  camera.addListener(() {
    if (camera.value.hasError) {
      showInSnackBar(
          scaffoldKey, 'Ocorreu um erro ao inicializar a camera.');
      if(camera.notFoundFace){
        print('tentando recuperar');
        initializeCamera(camera, scaffoldKey, updateStateCamera);
      }
    }
  });

  try {
    await camera.init();
  } on Exception catch (e) {
    _showCameraException(scaffoldKey, e);
  }
  return camera;
}

void _showCameraException(GlobalKey<ScaffoldState> scaffoldKey,
    CameraException e) {
  logError(e.code, e.description);
  showInSnackBar(scaffoldKey, 'Error: ${e.code}\n${e.description}');
}

void showInSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
