// // lib/screens/scan_image_screen.dart
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:refine_basic/Service/GeminService.dart';
// import '../State/HabitProvider.dart';
// import '../Service/GeminService.dart';
//
// class ScanImageScreen extends StatefulWidget {
//   @override
//   _ScanImageScreenState createState() => _ScanImageScreenState();
// }
//
// class _ScanImageScreenState extends State<ScanImageScreen> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Scan Image')),
//       body: Center(
//         child: _isLoading
//             ? CircularProgressIndicator()
//             : ElevatedButton(
//           onPressed: _scanImage,
//           child: Text('Scan Image'),
//         ),
//       ),
//     );
//   }
// }