import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:volunterring/Screens/CreateLogScreen.dart';
import 'package:volunterring/Screens/Event/events_widget.dart';
import 'package:volunterring/Services/authentication.dart';
import 'package:volunterring/Utils/Colors.dart';
import '../../Models/event_data_model.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage>
    with SingleTickerProviderStateMixin {
  final _authMethod = AuthMethod();
  late Future<List<EventDataModel>> _eventsFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _eventsFuture = _authMethod.fetchEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final Map<String, Color> colorMap = {
    'Green': Colors.green,
    'Pink': Colors.pink,
    'Orange': Colors.orange,
    'Red': Colors.red,
    'Yellow': Colors.yellow,
    'Grey': Colors.grey,
    'Blue': Colors.blue,
    'Purple': Colors.purple,
    'Brown': Colors.brown,
    'Cyan': Colors.cyan,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Today's Event"),
              Tab(text: "Upcoming Event"),
              Tab(text: "Past Event"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildEventList("Today's Events", (event) {
            return event.date.toString().split(' ')[0] ==
                DateTime.now().toString().split(' ')[0];
          }),
          buildEventList("Upcoming Events", (event) {
            DateTime eventDate = DateTime.parse(event.date.toString());
            DateTime today = DateTime.now();
            return eventDate.isAfter(today);
          }),
          buildEventList("Past Events", (event) {
            DateTime eventDate = DateTime.parse(event.date.toString());
            DateTime today = DateTime.now().subtract(Duration(days: 1));
            return eventDate.isBefore(today);
          }),
        ],
      ),
    );
  }

  Widget buildEventList(String title, bool Function(EventDataModel) filter) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: headingBlue,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (title == "Today's Events")
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    textStyle:
                        const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onPressed: () {
                    Get.to(const CreateLogScreen());
                  },
                  child: const Text(
                    'Start Logging',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        FutureBuilder<List<EventDataModel>>(
          future: _eventsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No events found'));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    EventDataModel event = snapshot.data![index];
                    Color color = colorMap[event.groupColor] ?? Colors.pink;
                    return filter(event)
                        ? EventWidget(event, color)
                        : Container();
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
