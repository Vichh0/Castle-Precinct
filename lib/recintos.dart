import 'package:flutter/material.dart';

class RecintosTab extends StatelessWidget {
  const RecintosTab({super.key});

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
            onTap: () => _showRecintoDialog(
              context,
              'Velódromo',
              'El Velódromo es un recinto deportivo especializado para competencias de ciclismo de pista.',
              'Contacto: 555-9874',
              'Ubicación: Avenida Moscoso 555',
            ),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/2Velodromo_zpsbde14da7.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Velódromo', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showRecintoDialog(
              context,
              'Centro Olímpico',
              'El Centro de Entrenamiento Olímpico es un complejo para la preparación de atletas de alto rendimiento.',
              'Contacto: 555-4657',
              'Ubicación: Avenida carrera 60 # 50 - 22',
            ),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/Centro_entrenamiento_olimpico.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Centro Olímpico', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showRecintoDialog(
              context,
              'Complejo de canchas',
              'Este recinto es utilizado para eventos deportivos y culturales de diversa índole.',
              'Contacto: 555-1234',
              'Ubicación: Avenida Siempre Viva 742',
            ),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/image_750x_60cddd825fe6e.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Complejo de canchas', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _showRecintoDialog(
              context,
              'Piscina',
              'La piscina olímpica es ideal para competencias de natación y entrenamiento acuático.',
              'Contacto: 555-7530',
              'Ubicación: Lircay # 45-67',
            ),
            child: Card(
              elevation: 4,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/picina.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Piscina', style: TextStyle(fontWeight: FontWeight.bold)),
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