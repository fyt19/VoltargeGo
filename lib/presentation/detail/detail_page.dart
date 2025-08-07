import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    const bool available = true;
    const String avatar = 'assets/images/pp.png';
    const String name = 'Lucas S';
    // const double rating = 4.0;
    const String price = '€0.50';
    const String kw = '22 kW';
    const String type = 'Shared';
    const String power = 'AC';
    const List<String> gallery = [
      'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    ];
    const String mapImage =
        'https://i.ibb.co/6bR8Q7d/mock-map.png'; // Placeholder map image

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile row
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage(avatar),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Row(
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 16),
                                      const Icon(Icons.star_border,
                                          color: Colors.amber, size: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle,
                                color:
                                    available ? Color(0xFFB9FF4B) : Colors.grey,
                                size: 32),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Price row
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.attach_money,
                                  color: Colors.blueGrey, size: 20),
                              SizedBox(width: 6),
                              Text(price,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(width: 18),
                              Icon(Icons.flash_on,
                                  color: Colors.blueGrey, size: 20),
                              SizedBox(width: 6),
                              Text(kw, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Type row
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: type == 'Shared'
                                      ? const Color(0xFFE8E6FF)
                                      : const Color(0xFFF3F2FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.people,
                                        color: type == 'Shared'
                                            ? Colors.deepPurple
                                            : Colors.grey,
                                        size: 18),
                                    SizedBox(width: 4),
                                    Text(type,
                                        style: TextStyle(
                                            color: type == 'Shared'
                                                ? Colors.deepPurple
                                                : Colors.grey,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: power == 'AC'
                                      ? const Color(0xFFF3F2FF)
                                      : const Color(0xFFFFF2F2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: power == 'AC'
                                        ? const Color(0xFF6C63FF)
                                        : const Color(0xFFFF5C5C),
                                  ),
                                ),
                                child: const Text(power,
                                    style: TextStyle(
                                        color: power == 'AC'
                                            ? Color(0xFF6C63FF)
                                            : Color(0xFFFF5C5C),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Gallery
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: gallery.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(gallery[i],
                                  width: 140, height: 120, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Map
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            mapImage,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Book button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2176FF),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                              elevation: 0,
                            ),
                            onPressed: available ? () {} : null,
                            child: const Text('BOOK'),
                          ),
                        ),
                      ],
                    ),
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
