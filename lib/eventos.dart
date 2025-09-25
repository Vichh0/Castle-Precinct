import 'package:flutter/material.dart';

class Eventostab extends StatelessWidget {

  void _showEventosDialog(BuildContext context, String title, String description, [String? contacto, String? ubicacion]) {
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
  final List<Map<String, String>> eventos = [
    {
      'titulo': 'Carrera de Ciclismo',
      'descripcion': 'Competencia nacional de ciclismo en el velódromo.',
      'localizacion': 'Velódromo',
    },
    {
      'titulo': 'Torneo de Natación',
      'descripcion': 'Evento de natación en la piscina olímpica.',
      'localizacion': 'Piscina',
    },
    {
      'titulo': 'Festival Deportivo',
      'descripcion': 'Jornada de deportes y actividades recreativas.',
      'localizacion': 'Centro Olimpico',
    },
    {
      'titulo': 'Entrenamiento Olimpico',
      'descripcion': 'Sesión especial para atletas.',
      'localizacion': 'Centro Olimpico',
    },
    {
      'titulo': 'Actividades Comunales',
      'descripcion': 'Junta de vecinos con actividades recreativas.',
      'localizacion': 'Complejo de Canchas',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: eventos.map((evento) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(evento['titulo']!),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(evento['descripcion']!),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 20),
                            SizedBox(width: 6),
                            Text(
                              evento['localizacion']!,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event, size: 48, color: Colors.blue),
                  SizedBox(height: 12),
                  Text(
                    evento['titulo']!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                    child: Text(
                      evento['descripcion']!,
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 18),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          evento['localizacion']!,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}