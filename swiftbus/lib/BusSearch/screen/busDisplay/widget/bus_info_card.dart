import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/service/firestore.dart';

class BusInfoCard extends StatefulWidget {
  final String docId;

  const BusInfoCard({Key? key, required this.docId}) : super(key: key);

  @override
  State<BusInfoCard> createState() => _BusInfoCardState();
}

class _BusInfoCardState extends State<BusInfoCard> {
  Map<String, dynamic>? busDetails;

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  void _fetchBusDetails() async {
    FirestoreService firestoreService = FirestoreService();
    Map<String, dynamic>? details =
        await firestoreService.getBusDetails(widget.docId);

    if (details != null) {
      setState(() {
        busDetails = details;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (busDetails?['imageUrls'] != null &&
              busDetails!['imageUrls'].isNotEmpty)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                busDetails!['imageUrls'][0],
                height: 350,
                width: double.maxFinite,
                fit: BoxFit.fitWidth,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  busDetails?['busName'] ?? 'Bus Name',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bus Condition',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      busDetails?['busType'] ?? 'Bus Type',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  thickness: 5,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
