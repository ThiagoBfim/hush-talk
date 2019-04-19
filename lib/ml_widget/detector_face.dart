// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hush_talk/word_cards/ListCards.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.imageSize, this.faces, this.context);

  var olhoEsquerdoFechado = false;
  var olhoDireitoFechado = false;
  final Size imageSize;
  final List<Face> faces;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    for (Face face in faces) {

//      _drawRectFace(canvas, face, size, paint);

      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 23.0,
            textDirection: TextDirection.ltr),
      );
      var labels = [];

      var olhoEsquerdoFechado = false;
      var olhoDireitoFechado = false;
      if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability <= 0.5) {
        labels.add("Olho esquerdo fechado");
        olhoEsquerdoFechado = true;
      } else  {
        labels.add("Olho esquerdo aberto");
        olhoEsquerdoFechado = false;
      }
      if (face.rightEyeOpenProbability != null && face.rightEyeOpenProbability <= 0.5) {
        labels.add("Olho direito fechado");
        olhoDireitoFechado = true;
      } else {
        labels.add("Olho direito aberto");
        olhoDireitoFechado = false;
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

  void _drawRectFace(ui.Canvas canvas, Face face, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

     canvas.drawRect(
      _scaleRect(
        rect: face.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

Rect _scaleRect({
  @required Rect rect,
  @required Size imageSize,
  @required Size widgetSize,
}) {
  final double scaleX = widgetSize.width / imageSize.width;
  final double scaleY = widgetSize.height / imageSize.height;

  return Rect.fromLTRB(
    rect.left.toDouble() * scaleX,
    rect.top.toDouble() * scaleY,
    rect.right.toDouble() * scaleX,
    rect.bottom.toDouble() * scaleY,
  );
}
