// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Model/HabitModel.dart';
// import '../State/HabitProvider.dart';
// import 'package:uuid/uuid.dart';
// class AddHabitScreen extends StatefulWidget {
//   const AddHabitScreen({super.key});
//
//   @override
//   State<AddHabitScreen> createState() => _AddHabitScreenState();
// }
//
// class _AddHabitScreenState extends State<AddHabitScreen> {
//   bool isDaily = true;
//   TimeOfDay selectedTime = TimeOfDay(hour: 7, minute: 46);
//   bool isEveryDay = true;
//   List<String> selectedDays = [];
//   DateTime selectedDate = DateTime.now();
//
//   final _titleController = TextEditingController();
//   final _detailsController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: Text("Add habit"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//                 child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: InputDecoration(labelText: "Your Habit"),
//                 ),
//                 TextField(
//                   controller: _detailsController,
//                   decoration: InputDecoration(labelText: "Details (optional)"),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Text('FREQUENCY',
//                     style:
//                         TextStyle(fontWeight: FontWeight.w400, fontSize: 22)),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     _buildFrequencyOption('Daily', isDaily),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     _buildFrequencyOption('Specific days', !isDaily),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Text('REMAINDERS',
//                     style:
//                         TextStyle(fontWeight: FontWeight.w400, fontSize: 22)),
//                 Row(
//                   children: [
//                     _buildTimeSelector(),
//                     SizedBox(
//                       width: 8,
//                     ),
//                     Expanded(child: _buildRemainderDays()),
//                   ],
//                 ),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedDate = DateTime.now();
//                         });
//                       },
//                       child: Text('Today'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           selectedDate = DateTime.now().add(Duration(days: 1));
//                         });
//                       },
//                       child: Text('Tomorrow'),
//                     ),
//                   ],
//                 ),
//         ElevatedButton(
//           child: Text('Create'),
//           onPressed: () {
//             _saveHabit(context);
//           },
//         ),],
//             )
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _saveHabit(BuildContext context) {
//     final habitProvider = Provider.of<HabitProvider>(context, listen: false);
//
//
//     final newHabit = HabitModel(
//       id: Uuid().v4(), // The id will be generated in the HabitProvider
//       title: _titleController.text,
//       details: _detailsController.text,
//       isDaily: isDaily,
//       selectedDays: isDaily ? [] : selectedDays,
//       reminderTime: selectedTime,
// date: selectedDate
//     );
//     habitProvider.addHabit(newHabit);
//     Navigator.pop(context);
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _detailsController.dispose();
//     super.dispose();
//   }
//
//   Widget _buildFrequencyOption(String label, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isDaily = label == "Daily";
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//             color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(20)),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 22,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimeSelector() {
//     return GestureDetector(
//       onTap: () async {
//         final TimeOfDay? pickedTime =
//             await showTimePicker(context: context, initialTime: selectedTime);
//
//         if (pickedTime != null && pickedTime != selectedTime) {
//           setState(() {
//             selectedTime = pickedTime;
//           });
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(20)),
//         child: Text('${selectedTime.format(context)}'),
//       ),
//     );
//   }
//
//   Widget _buildRemainderDays() {
//     return GestureDetector(
//       onTap: () {
//         //show days selection dialog
//         _showDaySelectionDialog();
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(isEveryDay ? 'Every day' : selectedDays.join(', ')),
//       ),
//     );
//   }
//
//   void _showDaySelectionDialog() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Select Days'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _buildDayCheckbox('Every Monday'),
//                 _buildDayCheckbox('Every Tuesday'),
//                 _buildDayCheckbox('Every Wednesday'),
//                 _buildDayCheckbox('Every Thursday'),
//                 _buildDayCheckbox('Every Friday'),
//                 _buildDayCheckbox('Every Saturday'),
//                 _buildDayCheckbox('Every Sunday'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: Text('Save'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         });
//   }
//
//   _buildDayCheckbox(String day) {
//     return CheckboxListTile(
//       title: Text(day),
//       value: selectedDays.contains(day),
//       onChanged: (bool? value) {
//         setState(() {
//           if (value == true) {
//             selectedDays.add(day);
//           } else {
//             selectedDays.remove(day);
//           }
//
//           isEveryDay = selectedDays.length == 7;
//         });
//       },
//     );
//   }
// }
