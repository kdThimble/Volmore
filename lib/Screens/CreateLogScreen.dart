import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunterring/Screens/Event/CreateEventPage.dart';
import 'package:volunterring/Screens/VolunteeringIdeas.dart';
import 'package:volunterring/Utils/Colors.dart';

class CreateLogScreen extends StatelessWidget {
  const CreateLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: SingleChildScrollView(
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: Get.height * 0.04,
            ),
            Row(
              children: [
                SizedBox(
                  width: Get.width * 0.03,
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                SizedBox(
                  width: Get.width * 0.03,
                ),
                Text(
                  "Create an Event",
                  style: TextStyle(
                      decorationColor: headingBlue,
                      color: headingBlue,
                      fontSize: Get.height * 0.03,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: Get.width * 0.05,
                ),
                Image.asset(
                  "assets/images/HiImage.png",
                  height: 120,
                  width: 120,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "Select if you have a past volunteer event or want to create new Event for your transcript.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Get.height * 0.022),
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Container(
              width: Get.width * 0.92,
              height: Get.height * 0.14,
              decoration: BoxDecoration(
                  color: Color(0xFF7FD8DE),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    width: Get.width * 0.28,
                    height: Get.height * 0.14,
                    decoration: BoxDecoration(
                        color: Color(0xFFE5FCF5),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/pastEvents.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Log Past Hours",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.022),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Text(
                              "Select if you have a past\nvolunteer event that you want \nto add to your transcript.",
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.height * 0.016),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                Get.to(CreateEventScreen());
              },
              child: Container(
                width: Get.width * 0.92,
                height: Get.height * 0.14,
                decoration: BoxDecoration(
                    color: Color(0xFF7FB8DE),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: Get.width * 0.28,
                      height: Get.height * 0.14,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 251, 251, 251),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/Event.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Create New Event",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Get.height * 0.022),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            children: [
                              Text(
                                "Select if you want to create a \nnew event",
                                textAlign: TextAlign.left,
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Get.height * 0.016),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Container(
              width: Get.width * 0.92,
              height: Get.height * 0.14,
              decoration: BoxDecoration(
                  color: Color(0xFFC8A2C8),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    width: Get.width * 0.28,
                    height: Get.height * 0.14,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 251, 251, 251),
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/volunteer_5.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Volunteering Ideas",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.022),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Text(
                              "Need help coming up with \nvolunteering  ideas? \nClick here!",
                              textAlign: TextAlign.left,
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: Get.height * 0.016),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ));
  }
}
