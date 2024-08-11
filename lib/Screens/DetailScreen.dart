import 'package:flutter/material.dart';
import 'package:refine_basic/Model/UserModel.dart';
import 'package:refine_basic/Screens/HabitListScreen.dart';
import 'package:refine_basic/Service/UserDataStorage.dart';
import 'HomeScreen.dart';

class DetailScreen extends StatefulWidget {
  final VoidCallback onPressed;
   final bool isDarkMode ;
  const DetailScreen({super.key, required this.onPressed, required this.isDarkMode});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserData();
  }

  Future<void>_loadUserData() async{
      final userData = await UserDataStorage.getUserData();
      if(userData !=null){
        setState(() {
          _nameController.text = userData.name;
          _ageController.text = userData.age.toString();
          _locationController.text = userData.location;

        });
      }
  }

  Future<void> _saveUserData() async {
    final userData=  UserModel(name: _nameController.text, age: int.tryParse(_ageController.text) ?? 0, location: _locationController.text);
    await UserDataStorage.saveUserData(userData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon( widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.onPressed,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [

                    _buildTextField("What's your name?",_nameController),
                    const SizedBox(height: 50),
                    _buildTextField("How old are you?",_ageController),
                    const SizedBox(height: 50),
                    _buildTextField("Where do you live?",_locationController),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildButton("Skip", () => _navigateToHabitList(context))),
                  const SizedBox(width: 10),
                  Expanded(child: _buildButton("Proceed", () => _proceedToHabitList(context))),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(8.0),
        focusColor: Colors.black87,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget _buildButton(String text,void Function() onPressed) {
    return FilledButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }


    void _navigateToHabitList(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HabitListScreen(),
        ),
      );
    }

    Future<void> _proceedToHabitList(BuildContext context) async {
      await _saveUserData();
      _navigateToHabitList(context);
    }

    @override
    void dispose() {
      _nameController.dispose();
      _ageController.dispose();
      _locationController.dispose();
      super.dispose();
    }
}