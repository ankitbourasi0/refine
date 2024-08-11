import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:refine_basic/Model/HabitModel.dart';
import 'package:refine_basic/Screens/EditTaskBottomSheet.dart';
import 'package:refine_basic/Screens/ScanImageScreen.dart';
import 'package:refine_basic/Service/GeminService.dart';
import 'package:refine_basic/Service/UserDataStorage.dart';
import 'package:refine_basic/Utils/HorizontalCalender.dart';
import '../Utils/ColorModel.dart';
import '../State/HabitProvider.dart';

import '../Utils/DualFAB.dart';
import '../Utils/Utils.dart';
import '../Widgets/ColorDrawer.dart';
import 'NewTaskBottomSheet.dart';

class HabitListScreen extends StatefulWidget {
  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final GeminiService _geminiService =
      GeminiService('AIzaSyD9NTJz00BEtWaDc3Z9foBImb8nwuQ8dI0');

  bool _isLoading = false;
  final _picker = ImagePicker();
  XFile? _image;
late Color selectedColor;

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose vegetable image'),
          actions: <Widget>[
            TextButton(
              child: const Text('Camera'),
              onPressed: () {
                _scanImage();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () {
                getImage();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> _scanImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await _processImage(image);
    }
  }

  Future<void> _processImage(XFile image) async {
    try {
      final imageBytes = await image.readAsBytes();
      final extractedData =
          await _geminiService.extractTaskFromImage(imageBytes);

      if (extractedData.isNotEmpty) {
        final habitProvider =
            Provider.of<HabitProvider>(context, listen: false);
        final selectedDate = habitProvider.selectedDate;
        for (var item in extractedData) {
          try {
            final time = parseTimeString(item['time']);
            habitProvider.addHabitFromImageData(
                item['task'], time, selectedDate);
          } catch (e) {
            print('Error parsing time: ${item["time"]} - $e');
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit added successfully!'),
            backgroundColor: selectedColor,),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to extract task or time from the image.'),
            backgroundColor: selectedColor,),
        );
      }
    } catch (e) {
      print('Error processing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An error occurred while processing the image.'),
          backgroundColor: selectedColor,),
      );
    }
  }

  void _showBottomSheet(
      BuildContext context, HabitModel habit, HabitProvider habitProvider) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${habit.reminderTime.format(context)}, ${habit.reminderTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                habit.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // if (habit.details != null && habit.details!.isNotEmpty)
              //   Text(
              //     habit.details!,
              //     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              //   ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildActionButton(Icons.delete, 'Delete', () {
                    Navigator.pop(context);
                    habitProvider.deleteHabit(habit.id);
                  }),
                  buildActionButton(Icons.copy, 'Duplicate', () {
                    Navigator.pop(context);
                    habitProvider.duplicateHabit(habit);
                  }),
                  buildActionButton(Icons.check_circle, 'Complete', () {
                    Navigator.pop(context);
                    habitProvider.toggleHabitCompletion(habit.id);
                  }),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: EditTaskBottomSheet(habit: habit),
                      ),
                    ),
                  );
                },
                child: Text('Edit Task'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String username = "";
  void _loadUserData() async {
    final userData = await UserDataStorage.getUserData();
    if (userData != null) {
      setState(() {
        username = userData.name;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final colorModel = Provider.of<ColorModel>(context);
    selectedColor = colorModel.selectedColor;
    return Consumer<HabitProvider>(builder: (context, habitProvider, child) {
      return SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   actions: [
            //     IconButton(icon: Icon(Icons.account_circle), onPressed: () {}),
            //   ],
            // ),
          key: _scaffoldKey,
            drawer:  ColorDrawer(),

            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        // Text(getTodayMonthAndDate(),style: TextStyle(fontSize: 16),),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hello, " + username.split(" ")[0],
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: .5),
                            ),
                            IconButton(
                              color: selectedColor,
                              icon: Icon(Icons.account_circle),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              iconSize: 36,
                            ),
                          ],
                        ),
                        Text(
                          "May this day be good for you!",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                HorizontalCalendar(
                    initialDate: habitProvider.selectedDate,
                    onDateSelected: (selectedDate) {
                      // Update the provider with the selected date
                      Provider.of<HabitProvider>(context, listen: false)
                          .updateSelectedDate(selectedDate);
                    }),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'My habits',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Builder(
                      builder: (context) {
                        return _buildHabitList(habitProvider,selectedColor);
                      },
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: DualFAB(
                onAddPressed: _addNewTask, onCameraPressed: _showMyDialog)),
      );
    });
  }

  void _addNewTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: NewTaskBottomSheet(),
        ),
      ),
    );
  }

  Widget _buildHabitList(HabitProvider habitProvider,Color selectedColor) {
    final selectedDate = habitProvider.selectedDate;
    final habits = habitProvider.getHabitsForDate(selectedDate);
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Dismissible(
          key: Key(habit.title),
          background: Card(
            child: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            habitProvider.deleteHabit(habit.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${habit.title} deleted')
              ,
                backgroundColor: selectedColor,),
            );
          },
          child: Card(
            child: InkWell(
              onTap: () {
                _showBottomSheet(context, habit, habitProvider);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Image.asset(habit.icon,   width: 32,
                        height: 32,
                        // color: selectedColor
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: habit.isCompleted == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          Text(
                            'Start at ${habit.reminderTime.format(context)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        habitProvider.toggleHabitCompletion(habit.id);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: selectedColor, width: 2),
                          color: habit.isCompleted == true
                              ? selectedColor
                              : Colors.transparent,
                        ),
                        child: habit.isCompleted == true
                            ? Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
