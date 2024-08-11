import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Model/HabitModel.dart';

class DailyHabitView extends StatelessWidget {
  final DateTime date;
  final List<HabitModel> habits;

  const DailyHabitView({Key? key, required this.date, required this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('MMMM d, yyyy').format(date),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                leading: Icon(Icons.circle, color: habit.isCompleted ? Colors.green : Colors.grey),
                title: Text(habit.title),
                subtitle: Text('${habit.reminderTime.format(context)}'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Handle habit tap
                },
              );
            },
          ),
        ),
      ],
    );
  }
}