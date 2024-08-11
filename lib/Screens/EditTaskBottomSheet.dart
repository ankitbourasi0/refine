import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

import '../Model/HabitModel.dart';
import '../State/HabitProvider.dart';
import '../Utils/ColorModel.dart';
import '../Utils/Utils.dart';


class EditTaskBottomSheet extends StatefulWidget {
  final HabitModel habit;

  const EditTaskBottomSheet({Key? key, required this.habit}) : super(key: key);

  @override
  _EditTaskBottomSheetState createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  late TextEditingController _titleController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late Duration _duration;
  late String selectedIcon;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.title);
    _selectedDate  = widget.habit.date;
    _startTime = widget.habit.startTime;
    _endTime =widget.habit.endTime;
    _duration = widget.habit.duration;
    selectedIcon = widget.habit.icon;
  }

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
                'Edit Task',
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
                child:  Image.asset(selectedIcon,   width: 32,
                  height: 32,
                  // color: selectedColor
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    // hintText: 'Good',
                    border: UnderlineInputBorder(),
                  ),
                  onChanged: (value){
                    setState(() {
                      selectedIcon = findBestMatchingIcon(value);
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
            onPressed: ()=> _saveEditedHabit(context),
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

  void _saveEditedHabit(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final editedHabit = HabitModel(
        id: widget.habit.id,
        title: _titleController.text,
        icon: selectedIcon,
        startTime: _startTime,
        endTime: _endTime,
        duration: _duration,
        reminderTime: _startTime,
        date: _selectedDate,
    );
    habitProvider.editHabit(editedHabit);
    Navigator.pop(context);
  }


}