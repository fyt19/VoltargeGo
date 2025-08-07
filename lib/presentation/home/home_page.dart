import 'package:flutter/material.dart';
import 'package:voltargego_flutter/core/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await SupabaseService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getInitials() {
    if (_userProfile == null) return 'K';

    final firstName = _userProfile!['first_name'] ?? '';
    final lastName = _userProfile!['last_name'] ?? '';

    if (firstName.isEmpty && lastName.isEmpty) return 'K';

    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';

    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 50, // AppBar yüksekliğini azalttık
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, color: Colors.white), // Map pin icon
            SizedBox(width: 8), // Space between icon and text
            Text(
              'VoltargeGo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300, // Daha ince font
                fontSize: 20, // Biraz daha küçük font boyutu
                letterSpacing: 1.2, // Harfler arası boşluk
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00133D), // Koyu lacivert (sol taraf gibi)
                Color(0xFF00D9D9), // Canlı turkuaz (sağ taraf gibi)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        automaticallyImplyLeading:
            false, // Bu satır hamburger menü butonunu kaldırır
      ),
      drawer: _buildSidebar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (!isSearchVisible) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: _isLoading
                            ? const CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey,
                                child: CircularProgressIndicator(),
                              )
                            : _userProfile?['avatar_url'] != null &&
                                    _userProfile!['avatar_url'].isNotEmpty
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                        _userProfile!['avatar_url']),
                                    onBackgroundImageError:
                                        (exception, stackTrace) {
                                      // Hata durumunda default avatar göster
                                      setState(() {
                                        _userProfile!['avatar_url'] = '';
                                      });
                                    },
                                  )
                                : CircleAvatar(
                                    radius: 24,
                                    backgroundColor: const Color(0xFF00D9D9),
                                    child: Text(
                                      _getInitials(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLoading
                                ? 'Yükleniyor...'
                                : '${_userProfile?['first_name'] ?? 'Kullanıcı'} ${_userProfile?['last_name'] ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Puan: ${_userProfile?['points'] ?? 0}'),
                        ],
                      ),
                      const Spacer(),
                    ],
                    if (isSearchVisible)
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          isSearchVisible = !isSearchVisible;
                        });
                      },
                    ),
                    if (!isSearchVisible)
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/slider.jpeg',
                    width: 200, // İstediğin boyuta göre değiştir
                    height: 80,
                  ),
                  const SizedBox(width: 2), // Görsel ile yazı arasında boşluk
                  const Expanded(
                    child: Text(
                      'Elektrikli Araç Şarj İstasyonu mu Arıyorsunuz?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Center(child: Text('Nasıl devam etmek istersiniz?')),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/map'),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0A1A44),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF2DD4BF).withOpacity(0.85),
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 255, 255),
                                      Color(0xFF2DD4BF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            width: 110,
                            child: Text(
                              'Şarj istasyonlarını Harita halinde görüntüle.',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF0A1A44),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/list'),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF0A1A44),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF2DD4BF).withOpacity(0.85),
                                  blurRadius: 4,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 255, 255, 255),
                                      Color(0xFF2DD4BF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds);
                                },
                                child: const Icon(
                                  Icons.format_list_bulleted,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const SizedBox(
                            width: 110,
                            child: Text(
                              'Şarj istasyonlarını Listede gör.\n',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF0A1A44),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    color: Colors.white,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Son Kiralamalar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _rentalCard(
                      status: true,
                      date: '03/27/2024',
                      name: 'Elif Y',
                      rating: 2,
                      price: '€0.75 / Hour',
                      kw: '22 kW',
                      buttonText: 'Tekrar Kirala',
                      onPressed: () {
                        Navigator.pushNamed(context, '/reservation');
                      },
                    ),
                    _rentalCard(
                      status: false,
                      date: '06/01/2023',
                      name: 'Ethan J',
                      rating: 4,
                      price: '€0.50 / Hour',
                      kw: '22 kW',
                      buttonText: 'Görüntüle',
                      onPressed: () {
                        Navigator.pushNamed(context, '/last_rentals');
                      },
                    ),
                    _rentalCard(
                      status: false,
                      date: '02/17/2023',
                      name: 'Sophia W',
                      rating: 4,
                      price: '€0.50 / Hour',
                      kw: '22 kW',
                      buttonText: 'Görüntüle',
                      onPressed: () {
                        Navigator.pushNamed(context, '/last_rentals');
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Öneriler',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _rentalCard(
                      status: true,
                      date: '08/28/2024',
                      name: 'İrem T',
                      rating: 3,
                      price: '€1.25 / Hour',
                      kw: '22 kW',
                      buttonText: 'Rezervasyolar',
                      onPressed: () {
                        Navigator.pushNamed(context, '/last_rentals');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2DD4BF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.electric_car,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'VoltargeGo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildSidebarItem(
              context,
              icon: Icons.map_outlined,
              title: 'Harita Sayfası',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/map');
              },
            ),
            _buildSidebarItem(
              context,
              icon: Icons.format_list_bulleted,
              title: 'Listeleme Sayfası',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/list');
              },
            ),
            _buildSidebarItem(
              context,
              icon: Icons.history,
              title: 'Son Kiralamalar',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/recent_rentals');
              },
            ),
            const Spacer(),
            // Kullanıcı Profili
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _userProfile?['avatar_url'] != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(_userProfile!['avatar_url']),
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xFF00D9D9),
                          child: Text(
                            _getInitials(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_userProfile?['first_name'] ?? 'Kullanıcı'} ${_userProfile?['last_name'] ?? ''}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Puan: ${_userProfile?['points'] ?? 0}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Çıkış Yap Butonu
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await SupabaseService.signOut();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('is_logged_in');
                    await prefs.remove('user_id');
                    await prefs.remove('user_email');

                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/welcome',
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Çıkış Yap',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}

Widget _rentalCard({
  required bool status,
  required String date,
  required String name,
  required int rating,
  required String price,
  required String kw,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: SizedBox(
      width: 160,
      height: 110,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1A44),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  Icon(
                    status ? Icons.check_circle : Icons.cancel,
                    color: status ? const Color(0xFFB9FF4B) : Colors.red,
                    size: 18,
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: Row(
                children: [
                  for (int i = 0; i < rating; i++)
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                  for (int i = rating; i < 5; i++)
                    const Icon(Icons.star_border,
                        color: Colors.amber, size: 14),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(price,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  const Spacer(),
                  Text(kw,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 26,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.15),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   bool isSearchVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.map, color: Colors.white),
//             SizedBox(width: 8),
//             Text('VoltargeGo', style: TextStyle(color: Colors.white)),
//           ],
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF1E3A8A), Color(0xFF2DD4BF)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Color(0xFF1E3A8A), Color(0xFF2DD4BF)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'VoltargeGo',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Navigation',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.map_outlined),
//               title: const Text('Map'),
//               subtitle: const Text('View charging stations on map'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/map');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.format_list_bulleted),
//               title: const Text('List'),
//               subtitle: const Text('View charging stations in list format'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/list');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.history),
//               title: const Text('Last Rentals'),
//               subtitle: const Text('View your recent charging history'),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushNamed(context, '/last_rentals');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     if (!isSearchVisible) ...[
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushNamed(context, '/profile');
//                         },
//                         child: const CircleAvatar(
//                           radius: 24,
//                           backgroundImage:
//                               AssetImage('assets/images/evamia.jpg'),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Eva Mia',
//                               style: TextStyle(fontWeight: FontWeight.bold)),
//                           Text('Point: 6596'),
//                         ],
//                       ),
//                       const Spacer(),
//                     ],
//                     if (isSearchVisible)
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search...',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                     IconButton(
//                       icon: const Icon(Icons.search),
//                       onPressed: () {
//                         setState(() {
//                           isSearchVisible = !isSearchVisible;
//                         });
//                       },
//                     ),
//                     if (!isSearchVisible)
//                       Builder(
//                         builder: (context) => IconButton(
//                           icon: const Icon(Icons.menu),
//                           onPressed: () {
//                             Scaffold.of(context).openDrawer();
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/images/slider.jpeg',
//                     width: 200,
//                     height: 80,
//                   ),
//                   const SizedBox(width: 2),
//                   const Expanded(
//                     child: Text(
//                       'Looking for an Electric Vehicle Charging Station?',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//               const Center(child: Text('How Would you like to continue')),
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pushNamed(context, '/map'),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: const Color(0xFF0A1A44),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color:
//                                       const Color(0xFF2DD4BF).withOpacity(0.85),
//                                   blurRadius: 4,
//                                   spreadRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: ShaderMask(
//                                 shaderCallback: (Rect bounds) {
//                                   return const LinearGradient(
//                                     colors: [
//                                       Color.fromARGB(255, 255, 255, 255),
//                                       Color(0xFF2DD4BF)
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ).createShader(bounds);
//                                 },
//                                 child: const Icon(
//                                   Icons.map_outlined,
//                                   size: 48,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           const SizedBox(
//                             width: 110,
//                             child: Text(
//                               'Click to view the charging stations on a map.',
//                               textAlign: TextAlign.center,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Color(0xFF0A1A44),
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12,
//                                 height: 1.2,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.white,
//                                     blurRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 24),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () => Navigator.pushNamed(context, '/list'),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: const Color(0xFF0A1A44),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color:
//                                       const Color(0xFF2DD4BF).withOpacity(0.85),
//                                   blurRadius: 4,
//                                   spreadRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: Center(
//                               child: ShaderMask(
//                                 shaderCallback: (Rect bounds) {
//                                   return const LinearGradient(
//                                     colors: [
//                                       Color.fromARGB(255, 255, 255, 255),
//                                       Color(0xFF2DD4BF)
//                                     ],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ).createShader(bounds);
//                                 },
//                                 child: const Icon(
//                                   Icons.format_list_bulleted,
//                                   size: 48,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           const SizedBox(
//                             width: 110,
//                             child: Text(
//                               'Click to view the charging stations in a list format.',
//                               textAlign: TextAlign.center,
//                               maxLines: 3,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Color(0xFF0A1A44),
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 12,
//                                 height: 1.2,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.white,
//                                     blurRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Last rentals',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               SizedBox(
//                 height: 120,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _rentalCard(
//                       status: true,
//                       date: '03/27/2024',
//                       name: 'Elif Y',
//                       rating: 2,
//                       price: '€0.75 / Hour',
//                       kw: '22 kW',
//                       buttonText: 'Rent Again',
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/reservation');
//                       },
//                     ),
//                     _rentalCard(
//                       status: false,
//                       date: '06/01/2023',
//                       name: 'Ethan J',
//                       rating: 4,
//                       price: '€0.50 / Hour',
//                       kw: '22 kW',
//                       buttonText: 'Görüntüle',
//                       onPressed: () {},
//                     ),
//                     _rentalCard(
//                       status: false,
//                       date: '02/17/2023',
//                       name: 'Sophia W',
//                       rating: 4,
//                       price: '€0.50 / Hour',
//                       kw: '22 kW',
//                       buttonText: 'Görüntüle',
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Recommendations',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               SizedBox(
//                 height: 120,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _rentalCard(
//                       status: true,
//                       date: '08/28/2024',
//                       name: 'İrem T',
//                       rating: 3,
//                       price: '€1.25 / Hour',
//                       kw: '22 kW',
//                       buttonText: 'Book',
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/reservation');
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _rentalCard({
//     required bool status,
//     required String date,
//     required String name,
//     required int rating,
//     required String price,
//     required String kw,
//     required String buttonText,
//     required VoidCallback onPressed,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 12),
//       child: SizedBox(
//         width: 160,
//         height: 110,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF0A1A44),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 child: Row(
//                   children: [
//                     Icon(
//                       status ? Icons.check_circle : Icons.cancel,
//                       color: status ? const Color(0xFFB9FF4B) : Colors.red,
//                       size: 18,
//                     ),
//                     const Spacer(),
//                     Text(
//                       date,
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
//                 child: Row(
//                   children: [
//                     for (int i = 0; i < rating; i++)
//                       const Icon(Icons.star, color: Colors.amber, size: 14),
//                     for (int i = rating; i < 5; i++)
//                       const Icon(Icons.star_border,
//                           color: Colors.amber, size: 14),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Row(
//                   children: [
//                     Text(price,
//                         style: const TextStyle(
//                             color: Colors.white70, fontSize: 12)),
//                     const Spacer(),
//                     Text(kw,
//                         style: const TextStyle(
//                             color: Colors.white70, fontSize: 12)),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 26,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white.withOpacity(0.15),
//                       foregroundColor: Colors.white,
//                       textStyle: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 13),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                       elevation: 0,
//                       padding: EdgeInsets.zero,
//                     ),
//                     onPressed: onPressed,
//                     child: Text(buttonText),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



