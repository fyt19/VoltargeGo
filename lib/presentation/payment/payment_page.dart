import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  String? _error;
  bool _showBack = false;
  bool _paymentSuccess = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();

  void _pay() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _paymentSuccess = true;
    });
  }

  String getCardBrand(String cardNumber) {
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('4')) return 'visa';
    if (RegExp(r'^5[1-5]').hasMatch(clean)) return 'mastercard';
    if (clean.startsWith('9')) return 'troy';
    if (RegExp(r'^3[47]').hasMatch(clean)) return 'amex';
    return 'default_card';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String brand = getCardBrand(_cardController.text);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Geri dönme işlevi
          },
          tooltip: 'Geri Dön',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 420,
                constraints: const BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: _paymentSuccess
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF4CAF50), size: 80),
                          const SizedBox(height: 24),
                          const Text('Ödeme Başarılı!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                          const SizedBox(height: 16),
                          const Text(
                              'Ödemeniz başarıyla tamamlandı. Şarj ekranına geçebilirsiniz.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black.withOpacity(0.2),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/charging');
                              },
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E3A8A),
                                      Color(0xFF2DD4BF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Şarj Ekranına Git',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Kart Bilgileri',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            transitionBuilder: (child, anim) =>
                                RotationYTransition(turns: anim, child: child),
                            child: _showBack
                                ? _buildCardBack()
                                : _buildCardFront(brand),
                          ),
                          const SizedBox(height: 24),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Ad Soyad',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2DD4BF), width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2DD4BF), width: 1.5),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Zorunlu alan'
                                      : null,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _cardController,
                                  decoration: InputDecoration(
                                    labelText: 'Kart Numarası',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2DD4BF), width: 1.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Color(0xFF2DD4BF), width: 1.5),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 19,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                    CardNumberInputFormatter(),
                                  ],
                                  validator: (v) => v == null ||
                                          v.replaceAll(' ', '').length < 16
                                      ? 'Geçersiz kart'
                                      : null,
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _expController,
                                        decoration: InputDecoration(
                                          labelText: 'AA/YY',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2DD4BF),
                                                width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2DD4BF),
                                                width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey[50],
                                        ),
                                        keyboardType: TextInputType.number,
                                        maxLength: 5,
                                        validator: (v) =>
                                            v == null || v.length < 5
                                                ? 'Geçersiz'
                                                : null,
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Focus(
                                        onFocusChange: (hasFocus) {
                                          setState(() {
                                            _showBack = hasFocus;
                                          });
                                        },
                                        child: TextFormField(
                                          controller: _cvvController,
                                          decoration: InputDecoration(
                                            labelText: 'CVV',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF2DD4BF),
                                                  width: 1.5),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFF2DD4BF),
                                                  width: 1.5),
                                            ),
                                            filled: true,
                                            fillColor: Colors.grey[50],
                                          ),
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                          validator: (v) =>
                                              v == null || v.length < 3
                                                  ? 'Geçersiz'
                                                  : null,
                                          onChanged: (_) => setState(() {}),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red[200]!),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black.withOpacity(0.2),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                padding: const EdgeInsets.all(0),
                              ),
                              onPressed: _isLoading ? null : _pay,
                              child: Ink(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF1E3A8A),
                                      Color(0xFF2DD4BF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Ödemeyi Tamamla',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ),
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

  Widget _buildCardFront(String brand) {
    return Container(
      key: const ValueKey('front'),
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF2DD4BF)
          ], // AppBar ile aynı gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('VOLTARGEGO',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              Image.asset(
                'assets/images/cards/$brand.png',
                width: 48,
                height: 32,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ],
          ),
          const Spacer(),
          Text(
              _nameController.text.isEmpty
                  ? 'AD SOYAD'
                  : _nameController.text.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
              _cardController.text.isEmpty
                  ? '•••• •••• •••• ••••'
                  : _cardController.text,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, letterSpacing: 2)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Exp: ', style: TextStyle(color: Colors.white70)),
              Text(_expController.text.isEmpty ? 'AA/YY' : _expController.text,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      key: const ValueKey('back'),
      width: 320,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF2DD4BF)
          ], // AppBar ile aynı gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 36,
            width: double.infinity,
            color: Colors.black38,
            margin: const EdgeInsets.only(bottom: 32),
          ),
          const Spacer(),
          Text(_cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}

class RotationYTransition extends AnimatedWidget {
  final Widget child;
  final Animation<double> turns;
  const RotationYTransition(
      {required this.child, required this.turns, super.key})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final double value = turns.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(value * 3.1416);
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: value < 0.5
          ? child
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1416),
              child: child,
            ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digitsOnly.length; i++) {
      buffer.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}


// import 'package:flutter/material.dart';

// class PaymentPage extends StatefulWidget {
//   const PaymentPage({super.key});

//   @override
//   State<PaymentPage> createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   bool _isLoading = false;
//   String? _error;
//   bool _showBack = false;
//   bool _paymentSuccess = false;
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _cardController = TextEditingController();
//   final _expController = TextEditingController();
//   final _cvvController = TextEditingController();

//   void _pay() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });
//     await Future.delayed(const Duration(seconds: 2));
//     setState(() {
//       _isLoading = false;
//       _paymentSuccess = true;
//     });
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _cardController.dispose();
//     _expController.dispose();
//     _cvvController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
//       appBar: AppBar(title: const Text('Ödeme')),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 420,
//                   constraints: const BoxConstraints(maxWidth: 500),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(28),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 24,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 24),
//                     child: _paymentSuccess
//                         ? Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(Icons.check_circle,
//                                   color: Color(0xFF4CAF50), size: 80),
//                               const SizedBox(height: 24),
//                               const Text('Ödeme Başarılı!',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 24)),
//                               const SizedBox(height: 16),
//                               const Text(
//                                   'Ödemeniz başarıyla tamamlandı. Şarj ekranına geçebilirsiniz.',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontSize: 16)),
//                               const SizedBox(height: 32),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 48,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF2176FF),
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(14)),
//                                     textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                     elevation: 0,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pushReplacementNamed(
//                                         context, '/charging');
//                                   },
//                                   child: const Text('Şarj Ekranına Git'),
//                                 ),
//                               ),
//                             ],
//                           )
//                         : Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text('Kart Bilgileri',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18)),
//                               const SizedBox(height: 18),
//                               AnimatedSwitcher(
//                                 duration: const Duration(milliseconds: 400),
//                                 transitionBuilder: (child, anim) =>
//                                     RotationYTransition(
//                                         turns: anim, child: child),
//                                 child: _showBack
//                                     ? _buildCardBack()
//                                     : _buildCardFront(),
//                               ),
//                               const SizedBox(height: 24),
//                               Form(
//                                 key: _formKey,
//                                 child: Column(
//                                   children: [
//                                     TextFormField(
//                                       controller: _nameController,
//                                       decoration: const InputDecoration(
//                                           labelText: 'Ad Soyad'),
//                                       validator: (v) => v == null || v.isEmpty
//                                           ? 'Zorunlu alan'
//                                           : null,
//                                       onChanged: (_) => setState(() {}),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     TextFormField(
//                                       controller: _cardController,
//                                       decoration: const InputDecoration(
//                                           labelText: 'Kart Numarası'),
//                                       keyboardType: TextInputType.number,
//                                       maxLength: 16,
//                                       validator: (v) =>
//                                           v == null || v.length < 16
//                                               ? 'Geçersiz kart'
//                                               : null,
//                                       onChanged: (_) => setState(() {}),
//                                     ),
//                                     const SizedBox(height: 12),
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: TextFormField(
//                                             controller: _expController,
//                                             decoration: const InputDecoration(
//                                                 labelText: 'AA/YY'),
//                                             keyboardType: TextInputType.number,
//                                             maxLength: 5,
//                                             validator: (v) =>
//                                                 v == null || v.length < 5
//                                                     ? 'Geçersiz'
//                                                     : null,
//                                             onChanged: (_) => setState(() {}),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 16),
//                                         Expanded(
//                                           child: Focus(
//                                             onFocusChange: (hasFocus) {
//                                               setState(() {
//                                                 _showBack = hasFocus;
//                                               });
//                                             },
//                                             child: TextFormField(
//                                               controller: _cvvController,
//                                               decoration: const InputDecoration(
//                                                   labelText: 'CVV'),
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               maxLength: 3,
//                                               validator: (v) =>
//                                                   v == null || v.length < 3
//                                                       ? 'Geçersiz'
//                                                       : null,
//                                               onChanged: (_) => setState(() {}),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (_error != null)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Text(_error!,
//                                       style:
//                                           const TextStyle(color: Colors.red)),
//                                 ),
//                               const SizedBox(height: 24),
//                               SizedBox(
//                                 width: double.infinity,
//                                 height: 48,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF2176FF),
//                                     foregroundColor: Colors.white,
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(14)),
//                                     textStyle: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                     elevation: 0,
//                                   ),
//                                   onPressed: _isLoading ? null : _pay,
//                                   child: _isLoading
//                                       ? const CircularProgressIndicator(
//                                           color: Colors.white)
//                                       : const Text('Ödemeyi Tamamla'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCardFront() {
//     return Container(
//       key: const ValueKey('front'),
//       width: 320,
//       height: 200,
//       decoration: BoxDecoration(
//         color: const Color(0xFF232B55),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.12),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('VOLTARGEGO',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18)),
//           const Spacer(),
//           Text(
//               _nameController.text.isEmpty
//                   ? 'AD SOYAD'
//                   : _nameController.text.toUpperCase(),
//               style: const TextStyle(color: Colors.white, fontSize: 16)),
//           const SizedBox(height: 8),
//           Text(
//               _cardController.text.isEmpty
//                   ? '•••• •••• •••• ••••'
//                   : _cardController.text,
//               style: const TextStyle(
//                   color: Colors.white, fontSize: 18, letterSpacing: 2)),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Text('Exp: ', style: TextStyle(color: Colors.white70)),
//               Text(_expController.text.isEmpty ? 'AA/YY' : _expController.text,
//                   style: const TextStyle(color: Colors.white)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCardBack() {
//     return Container(
//       key: const ValueKey('back'),
//       width: 320,
//       height: 200,
//       decoration: BoxDecoration(
//         color: const Color(0xFF232B55),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.12),
//             blurRadius: 16,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Container(
//             height: 36,
//             width: double.infinity,
//             color: Colors.black38,
//             margin: const EdgeInsets.only(bottom: 32),
//           ),
//           const Spacer(),
//           Text(_cvvController.text.isEmpty ? 'CVV' : _cvvController.text,
//               style: const TextStyle(color: Colors.white, fontSize: 18)),
//         ],
//       ),
//     );
//   }
// }

// class RotationYTransition extends AnimatedWidget {
//   final Widget child;
//   final Animation<double> turns;
//   const RotationYTransition(
//       {required this.child, required this.turns, super.key})
//       : super(listenable: turns);

//   @override
//   Widget build(BuildContext context) {
//     final double value = turns.value;
//     final Matrix4 transform = Matrix4.identity()
//       ..setEntry(3, 2, 0.001)
//       ..rotateY(value * 3.1416);
//     return Transform(
//       transform: transform,
//       alignment: Alignment.center,
//       child: value < 0.5
//           ? child
//           : Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationY(3.1416),
//               child: child,
//             ),
//     );
//   }
// }
