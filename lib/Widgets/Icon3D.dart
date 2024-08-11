// /*
// import 'dart:html';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../Enums/IconCategory.dart';
// import '../Utils/Utils.dart';
//
// class Icon3D extends StatefulWidget {
//   final IconCategory category;
//   final double size;
//
//   Icon3D({required this.category, this.size = 48});
//
//   @override
//   _Icon3DState createState() => _Icon3DState();
// }
//
// class _Icon3DState extends State<Icon3D> {
//   Future<File>? _iconFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _iconFile = _getIconFile();
//   }
//
//   Future<File> _getIconFile() async {
//     final iconInfo = iconMap[widget.category]!;
//     final cachePath = await _getLocalPath();
//     final file = File('$cachePath/${iconInfo.iconName}.png');
//
//     if (await file.exists()) {
//       return file;
//     }
//
//     try {
//       final response = await http.get(Uri.parse('https://3dicons.co/api/v1/icon/${iconInfo.iconName}'));
//       if (response.statusCode == 200) {
//         await file.writeAsBytes(response.bodyBytes);
//         return file;
//       }
//     } catch (e) {
//       print('Failed to download icon: $e');
//     }
//
//     // If download fails, return a file object for the local asset
//     return File(iconInfo.localAssetPath);
//   }
//
//   Future<String> _getLocalPath() async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<File>(
//       future: _iconFile,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//           if (snapshot.data!.path.startsWith('assets')) {
//             // Local asset
//             return Image.asset(
//               snapshot.data!.path,
//               width: widget.size,
//               height: widget.size,
//             );
//           } else {
//             // Cached file
//             return Image.file(
//               snapshot.data!,
//               width: widget.size,
//               height: widget.size,
//             );
//           }
//         } else {
//           // While loading, show a placeholder or loading indicator
//           return SizedBox(
//             width: widget.size,
//             height: widget.size,
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     );
//   }
// }
// */
