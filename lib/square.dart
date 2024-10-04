import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Square extends StatefulWidget {
  const Square({super.key});

  @override
  State<Square> createState() => _SquareState();
}

class _SquareState extends State<Square> {
  final _formKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();
  String _selectedUnit = 'm²';
  String _outputUnit = 'cm²';
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

      if (_selectedUnit == 'm²' && _outputUnit == 'cm²') {
        _outputValue = inputValue * 10000;
      } else if (_selectedUnit == 'm²' && _outputUnit == 'km²') {
        _outputValue = inputValue / 1000000;
      } else if (_selectedUnit == 'cm²' && _outputUnit == 'm²') {
        _outputValue = inputValue / 10000;
      } else if (_selectedUnit == 'cm²' && _outputUnit == 'km²') {
        _outputValue = inputValue / 10000000000;
      } else if (_selectedUnit == 'km²' && _outputUnit == 'm²') {
        _outputValue = inputValue * 1000000;
      } else if (_selectedUnit == 'km²' && _outputUnit == 'cm²') {
        _outputValue = inputValue * 10000000000;
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
          'Конвертер Площади',
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
                    Icons.crop_square,
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
                items: ['cm²', 'km²', 'm²']
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
                items: ['cm²', 'km²', 'm²']
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
                  'Выберите разные единицы измерения',
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