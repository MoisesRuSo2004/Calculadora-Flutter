import 'dart:math';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  String _operation = '';
  String _message = '';
  double? _result;
  int? _cociente;
  int? _residuo;

  void _calculate(String operation) {
    final String text1 = _num1Controller.text.trim();
    final String text2 = _num2Controller.text.trim();

    if (text1.isEmpty || text2.isEmpty) {
      setState(() {
        _result = null;
        _message = "Debes ingresar ambos números";
        _operation = operation;
        _cociente = null;
        _residuo = null;
      });
      return;
    }

    final num1 = double.tryParse(text1);
    final num2 = double.tryParse(text2);

    if (num1 == null || num2 == null) {
      setState(() {
        _result = null;
        _message = "Entradas inválidas, solo números";
        _operation = operation;
        _cociente = null;
        _residuo = null;
      });
      return;
    }

    setState(() {
      _operation = operation;
      _message = "";
      _cociente = null;
      _residuo = null;

      switch (operation) {
        case 'suma':
          _result = num1 + num2;
          break;
        case 'resta':
          _result = num1 - num2;
          break;
        case 'multiplicación':
          _result = num1 * num2;
          break;
        case 'división':
          if (num2 == 0) {
            _result = null;
            _message = "Error: División por cero";
          } else {
            _result = num1 / num2;
            _cociente = num1 ~/ num2; // división entera
            _residuo = num1 % num2 as int;
          }
          break;
        case 'potencia':
          _result = pow(num1, num2).toDouble();
          break;
        case 'raíz':
          if (num2 == 0) {
            _result = null;
            _message = "El índice de la raíz no puede ser 0";
          } else if (num1 < 0 && num2 % 2 == 0) {
            _result = null;
            _message = "No se puede calcular raíz par de un número negativo";
          } else {
            _result = pow(num1, 1 / num2).toDouble();
          }
          break;
        case 'logaritmo':
          if (num1 <= 0) {
            _result = null;
            _message = "El argumento debe ser > 0";
          } else if (num2 <= 0 || num2 == 1) {
            _result = null;
            _message = "La base debe ser > 0 y distinta de 1";
          } else {
            _result = log(num1) / log(num2);
          }
          break;
      }
    });
  }

  void _clear() {
    _num1Controller.clear();
    _num2Controller.clear();
    setState(() {
      _operation = '';
      _result = null;
      _message = '';
      _cociente = null;
      _residuo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ------- Inputs -------
            TextField(
              controller: _num1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Primer número",
                prefixIcon: Icon(Icons.looks_one_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _num2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Segundo número",
                prefixIcon: Icon(Icons.looks_two_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // ------- Botones -------
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _calculate('suma'),
                  icon: const Icon(Icons.add),
                  label: const Text("Suma"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('resta'),
                  icon: const Icon(Icons.remove),
                  label: const Text("Resta"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('multiplicación'),
                  icon: const Icon(Icons.clear),
                  label: const Text("Multiplicación"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('división'),
                  icon: const Icon(Icons.horizontal_rule),
                  label: const Text("División"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('potencia'),
                  icon: const Icon(Icons.exposure),
                  label: const Text("Potencia"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('raíz'),
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text("Raíz"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _calculate('logaritmo'),
                  icon: const Icon(Icons.functions),
                  label: const Text("Logaritmo"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ------- Resultado -------
            Card(
              color: Colors.orange[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Resultado: $_operation",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    if (_message.isNotEmpty)
                      Text(_message, style: const TextStyle(color: Colors.red)),
                    if (_result != null)
                      Text(
                        _result! % 1 == 0
                            ? _result!.toInt().toString()
                            : _result!.toStringAsFixed(4),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_cociente != null && _residuo != null)
                      Text("Cociente: $_cociente | Residuo: $_residuo"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _clear,
              icon: const Icon(Icons.refresh),
              label: const Text("Limpiar"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _num1Controller.dispose();
    _num2Controller.dispose();
    super.dispose();
  }
}
