import 'package:flutter/material.dart';

class Eventostab extends StatelessWidget {

  void _showEventosDialog(BuildContext context, String title, String description, [ String? ubicacion, String? fecha]) {
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          InkWell(
            onTap: () => _showEventosDialog(
              context,
              'Carrera de Ciclismo',
              'Competencia nacional de ciclismo en el velódromo.',
              'Velódromo',
              '12 de Octubre, 2025',
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
                        Text('Carrera de Ciclismo', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showEventosDialog(
              context,
              'Torneo de Natación',
              'Evento de natación en la piscina olímpica.',
              'Piscina',
              '5 de Noviembre, 2026',
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
                        Text('Torneo de Natación', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showEventosDialog(
              context,
              'Festival Deportivo',
              'Jornada de deportes y actividades recreativas.',
              'Centro Olimpico',
              '20 de Agosto, 2027',
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
                        Text('Festival Deportivo', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showEventosDialog(
              context,
              'Entrenamiento Olimpico',
              'Sesión especial para atletas.',
              'Centro Olimpico',
              '15 de Marzo, 2025',
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
                        Text('Entrenamiento Olimpico', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showEventosDialog(
              context,
              'Actividades Comunales',
              'Junta de vecinos con actividades recreativas.',
              'Complejo de Canchas',
              '10 de Diciembre, 2026',
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
                        Text('Actividades Comunales', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  /*
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
}*/