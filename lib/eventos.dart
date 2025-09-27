import 'package:flutter/material.dart';

class Eventostab extends StatefulWidget {
  @override
  State<Eventostab> createState() => _EventostabState();
}

class _EventostabState extends State<Eventostab> {
  final List<Map<String, String>> _eventos = [
    {
      'titulo': 'Carrera de Ciclismo',
      'descripcion': 'Competencia nacional de ciclismo en el velódromo.',
      'ubicacion': 'Velódromo',
      'fecha': '12 de Octubre, 2025',
    },
    {
      'titulo': 'Torneo de Natación',
      'descripcion': 'Evento de natación en la piscina olímpica.',
      'ubicacion': 'Piscina',
      'fecha': '5 de Noviembre, 2026',
    },
    {
      'titulo': 'Festival Deportivo',
      'descripcion': 'Jornada de deportes y actividades recreativas.',
      'ubicacion': 'Centro Olimpico',
      'fecha': '20 de Agosto, 2027',
    },
    {
      'titulo': 'Entrenamiento Olimpico',
      'descripcion': 'Sesión especial para atletas.',
      'ubicacion': 'Centro Olimpico',
      'fecha': '15 de Marzo, 2025',
    },
    {
      'titulo': 'Actividades Comunales',
      'descripcion': 'Junta de vecinos con actividades recreativas.',
      'ubicacion': 'Complejo de Canchas',
      'fecha': '10 de Diciembre, 2026',
    },
  ];

  void _showEventosDialog(BuildContext context, String title, String description, [String? ubicacion, String? fecha]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            if (ubicacion != null) ...[
              SizedBox(height: 12),
              Text('Ubicación: $ubicacion'),
            ],
            if (fecha != null) ...[
              SizedBox(height: 12),
              Text('Fecha: $fecha'),
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

  void _showAddEventoDialog() {
    final _tituloController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _ubicacionController = TextEditingController();
    final _fechaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 2,
                ),
                TextField(
                  controller: _ubicacionController,
                  decoration: InputDecoration(labelText: 'Ubicación'),
                ),
                TextField(
                  controller: _fechaController,
                  decoration: InputDecoration(labelText: 'Fecha'),
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
                if (_tituloController.text.isNotEmpty && _descripcionController.text.isNotEmpty) {
                  setState(() {
                    _eventos.add({
                      'titulo': _tituloController.text,
                      'descripcion': _descripcionController.text,
                      'ubicacion': _ubicacionController.text,
                      'fecha': _fechaController.text,
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
            children: _eventos.map((evento) {
              return InkWell(
                onTap: () => _showEventosDialog(
                  context,
                  evento['titulo'] ?? '',
                  evento['descripcion'] ?? '',
                  evento['ubicacion'],
                  evento['fecha'],
                ),
                child: Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.event, size: 48, color: Colors.blue),
                            Text(evento['titulo'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
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
            onPressed: _showAddEventoDialog,
            child: Icon(Icons.add),
            tooltip: 'Agregar Evento',
          ),
        ),
      ],
    );
  }
}