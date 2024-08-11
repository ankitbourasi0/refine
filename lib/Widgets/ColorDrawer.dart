import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/ColorModel.dart';

class ColorDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorModel = Provider.of<ColorModel>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorModel.selectedColor,
            ),
            child: const Text(
              'Color Selection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ...List.generate(colorModel.colors.length, (index) {
            return ListTile(
              leading: Icon(Icons.color_lens, color: colorModel.colors[index]),
              title: Text('Color ${index + 1}'),
              onTap: () {
                colorModel.setColor(index);
                Navigator.pop(context);
              },
            );
          }),
        ],
      ),
    );
  }
}