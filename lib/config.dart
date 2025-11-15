import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'perfil.dart';

class ConfigPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const ConfigPage({super.key, required this.onThemeChanged});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  String _profileName = 'Tu Nombre';
  String _profileEmail = 'No registrado';
  String _profilePassword = '';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadThemePreference();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('profile_name');
    final storedEmail = prefs.getString('profile_email');
    final storedPassword = prefs.getString('profile_password');

    setState(() {
      _profileName = storedName ?? 'Tu Nombre';
      _profileEmail = storedEmail ?? 'No registrado';
      _profilePassword = storedPassword ?? '';
    });
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    setState(() {
      _isDarkMode = isDark;
    });
  }

  Future<void> _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveThemePreference(value);
    widget.onThemeChanged(value);
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          name: _profileName,
          email: _profileEmail,
          password: _profilePassword,
        ),
      ),
    ).then((_) {
      _loadProfile(); // Recargar datos al volver
    });
  }

  void _showAllAccounts() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: _getAllAccounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const AlertDialog(
                title: Text('Cuentas registradas'),
                content: CircularProgressIndicator(),
              );
            }

            final accounts = snapshot.data as List<Map<String, String>>? ?? [];

            return AlertDialog(
              title: const Text('Cuentas registradas'),
              content: SizedBox(
                width: double.maxFinite,
                child: accounts.isEmpty
                    ? const Center(
                        child: Text('No hay cuentas registradas'),
                      )
                    : ListView.separated(
                        itemCount: accounts.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final account = accounts[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(account['name'] ?? 'Sin nombre'),
                            subtitle: Text(account['email'] ?? 'Sin correo'),
                            trailing: const Icon(Icons.check_circle, color: Colors.green),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, String>>> _getAllAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> accounts = [];

    final name = prefs.getString('profile_name');
    final email = prefs.getString('profile_email');

    if (name != null && email != null) {
      accounts.add({
        'name': name,
        'email': email,
      });
    }

    return accounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Ajustes de la aplicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),

              // Card de Perfil que muestra los datos guardados
              Card(
                elevation: 6,
                color: Colors.blue[50],
                child: InkWell(
                  onTap: _openProfile,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.blue[200],
                          child: const Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _profileName,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _profileEmail,
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card para ver todas las cuentas
              Card(
                elevation: 4,
                color: Colors.green[50],
                child: InkWell(
                  onTap: _showAllAccounts,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.green[200],
                          child: const Icon(Icons.people, size: 30, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cuentas registradas',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Ver todas las cuentas disponibles',
                                style: TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Card para cambiar tema
              Card(
                elevation: 4,
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.purple[200],
                        child: Icon(
                          _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tema de la aplicación',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isDarkMode ? 'Modo oscuro' : 'Modo claro',
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isDarkMode,
                        onChanged: _toggleTheme,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}