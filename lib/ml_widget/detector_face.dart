// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.imageSize, this.faces, this.context);

  final Size imageSize;
  final List<Face> faces;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    for (Face face in faces) {


      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 23.0,
            textDirection: TextDirection.ltr),
      );
      var labels = [];

      if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability <= 0.5) {
        labels.add("Olho esquerdo fechado");
      } else  {
        labels.add("Olho esquerdo aberto");
      }
      if (face.rightEyeOpenProbability != null && face.rightEyeOpenProbability <= 0.5) {
        labels.add("Olho direito fechado");
      } else {
        labels.add("Olho direito aberto");
      }

      builder.pushStyle(ui.TextStyle(color: Colors.green));
      for (String label in labels) {
        builder.addText('Label: $label' '\n');
      }
      builder.pop();

      canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(
            width: size.width,
          )),
        const Offset(0.0, 0.0),
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}