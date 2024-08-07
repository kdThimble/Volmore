// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunterring/Screens/dashboard.dart';
import 'package:volunterring/Services/authentication.dart';
import 'package:volunterring/Utils/Colors.dart';
import 'package:volunterring/widgets/InputFormFeild.dart';
import 'package:uuid/uuid.dart';
import 'package:volunterring/widgets/appbar_widget.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final _authMethod = AuthMethod();
  TimeOfDay? picked = TimeOfDay.now();

  String selectedOccurrence =
      'No occurrence'; // Initial value set to prevent null issues
  List<String> _groupNames = [];
  String? _selectedGroup;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _fetchGroupNames();
  }

  List<dynamic> generateDates(
      DateTime startDate, DateTime endDate, String occurrence) {
    List<dynamic> dates = [];
    DateTime currentDate = startDate;

    if (occurrence == 'Weekly') {
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        dates.add({
          "date": currentDate,
          "isVerified": false,
          "isLocation": false,
          "duration": "00:00"
        });
        currentDate = currentDate.add(const Duration(days: 7));
      }
    } else {
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        dates.add({
          "date": currentDate,
          "isVerified": false,
          "isLocation": false,
          "duration": "00:00"
        });
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    return dates;
  }

  Future<void> _fetchGroupNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('groups').get();
      print("querySnapshot.docs: ${querySnapshot.docs}");
      List<String> groupNames =
          querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      setState(() {
        _groupNames = groupNames;
      });
    } catch (e) {
      print("Error fetching group names: $e");
    }
  }

  Future<void> _addGroup(String name, String color) async {
    try {
      String id = _uuid.v4();
      await FirebaseFirestore.instance.collection('groups').doc(id).set({
        'name': name,
        'color': color,
      });
      _fetchGroupNames();
    } catch (e) {
      print("Error adding group: $e");
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes to free up resources
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    dateController.dispose();

    super.dispose();
  }

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              TextField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Group Color'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                String color = _colorController.text;
                if (name.isNotEmpty && color.isNotEmpty) {
                  _addGroup(name, color);
                  _nameController.clear();
                  _colorController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Group'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {bool isEndDate = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          controller.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          selectedDate = picked;
          controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        }
      });
    }
  }

  _selectTime(BuildContext context, TextEditingController controller) async {
    picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      controller.text = picked!.format(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: simpleAppBar(context , ""),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset("assets/icons/l.png")),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Schedule New Job',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: headingBlue,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Enter detail about the new job',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff0c4a6f),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InputFeildWidget(
                  title: 'Job Title*',
                  controller: titleController,
                  hintText: 'Trash Clean Up',
                  validator: nameValidator,
                ),
                const SizedBox(height: 20),
                InputFeildWidget(
                  title: 'Job Description',
                  controller: descriptionController,
                  maxlines: 5,
                  hintText: 'Job Description',
                  validator: nameValidator,
                ),
                const SizedBox(height: 20),
                InputFeildWidget(
                  title: 'Location',
                  controller: locationController,
                  maxlines: 1,
                  prefixicon: const Icon(
                    Icons.location_on,
                    color: Colors.grey,
                  ),
                  hintText: '123 Main St New York, NY 10001',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Occurrence',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: headingBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0.4,
                        blurRadius: 10,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedOccurrence,
                    icon: const Icon(CupertinoIcons.chevron_down, size: 20,),
                    decoration: InputDecoration(
                      filled: true,

                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      fillColor: Colors.white,
                      focusColor: Colors.white,

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 213, 215, 215),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors
                              .grey[400]!, // Change this to your desired color
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'No occurrence',
                        child: Text('No occurrence'),
                      ),
                      DropdownMenuItem(
                        value: 'Daily',
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: 'Weekly',
                        child: Text('Weekly'),
                      ),
                      DropdownMenuItem(
                        value: 'Custom',
                        child: Text('Custom'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedOccurrence = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: headingBlue,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0.4,

                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: dateController,

                          onTap: () => _selectDate(context, dateController),
                          readOnly: true,

                          // Prevent keyboard from appearing
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: greyColor,
                            ),
                            filled: true,
                            hintText: 'Select Date',
                            hintStyle: TextStyle(
                                color: Colors.grey[900],
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 213, 215, 215),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey[
                                    400]!, // Change this to your desired color
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: width * 0.25,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 0.4,

                            blurRadius: 10,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: timeController,

                        onTap: () => _selectTime(context, timeController),
                        readOnly: true,

                        // Prevent keyboard from appearing
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Time',
                          hintStyle: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 213, 215, 215),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey[
                                  400]!, // Change this to your desired color
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                selectedOccurrence != 'No occurrence'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'End Date',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: headingBlue,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 0.4,

                                        blurRadius: 10,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: endDateController,

                                    onTap: () => _selectDate(
                                        context, endDateController,
                                        isEndDate: true),

                                    readOnly: true,

                                    // Prevent keyboard from appearing
                                    decoration: InputDecoration(
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: greyColor,
                                      ),
                                      filled: true,
                                      hintText: 'Select End Date',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[900],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 213, 215, 215),
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey[
                                              400]!, // Change this to your desired color
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: width * 0.25,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 0.4,
                                      blurRadius: 10,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: endTimeController,

                                  onTap: () =>
                                      _selectTime(context, endTimeController),
                                  readOnly: true,

                                  // Prevent keyboard from appearing
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Time',
                                    hintStyle: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 213, 215, 215),
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Colors.grey[
                                            400]!, // Change this to your desired color
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(height: 20),
                const Text(
                  'Grouping',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: headingBlue,
                  ),
                ),
                const SizedBox(height: 5),
                _groupNames.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 0.4,

                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: DropdownButtonFormField<String>(
                          hint: const Text('Select a Group'),
                          value: _selectedGroup,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            filled: true,
                            hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 19,
                                fontWeight: FontWeight.w400),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 213, 215, 215),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.grey[
                                    400]!, // Change this to your desired color
                                width: 2.0,
                              ),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            if (newValue == 'add_new') {
                              _showAddGroupDialog();
                            } else {
                              setState(() {
                                _selectedGroup = newValue;
                              });
                            }
                          },
                          items: [
                            ..._groupNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            const DropdownMenuItem<String>(
                              value: 'add_new',
                              child: Text('Add New Group'),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {

                    titleController.text = titleController.text;


                    if (titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        locationController.text.isNotEmpty &&
                        selectedOccurrence.isNotEmpty) {
                      DateTime endDate = selectedOccurrence == 'No occurrence'
                          ? selectedDate
                          : DateFormat('dd/MM/yyyy')
                              .parse(endDateController.text);
                      List<dynamic> allDates = generateDates(
                          selectedDate, endDate, selectedOccurrence);

                      String res = await _authMethod.addEvent(
                        title: titleController.text,
                        description: descriptionController.text,
                        date: selectedDate,
                        location: locationController.text,
                        occurrence: selectedOccurrence,
                        group: _selectedGroup!,
                        time: timeController.text,
                        endDate: endDate,
                        dates: allDates,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res)),
                      );

                      if (res == "Event added successfully") {
                        // Clear the form fields
                        titleController.clear();
                        descriptionController.clear();
                        locationController.clear();
                        setState(() {
                          dateController.clear();
                          endDateController.clear();
                          selectedDate = DateTime.now();
                          selectedOccurrence = 'No occurrence';
                          _selectedGroup = null;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()),
                            (route) => false);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please fill in all fields")),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Submit Event',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
