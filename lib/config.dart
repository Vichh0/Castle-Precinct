import 'package:flutter/material.dart';

class ConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Página de configuración',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}