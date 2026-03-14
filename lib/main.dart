import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const AgeCalculatorScreen(),
    );
  }
}

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();

  DateTime? _dob;
  DateTime? _targetDate;

  int? _years;
  int? _months;
  int? _days;

  @override
  void initState() {
    super.initState();
    // Default specific date to today
    _targetDate = DateTime.now();
    _targetDateController.text = DateFormat('yyyy-MM-dd').format(_targetDate!);
  }

  @override
  void dispose() {
    _dobController.dispose();
    _targetDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isDob) async {
    final DateTime initialDate = isDob
        ? (_dob ?? DateTime.now())
        : (_targetDate ?? DateTime.now());
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
              primary: const Color(0xFF6C63FF),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDob) {
          _dob = picked;
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _targetDate = picked;
          _targetDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  void _calculateAge() {
    if (_dob == null || _targetDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates')),
      );
      return;
    }

    if (_dob!.isAfter(_targetDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Date of birth cannot be after the specific date')),
      );
      return;
    }

    int year = _targetDate!.year - _dob!.year;
    int month = _targetDate!.month - _dob!.month;
    int day = _targetDate!.day - _dob!.day;

    if (day < 0) {
      month--;
      int daysInLastMonth = DateTime(_targetDate!.year, _targetDate!.month, 0).day;
      day += daysInLastMonth;
    }

    if (month < 0) {
      year--;
      month += 12;
    }

    setState(() {
      _years = year;
      _months = month;
      _days = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3F4F6),
              Color(0xFFE5E7EB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cake_rounded,
                    size: 80,
                    color: Color(0xFF6C63FF),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select your date of birth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find out exactly how old you are on any given day.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildDateField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          icon: Icons.cake_outlined,
                          onTap: () => _selectDate(context, true),
                        ),
                        const SizedBox(height: 20),
                        _buildDateField(
                          controller: _targetDateController,
                          label: 'Specific Date',
                          icon: Icons.event_outlined,
                          onTap: () => _selectDate(context, false),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _calculateAge,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calculate_outlined),
                              SizedBox(width: 8),
                              Text(
                                'Calculate Age',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (_years != null) ...[
                    const Text(
                      'Your Age is',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AgeUnitWidget(value: '$_years', label: 'Years'),
                        const SizedBox(width: 16),
                        AgeUnitWidget(value: '$_months', label: 'Months'),
                        const SizedBox(width: 16),
                        AgeUnitWidget(value: '$_days', label: 'Days'),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class AgeUnitWidget extends StatelessWidget {
  final String value;
  final String label;

  const AgeUnitWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C63FF),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
              textBaseline: TextBaseline.alphabetic,
            ),
          ),
        ],
      ),
    );
  }
}