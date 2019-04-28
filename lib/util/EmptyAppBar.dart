import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 24);
}
