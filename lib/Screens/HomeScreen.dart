// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:refine_basic/State/HabitProvider.dart';
// import 'package:refine_basic/Utils/HorizontalCalender.dart';
//
// class HomeScreen extends StatelessWidget {
//   String getTodayMonthAndDate() {
//     final now = DateTime.now();
//     final monthNames = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December'
//     ];
//
//     String month = monthNames[now.month - 1]; // month is 1-indexed
//     int date = now.day;
//
//     return 'Today, $month $date';
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(getTodayMonthAndDate()),
//         actions: [
//           IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HorizontalCalendar(
//             initialDate: DateTime.now(),
//             onDateSelected: (selectedDate) {
//               // Update the provider with the selected date
//               Provider.of<HabitProvider>(context, listen: false)
//                   .updateSelectedDate(selectedDate);
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'My habits',
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ),
//     Expanded(
//     child: Consumer<HabitProvider>(
//     builder: (context, habitProvider, child) {
//     final selectedDate = habitProvider.selectedDate;
//     final habits = habitProvider.getHabitsForDate(selectedDate);
//
//     // return ListView.builder(
//     itemCount: habits.length,
//     itemBuilder: (context, index) {
//     final habit = habits[index];
//     return ListTile(
//     title: Text(habit.title),
//     subtitle: Text(habit.details ?? ''),
//     trailing: Text(habit.reminderTime.format(context)),
//     );
//     },
//     );
//     },
//     ),
//     ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: Icon(Icons.add),
//         backgroundColor: Colors.redAccent,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.transparent,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
//           BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildWeekCalendar() {
//     return Container(
//       height: 60,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           _buildDayItem('M', '2', true),
//           _buildDayItem('T', '3', false),
//           _buildDayItem('W', '4', false),
//           _buildDayItem('T', '5', false),
//           _buildDayItem('F', '6', false),
//           _buildDayItem('S', '7', false),
//           _buildDayItem('S', '8', false),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDayItem(String day, String date, bool isSelected) {
//     return Container(
//       width: 40,
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isSelected ? Colors.white : Colors.grey[800],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(day, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
//           Text(date, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHabitItem(String title, String time, bool isCompleted) {
//     return ListTile(
//       title: Text(title, style: TextStyle(color: Colors.white)),
//       subtitle: Text(isCompleted ? 'Completed at $time' : 'Usually completed at $time',
//           style: TextStyle(color: Colors.grey)),
//       trailing: isCompleted
//           ? Icon(Icons.check_circle, color: Colors.green)
//           : Icon(Icons.circle_outlined, color: Colors.grey),
//     );
//   }
// }