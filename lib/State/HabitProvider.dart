import 'package:flutter/material.dart';
import 'package:refine_basic/Utils/Utils.dart';
import 'package:uuid/uuid.dart';
import '../Model/HabitModel.dart';
import '../Service/NotificationService.dart';
class HabitProvider extends ChangeNotifier {
  List<HabitModel> _habits = [];
  final _uuid = Uuid();

  List<HabitModel> get habits => _habits;
  DateTime get selectedDate => _selectedDate;

  DateTime _selectedDate = DateTime.now();
  final NotificationService _notificationService = NotificationService();

  HabitProvider() {
    _notificationService.initialize();
  }


  void updateSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // List<HabitModel> getHabitsForDate(DateTime date) {
  //   return _habits.where((habit) {
  //     if (habit.isDaily) {
  //       return true; // Daily habits show up every day
  //     } else if (habit.selectedDays.isNotEmpty) {
  //       // For weekly habits, check if the selected day is in the habit's selectedDays
  //       String dayName = _getDayName(date.weekday);
  //       return habit.selectedDays.contains(dayName);
  //     } else {
  //       // For one-time habits, check if the date matches
  //       return habit.date.year == date.year &&
  //           habit.date.month == date.month &&
  //           habit.date.day == date.day;
  //     }
  //   }).toList();
  // }

  //new code after bottom sheet
  List<HabitModel> getHabitsForDate(DateTime date) {
    return _habits.where((habit) =>  habit.date.year == date.year &&  habit.date.month == date.month && habit.date.day == date.day).toList();
  }

  String _getDayName(int weekday) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekday - 1];
  }

  void addHabit(HabitModel habit) {

    final newHabit = HabitModel
      (
      id: _uuid.v4(),
      title: habit.title,
      icon: habit.icon,
      // details: habit.details,
      // isDaily: habit.isDaily,
      // selectedDays: habit.selectedDays,
      startTime: habit.startTime,
        endTime: habit.endTime,
        duration: habit.duration,
        reminderTime: habit.reminderTime,
      date: habit.date,
      isCompleted: false
    );
    _habits.add(newHabit);
    _scheduleNotification(newHabit);
    notifyListeners();
  }

  void editHabit(HabitModel updatedHabit) {
    final index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void addHabitFromImageData(String task, TimeOfDay time,DateTime selectedDate) {
    final icon = findBestMatchingIcon(task);
    final newHabit = HabitModel(

      id: Uuid().v4(),
      title: task,
        icon: icon,

      // isDaily: true,
      // selectedDays: [],
        startTime: time,
        endTime:  TimeOfDay(hour: time.hour+1,minute: 0),
        duration: Duration(hours: 1),
        reminderTime: time,
      date: selectedDate ,
      isCompleted: false
    );
    addHabit(newHabit);
  }

  void duplicateHabit(HabitModel habit) {
    final newHabit = HabitModel(
      id:  _uuid.v4(),
      title: '${habit.title} (Copy)',
      icon: habit.icon,
      // details: habit.details,
      // isDaily: habit.isDaily,
      // selectedDays: List.from(habit.selectedDays),
      startTime: habit.startTime,
      endTime: habit.endTime,
      duration: habit.duration,

      reminderTime: habit.reminderTime,
      date: habit.date,
    );
    _habits.add(newHabit);
    notifyListeners();
  }


  void toggleHabitCompletion(String id) {
    final habitIndex = _habits.indexWhere((h) => h.id == id);

      if (habitIndex != -1) {
        _habits[habitIndex].isCompleted = !(_habits[habitIndex].isCompleted ?? false);
        notifyListeners();
      }


  }



  // void _scheduleNotification(HabitModel habit) {
  //   if (habit.isDaily) {
  //     _scheduleDaily(habit);
  //   } else {
  //     _scheduleWeekly(habit);
  //   }
  // }

  //new code after bottom sheet
  void _scheduleNotification(HabitModel habit) {
    final scheduledDate =  DateTime(habit.date.year,habit.date.month,habit.date.day,habit.reminderTime.hour,habit.reminderTime.minute);

    _notificationService.scheduleNotification(
      id: habit.id.hashCode,
      title: 'Habit Reminder',
      body: 'Time for your habit: ${habit.title}',
      scheduledDate: scheduledDate,
    );
  }

  void _scheduleDaily(HabitModel habit) {
    final now = DateTime.now();
    final scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderTime.hour,
      habit.reminderTime.minute,
    );

    _notificationService.scheduleNotification(
      id: habit.id.hashCode,
      title: 'Habit Reminder',
      body: 'Time for your habit: ${habit.title}',
      scheduledDate: scheduledDate,
    );
  }

  // void _scheduleWeekly(HabitModel habit) {
  //   final now = DateTime.now();
  //   for (String day in habit.selectedDays) {
  //     final dayIndex = _getDayIndex(day);
  //     final scheduledDate = _getNextDayOfWeek(dayIndex, habit.reminderTime);
  //
  //     _notificationService.scheduleNotification(
  //       id: '${habit.id}$dayIndex'.hashCode,
  //       title: 'Habit Reminder',
  //       body: 'Time for your habit: ${habit.title}',
  //       scheduledDate: scheduledDate,
  //     );
  //   }
  // }

  int _getDayIndex(String day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days.indexOf(day.split(' ')[1]);
  }


  DateTime _getNextDayOfWeek(int dayIndex, TimeOfDay time) {
    DateTime now = DateTime.now();
    int daysUntilNextOccurrence = (dayIndex - now.weekday + 7) % 7;
    if (daysUntilNextOccurrence == 0 &&
        (now.hour > time.hour ||
            (now.hour == time.hour && now.minute >= time.minute))) {
      daysUntilNextOccurrence = 7;
    }
    return DateTime(
      now.year,
      now.month,
      now.day + daysUntilNextOccurrence,
      time.hour,
      time.minute,
    );
  }

  void _cancelNotification(int id) {
    _notificationService.cancelNotification(id.hashCode);
  }
}