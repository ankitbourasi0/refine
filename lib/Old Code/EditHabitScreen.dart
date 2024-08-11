// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Model/HabitModel.dart';
// import '../State/HabitProvider.dart';
//
// class EditHabitScreen extends StatefulWidget {
//   final HabitModel habit;
//
//   const EditHabitScreen({Key? key, required this.habit}) : super(key: key);
//
//   @override
//   _EditHabitScreenState createState() => _EditHabitScreenState();
// }
//
// class _EditHabitScreenState extends State<EditHabitScreen> {
//   late TextEditingController _titleController;
//   late TextEditingController _detailsController;
//   late bool isDaily;
//   late List<String> selectedDays;
//   late TimeOfDay selectedTime;
//   late DateTime selectedDate;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.habit.title);
//     _detailsController = TextEditingController(text: widget.habit.details);
//     isDaily = widget.habit.isDaily;
//     selectedDays = List.from(widget.habit.selectedDays);
//     selectedTime = widget.habit.reminderTime;
//     selectedDate  = widget.habit.date;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Edit Habit')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: 'Habit Title'),
//             ),
//             TextField(
//               controller: _detailsController,
//               decoration: InputDecoration(labelText: 'Details (optional)'),
//             ),
//             // Add other widgets for editing frequency, days, and time
//             // (similar to AddHabitScreen)
//             ElevatedButton(
//               onPressed: () => _saveEditedHabit(context),
//               child: Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _saveEditedHabit(BuildContext context) {
//     final habitProvider = Provider.of<HabitProvider>(context, listen: false);
//     final editedHabit = HabitModel(
//       id: widget.habit.id,
//       title: _titleController.text,
//       details: _detailsController.text,
//       isDaily: isDaily,
//       selectedDays: selectedDays,
//       reminderTime: selectedTime,
//       date:selectedDate
//     );
//     habitProvider.editHabit(editedHabit);
//     Navigator.pop(context);
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _detailsController.dispose();
//     super.dispose();
//   }
// }