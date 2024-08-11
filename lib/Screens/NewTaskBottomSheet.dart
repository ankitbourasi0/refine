import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:refine_basic/Enums/IconCategory.dart';
import 'package:refine_basic/Utils/ColorModel.dart';
import 'package:refine_basic/Utils/IconInfo.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:refine_basic/Utils/Utils.dart';
import 'package:uuid/uuid.dart';

import '../Model/HabitModel.dart';
import '../State/HabitProvider.dart';


class NewTaskBottomSheet extends StatefulWidget {
  @override
  _NewTaskBottomSheetState createState() => _NewTaskBottomSheetState();
}

class _NewTaskBottomSheetState extends State<NewTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay(hour: 6, minute: 15);
  TimeOfDay _endTime = TimeOfDay(hour: 6, minute: 30);
  Duration _duration = Duration(minutes: 15);
  String _selectedIcon = 'assets/fallback_icons/write.png';





  @override
  Widget build(BuildContext context) {
    final colorModel = Provider.of<ColorModel>(context);
    final selectedColor = colorModel.selectedColor;

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Task',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(_selectedIcon,width: 24,height: 24,),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Learn Coding!',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value){
                    setState(() {
                      _selectedIcon = findBestMatchingIcon(value);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('When?', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                DateFormat('dd/MM/yy').format(_selectedDate),
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(isStartTime: true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _startTime.format(context),
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text('-'),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectTime(isStartTime: false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: selectedColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _endTime.format(context),
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text('How long?', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Slider(
            value: _duration.inMinutes.toDouble(),
            min: 1,
            max: 90,
            divisions: 6,
            label: '${_duration.inMinutes}m',
            onChanged: (value) {
              setState(() {
                _duration = Duration(minutes: value.round());
                _endTime = TimeOfDay(
                  hour: (_startTime.hour + _duration.inHours) % 24,
                  minute: (_startTime.minute + _duration.inMinutes % 60) % 60,
                );
              });
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            child: Text('Create Task',style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedColor,
              minimumSize: Size(double.infinity, 50),

            ),
            onPressed: _createTask,
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime({required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          _endTime = TimeOfDay(
            hour: (picked.hour + _duration.inHours) % 24,
            minute: (picked.minute + _duration.inMinutes % 60) % 60,
          );
        } else {
          _endTime = picked;
          _duration = Duration(
            hours: (_endTime.hour - _startTime.hour + 24) % 24,
            minutes: (_endTime.minute - _startTime.minute + 60) % 60,
          );
        }
      });
    }
  }

  void _createTask() {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final newHabit = HabitModel(
      id: Uuid().v4(),
      title: _titleController.text,
      icon: _selectedIcon,
      date: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
      duration: _duration,
      reminderTime: _startTime,
    );
    habitProvider.addHabit(newHabit);
    Navigator.pop(context);
  }


}