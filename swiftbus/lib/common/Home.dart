import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:swiftbus/common/NavBar.dart';
import 'package:swiftbus/UserSupport/Passenger/UserSupport.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.orange,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hello, User',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            showPopover(
                  context: context,
                  bodyBuilder: (context) => Popup(),
                  width: 250, 
                  height: 166,
                  backgroundColor: Colors.transparent,
                  direction: PopoverDirection.top
                );
          },
          tooltip: 'pop up box',
          backgroundColor: Colors.orange,
          shape: const CircleBorder(),
          child: const Icon(Icons.support_agent),
        ),
      ),
      bottomNavigationBar: Navbar(context),
    );
  }
}