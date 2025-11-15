import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Eventostab extends StatefulWidget {
  @override
  State<Eventostab> createState() => _EventostabState();
}

class _EventostabState extends State<Eventostab> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, String>> _eventos = [];
  Map<String, List<Map<String, String>>> _activitiesByDate = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  static String _keyForDateStatic(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _keyForDate(DateTime date) => _keyForDateStatic(date);

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getString('eventos_list') ?? '[]';
    final activitiesJson = prefs.getString('activities_list') ?? '{}';

    final List<dynamic> eventsList = jsonDecode(eventsJson);
    final Map<String, dynamic> activitiesMap = jsonDecode(activitiesJson);

    setState(() {
      _eventos = eventsList.map((e) => Map<String, String>.from(e as Map)).toList();

      _activitiesByDate = activitiesMap.map((key, value) {
        final list = (value as List).map((item) => Map<String, String>.from(item as Map)).toList();
        return MapEntry(key, list);
      });

      // Si está vacío, cargar datos de ejemplo
      if (_eventos.isEmpty) {
        _eventos = [
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
        ];

        _activitiesByDate = {
          _keyForDateStatic(DateTime.now()): [
            {'title': 'Carrera de Ciclismo', 'subtitle': 'Velódromo - 10:00'},
            {'title': 'Entrenamiento Juvenil', 'subtitle': 'Centro Olímpico - 14:00'},
          ],
          _keyForDateStatic(DateTime.now().add(Duration(days: 1))): [
            {'title': 'Torneo de Natación', 'subtitle': 'Piscina Olímpica - 09:00'},
          ],
        };

        _saveEvents();
      }
    });
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eventos_list', jsonEncode(_eventos));
    await prefs.setString('activities_list', jsonEncode(_activitiesByDate));
  }

  List<Map<String, String>> _activitiesFor(DateTime date) {
    return _activitiesByDate[_keyForDate(date)] ?? [];
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _showActivityDialog(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['title'] ?? ''),
        content: Text(item['subtitle'] ?? ''),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  void _showAddEventoDialog() {
    final _tituloController = TextEditingController();
    final _descripcionController = TextEditingController();
    final _ubicacionController = TextEditingController();
    final _horaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
                TextField(controller: _descripcionController, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 2),
                TextField(controller: _ubicacionController, decoration: const InputDecoration(labelText: 'Ubicación')),
                TextField(controller: _horaController, decoration: const InputDecoration(labelText: 'Hora (ej. 14:00)')),
              ],
            ),
          ),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
            ElevatedButton(
              child: const Text('Agregar'),
              onPressed: () async {
                final titulo = _tituloController.text.trim();
                final descripcion = _descripcionController.text.trim();
                final ubicacion = _ubicacionController.text.trim();
                final hora = _horaController.text.trim();

                if (titulo.isEmpty || descripcion.isEmpty) return;

                setState(() {
                  _eventos.add({
                    'titulo': titulo,
                    'descripcion': descripcion,
                    'ubicacion': ubicacion,
                    'fecha': _selectedDate.toIso8601String(),
                  });

                  final key = _keyForDate(_selectedDate);
                  final entry = {'title': titulo, 'subtitle': '${ubicacion.isNotEmpty ? '$ubicacion - ' : ''}${hora.isNotEmpty ? hora : ''}'};
                  if (_activitiesByDate.containsKey(key)) {
                    _activitiesByDate[key]!.add(entry);
                  } else {
                    _activitiesByDate[key] = [entry];
                  }
                });

                await _saveEvents();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = _activitiesFor(_selectedDate);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Calendar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    onDateChanged: _onDateChanged,
                  ),
                ),
              ),
            ),

            // Encabezado actividades
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                children: [
                  Text(
                    'Actividades - ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() {})),
                ],
              ),
            ),

            // Lista de actividades en cards
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: activities.isEmpty
                    ? Center(
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('No hay actividades para esta fecha', style: TextStyle(color: Colors.black54)),
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 4.0),
                        itemCount: activities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = activities[index];
                          return Card(
                            elevation: 3,
                            child: InkWell(
                              onTap: () => _showActivityDialog(item),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.event, color: Colors.white)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 6),
                                          Text(item['subtitle'] ?? '', style: const TextStyle(color: Colors.black54)),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddEventoDialog, child: const Icon(Icons.add), tooltip: 'Agregar Evento'),
    );
  }
}