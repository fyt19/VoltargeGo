import 'package:flutter/material.dart';

class LastRentalsPage extends StatelessWidget {
  const LastRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Last Rentals', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2DD4BF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _rentalCard(
              context: context,
              status: true,
              date: '03/27/2024',
              name: 'Elif Y',
              rating: 2,
              price: '€0.75 / Hour',
              kw: '22 kW',
              buttonText: 'Rent Again',
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
            ),
            const SizedBox(height: 12),
            _rentalCard(
              context: context,
              status: false,
              date: '06/01/2023',
              name: 'Ethan J',
              rating: 4,
              price: '€0.50 / Hour',
              kw: '22 kW',
              buttonText: 'Rent Again',
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
            ),
            const SizedBox(height: 12),
            _rentalCard(
              context: context,
              status: false,
              date: '02/17/2023',
              name: 'Sophia W',
              rating: 4,
              price: '€0.50 / Hour',
              kw: '22 kW',
              buttonText: 'Rent Again',
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
            ),
            const SizedBox(height: 12),
            _rentalCard(
              context: context,
              status: true,
              date: '08/28/2024',
              name: 'İrem T',
              rating: 3,
              price: '€1.25 / Hour',
              kw: '22 kW',
              buttonText: 'Rent Again',
              onPressed: () {
                Navigator.pushNamed(context, '/reservation');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _rentalCard({
    required BuildContext context,
    required bool status,
    required String date,
    required String name,
    required int rating,
    required String price,
    required String kw,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A44),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2DD4BF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  status ? Icons.check_circle : Icons.cancel,
                  color: status ? const Color(0xFFB9FF4B) : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  status ? 'Available' : 'Occupied',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (int i = 0; i < rating; i++)
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                for (int i = rating; i < 5; i++)
                  const Icon(Icons.star_border, color: Colors.amber, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  price,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  kw,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
