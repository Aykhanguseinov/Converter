import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Temperature extends StatefulWidget {
  const Temperature({super.key});

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  String _selectedUnit = 'C';
  String _outputUnit = 'F';
  double _outputValue = 0;
  bool _showErrorMessage = false; 

  void _convert() {
    if (_formKey.currentState!.validate()) {
      double inputValue = double.parse(_inputController.text);

      if (_selectedUnit == _outputUnit) {
        setState(() {
          _showErrorMessage = true; 
          _outputValue = inputValue;
        });
        return; 
      }

      if (_selectedUnit == 'C' && _outputUnit == 'F') {
        _outputValue = (inputValue * 9 / 5) + 32;
      } else if (_selectedUnit == 'C' && _outputUnit == 'K') {
        _outputValue = inputValue + 273.15;
      } else if (_selectedUnit == 'F' && _outputUnit == 'C') {
        _outputValue = (inputValue - 32) * 5 / 9;
      } else if (_selectedUnit == 'F' && _outputUnit == 'K') {
        _outputValue = (inputValue - 32) * 5 / 9 + 273.15;
      } else if (_selectedUnit == 'K' && _outputUnit == 'C') {
        _outputValue = inputValue - 273.15;
      } else if (_selectedUnit == 'K' && _outputUnit == 'F') {
        _outputValue = (inputValue - 273.15) * 9 / 5 + 32;
      }

      setState(() {
        _showErrorMessage = false; 
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Конвертер Температуры',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () => {Navigator.pushNamed(context, '/home')},
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.orange,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Введите значение',
                  prefixIcon: Icon(    
                    Icons.beach_access,
                    color: Colors.orange,
                    size: 40,
                  ),
                ), 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста введите значение';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _selectedUnit,
                items: ['C', 'F', 'K']
                    .map((unit) => DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _outputUnit,
                items: ['C', 'F', 'K']
                    .map((unit) => DropdownMenuItem<String>(
                          value: unit,
                          child: Text(unit),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _outputUnit = newValue!;
                  });
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _convert,
                child: Text('Рассчитать',
                style: TextStyle(color: Colors.white),
                ),
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, 
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
              SizedBox(height: 20.0),
              if (_showErrorMessage) 
                Text(
                  'Введите разные температуры.',
                  style: TextStyle(color: Colors.red),
                ),
              Text(
                'Результат: $_outputValue ${_outputUnit}',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}