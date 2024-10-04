import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Money extends StatefulWidget {
  const Money({super.key});

  @override
  State<Money> createState() => _ExchangeState();
}

class _ExchangeState extends State<Money> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  String _selectedUnit = 'USD';
  String _outputUnit = 'EUR';
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

      if (_selectedUnit == 'USD' && _outputUnit == 'EUR') {
        _outputValue = inputValue * (104 / 95); 
      } else if (_selectedUnit == 'USD' && _outputUnit == 'RUB') {
        _outputValue = inputValue * 95; 
      } else if (_selectedUnit == 'EUR' && _outputUnit == 'USD') {
        _outputValue = inputValue * (95 / 104); 
      } else if (_selectedUnit == 'EUR' && _outputUnit == 'RUB') {
        _outputValue = inputValue * 104; 
      } else if (_selectedUnit == 'RUB' && _outputUnit == 'USD') {
        _outputValue = inputValue / 95; 
      } else if (_selectedUnit == 'RUB' && _outputUnit == 'EUR') {
        _outputValue = inputValue / 104; 
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
          'Конвертер Валюты',
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
                    Icons.currency_exchange,
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
                items: ['USD', 'EUR', 'RUB']
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
                items: ['USD', 'EUR', 'RUB']
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
                  'Выберите разные валюты',
                  style: TextStyle(color: Colors.red, fontSize: 20),
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