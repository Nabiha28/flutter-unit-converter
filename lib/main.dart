import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

/// The root widget of the Unit Converter application.
class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const UnitConverterPage(),
    );
  }
}

/// Displays the unit conversion interface and manages user input.
class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final TextEditingController _valueController = TextEditingController();

  String _fromUnit = 'Miles';
  String _toUnit = 'Kilometers';
  String _result = '';

  final List<String> _units = [
    'Miles',
    'Kilometers',
    'Feet',
    'Meters',
    'Pounds',
    'Kilograms',
    'Fahrenheit',
    'Celsius',
  ];

  /// Performs the selected unit conversion.
  void _convert() {
    final input = double.tryParse(_valueController.text.trim());

    if (input == null) {
      setState(() {
        _result = 'Please enter a valid number.';
      });
      return;
    }

    double convertedValue;

    if (_fromUnit == _toUnit) {
      convertedValue = input;
    } else {
      convertedValue = _convertValue(input, _fromUnit, _toUnit);
    }

    setState(() {
      _result =
          '${_formatNumber(input)} $_fromUnit = '
          '${_formatNumber(convertedValue)} $_toUnit';
    });
  }

  /// Returns the converted value based on the selected units.
  double _convertValue(double value, String from, String to) {
    // Distance conversions.
    if (from == 'Miles' && to == 'Kilometers') {
      return value * 1.60934;
    }
    if (from == 'Kilometers' && to == 'Miles') {
      return value / 1.60934;
    }
    if (from == 'Feet' && to == 'Meters') {
      return value * 0.3048;
    }
    if (from == 'Meters' && to == 'Feet') {
      return value / 0.3048;
    }

    // Weight conversions.
    if (from == 'Pounds' && to == 'Kilograms') {
      return value * 0.453592;
    }
    if (from == 'Kilograms' && to == 'Pounds') {
      return value / 0.453592;
    }

    // Temperature conversions.
    if (from == 'Fahrenheit' && to == 'Celsius') {
      return (value - 32) * 5 / 9;
    }
    if (from == 'Celsius' && to == 'Fahrenheit') {
      return (value * 9 / 5) + 32;
    }

    return value;
  }

  /// Formats the number to make the result easier to read.
  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  /// Clears the input and conversion result.
  void _reset() {
    setState(() {
      _valueController.clear();
      _fromUnit = 'Miles';
      _toUnit = 'Kilometers';
      _result = '';
    });
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unit Converter'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Unit Converter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: _valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Enter value',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _fromUnit,
                      decoration: const InputDecoration(
                        labelText: 'Convert From',
                        border: OutlineInputBorder(),
                      ),
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _fromUnit = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _toUnit,
                      decoration: const InputDecoration(
                        labelText: 'Convert To',
                        border: OutlineInputBorder(),
                      ),
                      items: _units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _toUnit = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    FilledButton(
                      onPressed: _convert,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Convert'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Reset'),
                    ),

                    const SizedBox(height: 24),

                    if (_result.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        child: Text(
                          _result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
