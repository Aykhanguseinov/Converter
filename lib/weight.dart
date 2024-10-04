import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  String _selectedUnit = 'kg';
  String _outputUnit = 'g';
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

      if (_selectedUnit == 'kg' && _outputUnit == 'g') {
        _outputValue = inputValue * 1000;
      } else if (_selectedUnit == 'kg' && _outputUnit == 't') {
        _outputValue = inputValue / 1000;
      } else if (_selectedUnit == 'g' && _outputUnit == 'kg') {
        _outputValue = inputValue / 1000;
      } else if (_selectedUnit == 'g' && _outputUnit == 't') {
        _outputValue = inputValue / 1000000;
      } else if (_selectedUnit == 't' && _outputUnit == 'kg') {
        _outputValue = inputValue * 1000;
      } else if (_selectedUnit == 't' && _outputUnit == 'g') {
        _outputValue = inputValue * 1000000;
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
          'Конвертер Массы',
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
                    Icons.fitness_center,
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
              
              DropdownButton<String>(
                value: _selectedUnit,
                items: ['kg', 'g', 't']
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
              DropdownButton<String>(
                value: _outputUnit,
                items: ['kg', 'g', 't']
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
              if (_showErrorMessage) 
                Text(
                  'Выберите разные единицы измерения.',
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