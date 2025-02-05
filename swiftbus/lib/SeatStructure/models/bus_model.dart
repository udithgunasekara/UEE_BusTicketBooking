class BusModel {
  final String id;
  final String name;
  final String imageUrl;
  final List<List<int?>> seatMap;
  final int totalSeats;

  BusModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.seatMap,
    required this.totalSeats,
  });
}

final List<BusModel> busModels = [
  BusModel(
    id: 'standard-56',
    name: 'Standard 56-Seater',
    imageUrl: '/api/placeholder/300/200',
    totalSeats: 56,
    seatMap: [
      [01, 02, null, 03, 04, 05],
      [06, 07, null, 08, 09, 10],
      [11, 12, null, 13, 14, 15],
      [16, 17, null, 18, 19, 20],
      [21, 22, null, 23, 24, 25],
      [26, 27, null, 28, 29, 30],
      [31, 32, null, 34, 35, 36],
      [37, 38, null, 39, 40, 41],
      [42, 43, null, 44, 45, 46],
      [47, 48, null, 49, 50, 51],
      [52, 53, null, 54, 55, 56],
    ],
  ),
  BusModel(
    id: 'luxury-40',
    name: 'Luxury 40-Seater',
    imageUrl: '/api/placeholder/300/200',
    totalSeats: 40,
    seatMap: [
      [01, 02, null, 03, 04],
      [05, 06, null, 07, 08],
      [09, 10, null, 11, 12],
      [13, 14, null, 15, 16],
      [17, 18, null, 19, 20],
      [21, 22, null, 23, 24],
      [25, 26, null, 27, 28],
      [29, 30, null, 31, 32],
      [33, 34, null, 35, 36],
      [37, 38, null, 39, 40],
    ],
  ),
];
