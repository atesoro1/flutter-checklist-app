import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ZoomDrawer.of(context)!.close();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
            ),
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
          ),
      ),
    );
  }
}