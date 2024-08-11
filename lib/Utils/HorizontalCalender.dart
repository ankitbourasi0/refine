import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'ColorModel.dart';
class HorizontalCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime initialDate;

  const HorizontalCalendar({
    Key? key,
    required this.onDateSelected,
    required this.initialDate,
  }) : super(key: key);

  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late PageController _pageController;
  late DateTime _selectedDate;
  late List<DateTime> _visibleDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _visibleDates = _getVisibleDates(_selectedDate);
    _pageController = PageController(initialPage: 30, viewportFraction: 0.2);

  }

  List<DateTime> _getVisibleDates(DateTime centerDate) {
    return List.generate(
      60,
          (index) => centerDate.add(Duration(days: index - 30)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorModel = Provider.of<ColorModel>(context);
    final selectedColor = colorModel.selectedColor;

    return Container(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedDate = _visibleDates[index];
            widget.onDateSelected(_selectedDate);
          });
        },
        itemBuilder: (context, index) {
          final date = _visibleDates[index];
          return _buildDateItem(date,selectedColor);
        },
      ),
    );
  }

  Widget _buildDateItem(DateTime date,Color selectedColor) {
    final isSelected = date.day == _selectedDate.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
          widget.onDateSelected(_selectedDate);
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4,),
        width: 60,
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date).substring(0, 3),
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(

                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}