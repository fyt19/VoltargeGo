import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _pickupTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _returnTime = const TimeOfDay(hour: 10, minute: 0);
  String? _error;

  void _submit() {
    if (_returnTime.hour < _pickupTime.hour ||
        (_returnTime.hour == _pickupTime.hour &&
            _returnTime.minute <= _pickupTime.minute)) {
      setState(
          () => _error = 'Dönüş saati, teslim alma saatinden sonra olmalı.');
      return;
    }
    setState(() => _error = null);
    // TODO: API ile rezervasyon kaydı
    Navigator.pushNamed(context, '/payment');
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Modal drag bar
                        Container(
                          width: 48,
                          height: 6,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        // Calendar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: CalendarDatePicker(
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                            onDateChanged: (date) =>
                                setState(() => _selectedDate = date),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Teslim Alma Saati',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _timeDropdown(
                                        _pickupTime.hour,
                                        0,
                                        23,
                                        (v) => setState(() => _pickupTime =
                                            TimeOfDay(
                                                hour: v!,
                                                minute: _pickupTime.minute))),
                                    const Text(' : ',
                                        style: TextStyle(fontSize: 16)),
                                    _timeDropdown(
                                        _pickupTime.minute,
                                        0,
                                        59,
                                        (v) => setState(() => _pickupTime =
                                            TimeOfDay(
                                                hour: _pickupTime.hour,
                                                minute: v!)),
                                        step: 5),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Dönüş Saati',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _timeDropdown(
                                        _returnTime.hour,
                                        0,
                                        23,
                                        (v) => setState(() => _returnTime =
                                            TimeOfDay(
                                                hour: v!,
                                                minute: _returnTime.minute))),
                                    const Text(' : ',
                                        style: TextStyle(fontSize: 16)),
                                    _timeDropdown(
                                        _returnTime.minute,
                                        0,
                                        59,
                                        (v) => setState(() => _returnTime =
                                            TimeOfDay(
                                                hour: _returnTime.hour,
                                                minute: v!)),
                                        step: 5),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
                              padding: const EdgeInsets.all(
                                  0), // Gradient için padding sıfırlanır
                            ),
                            onPressed: _submit,
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF1E3A8A),
                                    Color(0xFF2DD4BF)
                                  ], // AppBar ile aynı gradient
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeDropdown(
      int value, int min, int max, ValueChanged<int?> onChanged,
      {int step = 1}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2DD4BF), width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: DropdownButton<int>(
        value: value,
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87),
        items: [
          for (int i = min; i <= max; i += step)
            DropdownMenuItem(
              value: i,
              child: Text(i.toString().padLeft(2, '0')),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class ReservationPage extends StatefulWidget {
//   const ReservationPage({super.key});

//   @override
//   State<ReservationPage> createState() => _ReservationPageState();
// }

// class _ReservationPageState extends State<ReservationPage> {
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _pickupTime = const TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _returnTime = const TimeOfDay(hour: 10, minute: 0);
//   String? _error;

//   void _submit() {
//     if (_returnTime.hour < _pickupTime.hour ||
//         (_returnTime.hour == _pickupTime.hour &&
//             _returnTime.minute <= _pickupTime.minute)) {
//       setState(
//           () => _error = 'Dönüş saati, teslim alma saatinden sonra olmalı.');
//       return;
//     }
//     setState(() => _error = null);
//     // TODO: API ile rezervasyon kaydı
//     Navigator.pushNamed(context, '/payment');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FB),
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
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // Modal drag bar
//                         Container(
//                           width: 48,
//                           height: 6,
//                           margin: const EdgeInsets.only(bottom: 18),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(3),
//                           ),
//                         ),
//                         // Calendar
//                         CalendarDatePicker(
//                           initialDate: _selectedDate,
//                           firstDate: DateTime.now(),
//                           lastDate:
//                               DateTime.now().add(const Duration(days: 365)),
//                           onDateChanged: (date) =>
//                               setState(() => _selectedDate = date),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Column(
//                               children: [
//                                 const Text('Pickup Time',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 Row(
//                                   children: [
//                                     _timeDropdown(
//                                         _pickupTime.hour,
//                                         0,
//                                         23,
//                                         (v) => setState(() => _pickupTime =
//                                             TimeOfDay(
//                                                 hour: v!,
//                                                 minute: _pickupTime.minute))),
//                                     const Text(' : '),
//                                     _timeDropdown(
//                                         _pickupTime.minute,
//                                         0,
//                                         59,
//                                         (v) => setState(() => _pickupTime =
//                                             TimeOfDay(
//                                                 hour: _pickupTime.hour,
//                                                 minute: v!)),
//                                         step: 1),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: [
//                                 const Text('Return Time',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 Row(
//                                   children: [
//                                     _timeDropdown(
//                                         _returnTime.hour,
//                                         0,
//                                         23,
//                                         (v) => setState(() => _returnTime =
//                                             TimeOfDay(
//                                                 hour: v!,
//                                                 minute: _returnTime.minute))),
//                                     const Text(' : '),
//                                     _timeDropdown(
//                                         _returnTime.minute,
//                                         0,
//                                         59,
//                                         (v) => setState(() => _returnTime =
//                                             TimeOfDay(
//                                                 hour: _returnTime.hour,
//                                                 minute: v!)),
//                                         step: 1),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         if (_error != null)
//                           Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(_error!,
//                                 style: const TextStyle(color: Colors.red)),
//                           ),
//                         const SizedBox(height: 24),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 48,
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xFF2176FF),
//                               foregroundColor: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14)),
//                               textStyle: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 18),
//                               elevation: 0,
//                             ),
//                             onPressed: _submit,
//                             child: const Text('Ödemeyi Tamamla'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _timeDropdown(
//       int value, int min, int max, ValueChanged<int?> onChanged,
//       {int step = 1}) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFF00BFA6), width: 1.2),
//         borderRadius: BorderRadius.circular(6),
//         color: Colors.grey[50],
//       ),
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       padding: const EdgeInsets.symmetric(horizontal: 4),
//       child: DropdownButton<int>(
//         value: value,
//         underline: const SizedBox(),
//         isDense: true,
//         style: const TextStyle(
//             fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
//         items: [
//           for (int i = min; i <= max; i += step)
//             DropdownMenuItem(
//               value: i,
//               child: Text(i.toString().padLeft(2, '0')),
//             ),
//         ],
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
