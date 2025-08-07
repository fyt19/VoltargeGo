import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int? expandedIndex;

  final stations = [
    {
      'name': 'Lucas S',
      'avatar': 'assets/images/lucass.jpg',
      'price': '€0.50',
      'kw': '22 kW',
      'type': 'Shared',
      'power': 'AC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage':
          'assets/images/pp.png', // Use local asset instead of broken link
    },
    {
      'name': 'EVGO',
      'avatar': null,
      'price': '€1.50',
      'kw': '120 kW',
      'type': 'Commercial',
      'power': 'DC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Zeynep D',
      'avatar': 'assets/images/zeynepd.jpg',
      'price': '€0.75',
      'kw': '11 kW',
      'type': 'Shared',
      'power': 'AC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Eva Mia',
      'avatar': 'assets/images/evamia.jpg',
      'price': '€0.75',
      'kw': '11 kW',
      'type': 'Shared',
      'power': 'AC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Chargepoint',
      'avatar': null,
      'price': '€1.25',
      'kw': '180 kW',
      'type': 'Commercial',
      'power': 'DC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Emre K',
      'avatar': 'assets/images/lucass.jpg',
      'price': '€0.75',
      'kw': '7.4 kW',
      'type': 'Shared',
      'power': 'AC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Enel X',
      'avatar': 'assets/images/ex.png',
      'price': '€1.25',
      'kw': '250 kW',
      'type': 'Commercial',
      'power': 'DC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
    {
      'name': 'Amelia B',
      'avatar': 'assets/images/jaled.jpg',
      'price': '€1.50',
      'kw': '120 kW',
      'type': 'Shared',
      'power': 'AC',
      'rating': 4.0,
      'available': true,
      'gallery': [
        'https://images.unsplash.com/photo-1511391403515-ecfdc9b3c9b7',
        'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      ],
      'mapImage': 'assets/images/pp.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Listeleme',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF2DD4BF)
              ], // Dark blue to teal gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.filter_list, color: Colors.blue),
                          onPressed: () {},
                        ),
                        const Expanded(
                          child: Text('Filter',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.sort, color: Colors.blue),
                          onPressed: () {},
                        ),
                        const Expanded(
                          child: Text('Sort',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: stations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final station = stations[index];
                final isExpanded = expandedIndex == index;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isExpanded
                      ? _buildExpandedCard(context, station, index)
                      : _buildCollapsedCard(context, station, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedCard(
      BuildContext context, Map<String, dynamic> station, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expandedIndex = index;
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              (station['avatar'] as String?) != null
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(station['avatar'] as String),
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[200],
                      child:
                          const Icon(Icons.ev_station, color: Colors.black38),
                    ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          station['name'] as String,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(station['price'] as String,
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Text(station['kw'] as String,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (station['type'] as String) == 'Shared'
                                ? const Color(0xFFE8F0FE)
                                : const Color(0xFFF3F2FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            station['type'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: (station['type'] as String) == 'Shared'
                                  ? Colors.blue
                                  : Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (station['power'] as String) == 'AC'
                                ? const Color(0xFFF3F2FF)
                                : const Color(0xFFFFF2F2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (station['power'] as String) == 'AC'
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFFF5C5C),
                            ),
                          ),
                          child: Text(
                            station['power'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: (station['power'] as String) == 'AC'
                                  ? const Color(0xFF6C63FF)
                                  : const Color(0xFFFF5C5C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle,
                      color: (station['available'] as bool)
                          ? const Color(0xFFB9FF4B)
                          : Colors.grey,
                      size: 28),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (int i = 0; i < 4; i++)
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Icon(Icons.star_half,
                          color: Colors.amber, size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedCard(
      BuildContext context, Map<String, dynamic> station, int index) {
    final bool available = station['available'] as bool;
    final String avatar = station['avatar'] as String? ?? '';
    final String name = station['name'] as String;
    // final double rating = station['rating'] as double;
    final String price = station['price'] as String;
    final String kw = station['kw'] as String;
    final String type = station['type'] as String;
    final String power = station['power'] as String;
    final List<String> gallery = List<String>.from(station['gallery'] as List);
    // final String mapImage = station['mapImage'] as String;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile row
            Row(
              children: [
                avatar.isNotEmpty
                    ? CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(avatar),
                      )
                    : CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[200],
                        child:
                            const Icon(Icons.ev_station, color: Colors.black38),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
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
                Icon(Icons.check_circle,
                    color: available ? const Color(0xFFB9FF4B) : Colors.grey,
                    size: 32),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // Klavye odağını kaldır
                    setState(() {
                      expandedIndex = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_money,
                      color: Colors.blueGrey, size: 20),
                  const SizedBox(width: 6),
                  Text(price,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(width: 18),
                  const Icon(Icons.flash_on, color: Colors.blueGrey, size: 20),
                  const SizedBox(width: 6),
                  Text(kw, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Type row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: type == 'Shared'
                          ? const Color(0xFFE8E6FF)
                          : const Color(0xFFF3F2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.people,
                            color: type == 'Shared'
                                ? Colors.deepPurple
                                : Colors.grey,
                            size: 18),
                        const SizedBox(width: 4),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    child: Text(power,
                        style: TextStyle(
                            color: power == 'AC'
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFFFF5C5C),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Gallery
            Row(
              children: [
                for (int i = 0; i < 2 && i < gallery.length; i++)
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: EdgeInsets.only(left: i == 1 ? 8 : 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            gallery[i],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image,
                                  size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Map
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, color: Colors.blueGrey, size: 48),
                    SizedBox(height: 8),
                    Text('Harita Görünümü',
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  ],
                ),
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
                onPressed: available
                    ? () {
                        Navigator.pushNamed(context, '/reservation');
                      }
                    : null,
                child: const Text('İşleme Devam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
