import 'package:flutter/material.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';

class Popup extends StatelessWidget {
  final String userId;
  final String busId;

  const Popup({
    super.key,
    required this.userId,
    required this.busId,
  });

  // Function for "Request Changes" pop-up
  void _ReqestChanges(BuildContext context) {
  TextEditingController seatController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm the request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: seatController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter nearest seat number here',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Center( // Centering the button
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
              ),
              child: const Text('Confirm', style: TextStyle(color: Colors.black),),
              onPressed: () {
                String seatNumber = seatController.text;
                DatabaseMethods().createRequest(userId, 'Request Changes', 'Medium', seatNumber, busId);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}


  // Function for "Report Medical or Social Concern" pop-up
  void _RportMedicalOrSocialConcern(BuildContext context) {
  TextEditingController seatController = TextEditingController();
  bool highPriority = true;
  bool mediumPriority = false;
  bool lowPriority = false;
  String priority = 'High';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Report medical or social concern'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: seatController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter nearest seat number here',
                  ),
                ),
                const SizedBox(height: 10),
                // Rounded corner orange box for priority selection
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange.shade300, // Light orange background
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  padding: const EdgeInsets.all(10), // Padding inside the box
                  child: Column(
                    children: [
                      const Text('Select priority level:'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('High'),
                          Switch(
                            value: highPriority,
                            onChanged: (bool newValue) {
                              setState(() {
                                highPriority = newValue;
                                mediumPriority = false;
                                lowPriority = false;
                                if(newValue){
                                  priority = 'High';
                                }else{
                                  priority = 'low';
                                }
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Medium'),
                          Switch(
                            value: mediumPriority,
                            activeColor: Colors.green,
                            onChanged: (bool newValue) {
                              setState(() {
                                highPriority = false;
                                mediumPriority = newValue;
                                lowPriority = false;
                                if(newValue){
                                  priority = 'Medium';
                                }else{
                                  priority = 'low';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Low'),
                          Switch(
                            value: lowPriority,
                            activeColor: Colors.green,
                            onChanged: (bool newValue) {
                              setState(() {
                                highPriority = false;
                                mediumPriority = false;
                                lowPriority = newValue;
                                priority = 'Low';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center( // Centering the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                  ),
                  child: const Text('Confirm', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    String seatNumber = seatController.text;
                    DatabaseMethods().createRequest(userId, 'Request Medical orSocial Concern', priority, seatNumber, busId);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );
}


  // Function for "Report Lost Item" pop-up
  void _ReportLostItem(BuildContext context) {
    TextEditingController lostItemController = TextEditingController();
    bool askHelpFromPassengers = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Report Lost Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: lostItemController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe item here',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ask help from passengers'),
                      Switch(
                        value: askHelpFromPassengers,
                            activeColor: Colors.green,
                        onChanged: (bool newValue) {
                          setState(() {
                            askHelpFromPassengers = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                Center( // Centering the button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Button color
                    ),
                    child: const Text('Confirm', style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      String message = lostItemController.text;
                      if(askHelpFromPassengers){
                        DatabaseMethods().sendNotificationtoPassenger(userId, message, busId);
                      }
                      DatabaseMethods().createRequest(userId, 'Passenger ask for help to find his lost item. Description: "$message"', 'High', '0', busId);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _ReqestChanges(context);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange, // Background color
              border: Border.all(color: Colors.black, width: 2), // Black outline
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            alignment: Alignment.center,
            child: const Text(
              'Request Changes',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _RportMedicalOrSocialConcern(context);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange, // Background color
              border: Border.all(color: Colors.black, width: 2), // Black outline
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            alignment: Alignment.center,
            child: const Text(
              'Report medical or social concern',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _ReportLostItem(context);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange, // Background color
              border: Border.all(color: Colors.black, width: 2), // Black outline
              borderRadius: BorderRadius.circular(15), // Rounded corners
            ),
            alignment: Alignment.center,
            child: const Text(
              'Report lost item',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}