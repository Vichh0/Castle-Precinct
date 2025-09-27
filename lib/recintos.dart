import 'package:flutter/material.dart';

class RecintosTab extends StatefulWidget {
  const RecintosTab({super.key});

  @override
  State<RecintosTab> createState() => _RecintosTabState();
}

class _RecintosTabState extends State<RecintosTab> {
  final List<Map<String, String>> _recintos = [
    {
      'nombre': 'Velódromo',
      'descripcion': 'El Velódromo es un recinto deportivo especializado para competencias de ciclismo de pista.',
      'contacto': '555-9874',
      'ubicacion': 'Avenida Moscoso 555',
      'imagen': 'assets/images/2Velodromo_zpsbde14da7.jpg',
    },
    {
      'nombre': 'Centro Olímpico',
      'descripcion': 'El Centro de Entrenamiento Olímpico es un complejo para la preparación de atletas de alto rendimiento.',
      'contacto': '555-4657',
      'ubicacion': 'Avenida carrera 60 # 50 - 22',
      'imagen': 'assets/images/Centro_entrenamiento_olimpico.jpg',
    },
    {
      'nombre': 'Complejo de canchas',
      'descripcion': 'Este recinto es utilizado para eventos deportivos y culturales de diversa índole.',
      'contacto': '555-1234',
      'ubicacion': 'Avenida Siempre Viva 742',
      'imagen': 'assets/images/image_750x_60cddd825fe6e.jpg',
    },
    {
      'nombre': 'Piscina',
      'descripcion': 'La piscina olímpica es ideal para competencias de natación y entrenamiento acuático.',
      'contacto': '555-7530',
      'ubicacion': 'Lircay # 45-67',
      'imagen': 'assets/images/picina.jpg',
    },
  ];

  void _showRecintoDialog(BuildContext context, String title, String description, [String? contacto, String? ubicacion]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            if (contacto != null) ...[
              SizedBox(height: 12),
              Text('Contacto: $contacto'),
            ],
            if (ubicacion != null) ...[
              SizedBox(height: 12),
              Text('Ubicación: $ubicacion'),
            ],
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showAddRecintoDialog() {
    final _nombreController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _contactoController = TextEditingController();
    final _ubicacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Recinto'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 2,
                ),
                TextField(
                  controller: _contactoController,
                  decoration: InputDecoration(labelText: 'Contacto'),
                ),
                TextField(
                  controller: _ubicacionController,
                  decoration: InputDecoration(labelText: 'Ubicación'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                if (_nombreController.text.isNotEmpty && _descripcionController.text.isNotEmpty) {
                  setState(() {
                    _recintos.add({
                      'nombre': _nombreController.text,
                      'descripcion': _descripcionController.text,
                      'contacto': _contactoController.text,
                      'ubicacion': _ubicacionController.text,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: _recintos.map((recinto) {
              return InkWell(
                onTap: () => _showRecintoDialog(
                  context,
                  recinto['nombre'] ?? '',
                  recinto['descripcion'] ?? '',
                  recinto['contacto'],
                  recinto['ubicacion'],
                ),
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: recinto['imagen'] != null
                            ? Image.asset(
                                recinto['imagen']!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Icon(Icons.location_city, size: 48, color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(recinto['nombre'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: _showAddRecintoDialog,
            child: Icon(Icons.add),
            tooltip: 'Agregar Recinto',
          ),
        ),
      ],
    );
  }
}