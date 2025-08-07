import 'package:flutter/material.dart';
import 'package:voltargego_flutter/core/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // User info
  String name = 'Kullanıcı';
  String email = '';
  String phone = '';
  bool editingInfo = false;
  bool showSave = false;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Notification settings
  bool pushNotif = true;
  bool emailNotif = false;

  // Language
  String language = 'Türkçe';

  // Add station
  bool showAddStation = false;
  final _stationFormKey = GlobalKey<FormState>();
  String stationName = '';
  String tck = '';
  String address = '';
  String stationType = 'AC';
  String stationMode = 'Paylaşımlı';
  String kw = '';
  String price = '';

  // Delete account
  bool showDeleteDialog = false;

  void _onAnyChanged() {
    setState(() {
      showSave = true;
    });
  }

  Future<void> _save() async {
    try {
      // Profil fotoğrafı varsa yükle
      String? avatarUrl;
      if (_selectedImage != null) {
        avatarUrl =
            await SupabaseService.uploadProfileImage(_selectedImage!.path);
      }

      // Profil bilgilerini güncelle
      final nameParts = name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await SupabaseService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        avatarUrl: avatarUrl,
      );

      setState(() {
        editingInfo = false;
        showSave = false;
        showAddStation = false;
        _selectedImage = null;
      });

      // Profil bilgilerini yeniden yükle
      await _loadUserProfile();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Değişiklikler kaydedildi.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
        name =
            '${profile?['first_name'] ?? 'Kullanıcı'} ${profile?['last_name'] ?? ''}';
        email = profile?['email'] ?? '';
        phone = profile?['phone'] ?? '';
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

  // Profil fotoğrafı seç
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        print('📸 Seçilen dosya yolu: ${image.path}');
        final file = File(image.path);
        
        if (await file.exists()) {
          print('✅ Dosya mevcut, boyut: ${await file.length()} bytes');
          setState(() {
            _selectedImage = file;
            showSave = true;
          });
        } else {
          print('❌ Dosya bulunamadı: ${image.path}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dosya bulunamadı. Lütfen tekrar deneyin.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Fotoğraf seçme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fotoğraf seçme hatası: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancel() {
    setState(() {
      editingInfo = false;
      showSave = false;
      showAddStation = false;
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFF1E3A8A), Color(0xFF2DD4BF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    const accentBlue = Color(0xFF1E3A8A);
    const accentTeal = Color(0xFF2DD4BF);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Ayarları'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: gradient),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: gradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _userProfile?['avatar_url'] != null
                        ? CircleAvatar(
                            radius: 32,
                            backgroundImage:
                                NetworkImage(_userProfile!['avatar_url']),
                          )
                        : CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFF00D9D9),
                            child: Text(
                              _getInitials(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white)),
                        const Text('Kullanıcı',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Personal info
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kişisel Bilgiler',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accentBlue)),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                editingInfo = true;
                                showSave = true;
                              });
                            },
                            child: const Text('Düzenle'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      editingInfo
                          ? Column(
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                      labelText: 'Ad Soyad'),
                                  controller: TextEditingController(text: name),
                                  onChanged: (v) {
                                    name = v;
                                    _onAnyChanged();
                                  },
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      labelText: 'E-posta'),
                                  controller:
                                      TextEditingController(text: email),
                                  onChanged: (v) {
                                    email = v;
                                    _onAnyChanged();
                                  },
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                      labelText: 'Telefon'),
                                  controller:
                                      TextEditingController(text: phone),
                                  onChanged: (v) {
                                    phone = v;
                                    _onAnyChanged();
                                  },
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ad Soyad: $name',
                                    style: const TextStyle(color: accentBlue)),
                                Text('E-posta: $email',
                                    style: const TextStyle(color: accentBlue)),
                                Text('Telefon: $phone',
                                    style: const TextStyle(color: accentBlue)),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password change
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.lock_outline, color: accentBlue),
                  title: const Text('Şifre Değiştir',
                      style: TextStyle(color: accentBlue)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Şifre Değiştir'),
                        content: const Text(
                            'Şifre değiştirme akışı burada olacak (fake).'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Kapat')),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Notification settings
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bildirim Ayarları',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: accentBlue)),
                      SwitchListTile(
                        title: const Text('Push Bildirimleri'),
                        value: pushNotif,
                        activeColor: accentTeal,
                        onChanged: (v) {
                          setState(() {
                            pushNotif = v;
                            showSave = true;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('E-posta Bildirimleri'),
                        value: emailNotif,
                        activeColor: accentTeal,
                        onChanged: (v) {
                          setState(() {
                            emailNotif = v;
                            showSave = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Language
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dil Seçimi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: accentBlue)),
                      DropdownButton<String>(
                        value: language,
                        items: const [
                          DropdownMenuItem(
                              value: 'Türkçe', child: Text('Türkçe')),
                        ],
                        onChanged: (v) {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Add station
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Şarj İstasyonu Ekle',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: accentBlue)),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                showAddStation = !showAddStation;
                                showSave = true;
                              });
                            },
                            child: Text(showAddStation ? 'Kapat' : 'Ekle'),
                          ),
                        ],
                      ),
                      if (showAddStation)
                        Form(
                          key: _stationFormKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Ad Soyad'),
                                onChanged: (v) {
                                  stationName = v;
                                  _onAnyChanged();
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'TCK'),
                                onChanged: (v) {
                                  tck = v;
                                  _onAnyChanged();
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Adres'),
                                onChanged: (v) {
                                  address = v;
                                  _onAnyChanged();
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: stationType,
                                      decoration: const InputDecoration(
                                          labelText: 'Tip'),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'AC', child: Text('AC')),
                                        DropdownMenuItem(
                                            value: 'DC', child: Text('DC')),
                                      ],
                                      onChanged: (v) {
                                        stationType = v!;
                                        _onAnyChanged();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: stationMode,
                                      decoration: const InputDecoration(
                                          labelText: 'Mod'),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'Paylaşımlı',
                                            child: Text('Paylaşımlı')),
                                        DropdownMenuItem(
                                            value: 'Ticari',
                                            child: Text('Ticari')),
                                      ],
                                      onChanged: (v) {
                                        stationMode = v!;
                                        _onAnyChanged();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'kW'),
                                onChanged: (v) {
                                  kw = v;
                                  _onAnyChanged();
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Saatlik Ücret'),
                                onChanged: (v) {
                                  price = v;
                                  _onAnyChanged();
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Delete account
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  onPressed: () {
                    setState(() {
                      showDeleteDialog = true;
                    });
                  },
                  child: const Text('Hesabı Sil'),
                ),
              ),
              if (showSave)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _save,
                          child: const Text('Kaydet'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accentBlue,
                            side: const BorderSide(color: accentBlue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _cancel,
                          child: const Text('İptal'),
                        ),
                      ),
                    ],
                  ),
                ),
              if (showDeleteDialog)
                AlertDialog(
                  title: const Text('Hesabı Sil'),
                  content: const Text(
                      'Hesabınızı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showDeleteDialog = false;
                        });
                      },
                      child: const Text('Vazgeç'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        setState(() {
                          showDeleteDialog = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Hesabınız silindi (fake).')));
                      },
                      child: const Text('Evet, Sil'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
