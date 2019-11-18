// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class EyeDector {
  final Face _face;
  bool _leftEyeClosed = false;
  bool _rightEyeClosed = false;

  EyeDector(this._face) {
    execute();
  }

  execute() {
    if (_face != null) {
      if (_face.leftEyeOpenProbability != null &&
          _face.leftEyeOpenProbability <= 0.2) {
        _rightEyeClosed = true;
      }
      if (_face.rightEyeOpenProbability != null &&
          _face.rightEyeOpenProbability <= 0.2) {
        _leftEyeClosed = true;
      }
    }
  }

  bool getRightEyeClosed() {
    return _rightEyeClosed;
  }

  bool getLeftEyeClosed() {
    return _leftEyeClosed;
  }

  bool getCompleteEyesClosed() {
    return _rightEyeClosed && _leftEyeClosed;
  }
}
