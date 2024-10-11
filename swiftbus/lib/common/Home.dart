import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/BusSearch/screen/busSearch/search_buses_screen.dart';
import 'package:swiftbus/UserSupport/Conductor/ViewUserRequest.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/common/NavBar.dart';
import 'package:swiftbus/UserSupport/Passenger/UserSupport.dart';
import 'package:swiftbus/common/ScanQr.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? busId;
  String? userId;
  Map<String, dynamic>? _userDetails;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;
  List<String> _imageUrls = [];
  bool _imagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _checkUserIdInPreferences();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier(0);
    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page!.round();
    });
    _loadImagesFromStorage();
    _loadBackgroundImageFromStorage();
  }

  Future<void> _loadBackgroundImageFromStorage() async {
    try {
      

      if (mounted) {
        setState(() {
          
        });
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  // Load images from 'bus_images' folder in Firebase Storage
  Future<void> _loadImagesFromStorage() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('slide');
      final ListResult result = await storageRef.listAll();
      List<String> imageUrls = [];
      for (var item in result.items) {
        final String imageUrl = await item.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      if (mounted) {
        setState(() {
          _imageUrls = imageUrls;
          _imagesLoaded = true;
        });
        _autoSlide(); // Start the auto-slide only after images are loaded
      }
    } catch (e) {
      debugPrint('Error loading images: $e');
    }
  }

  void _autoSlide() {
    if (_imageUrls.isEmpty) return; // No images to slide
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      int nextPage = (_currentPageNotifier.value + 1) % _imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _autoSlide(); // Continue the slide
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userID');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      await _fetchUserDetails(storedUserId);
      _fetchBusId();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _fetchUserDetails(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    final userdata = doc.data() as Map<String, dynamic>?;
    setState(() {
      _userDetails = userdata;
    });
  }

  void _fetchBusId() {
    if (userId != null) {
      DatabaseMethods().getBusId(userId!).listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            busId = snapshot.docs.first['busid'];
          });
        } else {
          setState(() {
            busId = null;
          });
        }
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthService().signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User signed out')),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userID');
      await prefs.remove('role');
      await prefs.remove('temprole');

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

 @override
Widget build(BuildContext context) {
  String firstName = _userDetails?['firstname'] ?? 'User';

  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 100,
      backgroundColor: Color(0xFFFD6905),
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
          Text(
            'Hello, $firstName',
            style: const TextStyle(fontSize: 24, color: Colors.black),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(  // Wrap the Column in a SingleChildScrollView
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Welcome to SwiftBus',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ), // Added welcome text here

          if (_imagesLoaded && _imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(_imageUrls[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.5),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder<int>(
                        valueListenable: _currentPageNotifier,
                        builder: (context, currentPage, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _imageUrls.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 12,
                                height: 12,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == index
                                      ? Theme.of(context).primaryColor
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (!_imagesLoaded)
            Center(child: CircularProgressIndicator()), // Show loading indicator while images load

          // Show Previous Requests text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Show Previous Requests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Clickable container with background image
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewUserRequest(),
                ),
              );
            },
            child: Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/complain.png'), // Use AssetImage for asset background
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Book a Bus',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Clickable container with background image
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBusesScreen(),
                ),
              );
            },
            child: Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/bus.png'), // Use AssetImage for asset background
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            if (busId == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SacnQr(),
                ),
              );
            } else {
              showPopover(
                context: context,
                bodyBuilder: (context) => Popup(userId: userId!, busId: busId!),
                width: 250,
                height: 166,
                backgroundColor: Colors.transparent,
                direction: PopoverDirection.top,
              );
            }
          },
          tooltip: 'pop up box',
          backgroundColor: Color(0xFFFD6905),
          shape: const CircleBorder(),
          child: const Icon(Icons.support_agent),
        ),
      ),
    bottomNavigationBar: const Navbar(selectedIndex: 0,),
  );
}
}