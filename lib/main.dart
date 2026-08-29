import 'package:flutter/material.dart';

void main() {
  runApp(const UnitConverterApp());
}

/// Root widget for the Unit Converter application.
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

/// Main page where users select a measurement type and perform conversions.
class UnitConverterPage extends StatefulWidget {
  const UnitConverterPage({super.key});

  @override
  State<UnitConverterPage> createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  final TextEditingController _valueController = TextEditingController();

  String _category = 'Distance';
  String _fromUnit = 'Miles';
  String _toUnit = 'Kilometers';
  String _result = '';

  final Map<String, List<String>> _unitsByCategory = {
    'Distance': [
      'Miles',
      'Kilometers',
      'Feet',
      'Meters',
    ],
    'Weight': [
      'Pounds',
      'Kilograms',
    ],
    'Temperature': [
      'Fahrenheit',
      'Celsius',
    ],
  };

  /// Returns the units available for the selected measurement category.
  List<String> get _availableUnits => _unitsByCategory[_category]!;

  /// Changes the measurement category and resets the selected units.
  void _changeCategory(String? category) {
    if (category == null) return;

    setState(() {
      _category = category;
      _fromUnit = _availableUnits.first;
      _toUnit = _availableUnits.length > 1
          ? _availableUnits[1]
          : _availableUnits.first;
      _result = '';
    });
  }

  /// Converts the entered value between the selected units.
  void _convert() {
    final input = double.tryParse(_valueController.text.trim());

    if (input == null) {
      setState(() {
        _result = 'Please enter a valid number.';
      });
      return;
    }

    final convertedValue = _convertValue(
      input,
      _fromUnit,
      _toUnit,
    );

    setState(() {
      _result =
          '${_formatNumber(input)} $_fromUnit = '
          '${_formatNumber(convertedValue)} $_toUnit';
    });
  }

  /// Performs the mathematical conversion between two units.
  double _convertValue(double value, String from, String to) {
    if (from == to) {
      return value;
    }

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

  /// Formats numbers to two decimal places when necessary.
  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  /// Clears the input and restores the default selections.
  void _reset() {
    setState(() {
      _valueController.clear();
      _category = 'Distance';
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
        title: const Text(
          'Unit Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.swap_vert,
                      size: 50,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Convert Measurements',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
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
                        hintText: 'Example: 5',
                        prefixIcon: Icon(Icons.numbers),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Measurement Type',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: _unitsByCategory.keys.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: _changeCategory,
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _fromUnit,
                      decoration: const InputDecoration(
                        labelText: 'Convert From',
                        prefixIcon: Icon(Icons.arrow_upward),
                        border: OutlineInputBorder(),
                      ),
                      items: _availableUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _fromUnit = value;
                            _result = '';
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _toUnit,
                      decoration: const InputDecoration(
                        labelText: 'Convert To',
                        prefixIcon: Icon(Icons.arrow_downward),
                        border: OutlineInputBorder(),
                      ),
                      items: _availableUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _toUnit = value;
                            _result = '';
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: _convert,
                      icon: const Icon(Icons.calculate),
                      label: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Convert'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),

                    if (_result.isNotEmpty) ...[
                      const SizedBox(height: 24),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Conversion Result',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _result,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
