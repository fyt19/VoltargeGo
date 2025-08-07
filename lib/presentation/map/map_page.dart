import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, color: Colors.white), // Map pin icon
            SizedBox(width: 8), // Space between icon and text
            Text('VoltargeGo', style: TextStyle(color: Colors.white)),
          ],
        ),
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
        automaticallyImplyLeading: true, // Hamburger menü butonunu kaldırır
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/mappage.png'),
            fit: BoxFit.cover, // Görseli tam ekran kaplayacak şekilde ayarlar
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context); // Geri dönme işlevi
        },
        backgroundColor: Color(0xFF1E3A8A), // AppBar ile uyumlu renk
        child: Icon(Icons.arrow_back, color: Colors.white),
        tooltip: 'Geri Dön', // Butonun üzerine gelindiğinde gösterilecek ipucu
      ),
    );
  }
}
