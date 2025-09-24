import 'package:flutter/material.dart';
import 'config.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 4,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Text(
              'CastlePrecinct',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, size: 32),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfigPage()),
                );
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Evento'),
              Tab(text: 'Recinto'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Contenido de Evento')),
            Center(child: Text('Contenido de Recinto')),
          ],
        ),
      ),
    );
  }
}
