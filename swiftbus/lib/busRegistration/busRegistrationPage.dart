import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/busRegistration/finalbusregpage.dart';
import 'package:swiftbus/busRegistration/intermediatebusreg.dart';
import 'package:swiftbus/busRegistration/widgets/initialBusregwidget.dart';

class Busregistration extends StatefulWidget {
  const Busregistration({super.key});

  @override
  State<Busregistration> createState() => _BusregistrationState();
}

class _BusregistrationState extends State<Busregistration> {
  final PageController _pageController = PageController();
  Map<String, dynamic> busDetails = {};

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.orange,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(
                        (MediaQuery.of(context).size.width),
                        90,
                      ),
                      bottomRight: Radius.elliptical(
                        (MediaQuery.of(context).size.width),
                        90,
                      ),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Register your bus",
                      style: TextStyle(
                        fontSize: 24,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      InitialBusDetailsPage(
                        onNext: (initialDetails) {
                          setState(() {
                            busDetails = initialDetails;
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        },
                      ),
                      Intermediatebusreg(
                        initialDetails: busDetails,
                        onNext: (intermediateDetails) {
                          setState(() {
                            busDetails = intermediateDetails;
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          });
                        },
                      ),
                      Finalbusregpage(
                        busDetails: busDetails,
                        onNext: (finalDetails) {
                          setState(() {
                            busDetails = finalDetails;
                          });
                          // The navigation to BusSeatLayoutOverview is handled within Finalbusregpage
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
