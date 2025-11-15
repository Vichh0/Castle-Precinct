import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String? name;
  final String? email;
  final String? password;

  const ProfilePage({super.key, this.name, this.email, this.password});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _name;
  late String _email;
  late String _password;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _name = widget.name ?? 'Tu Nombre';
    _email = widget.email ?? 'No registrado';
    _password = widget.password ?? '';
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('profile_name');
    final storedEmail = prefs.getString('profile_email');
    final storedPassword = prefs.getString('profile_password');
    setState(() {
      _name = storedName ?? _name;
      _email = storedEmail ?? _email;
      _password = storedPassword ?? _password;
    });
  }

  Future<void> _saveProfile(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);
    await prefs.setString('profile_password', password);

    // Guardar también en lista de cuentas
    await _addAccountToList(name, email, password);
  }

  Future<void> _addAccountToList(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final accountsJson = prefs.getString('accounts_list') ?? '[]';
    final List<dynamic> accountsList = jsonDecode(accountsJson);

    // Verificar si la cuenta ya existe (por email)
    final accountExists = accountsList.any((acc) => acc['email'] == email);

    if (!accountExists) {
      accountsList.add({
        'name': name,
        'email': email,
        'password': password,
      });

      await prefs.setString('accounts_list', jsonEncode(accountsList));
    } else {
      // Actualizar cuenta existente
      final index = accountsList.indexWhere((acc) => acc['email'] == email);
      if (index != -1) {
        accountsList[index] = {
          'name': name,
          'email': email,
          'password': password,
        };
        await prefs.setString('accounts_list', jsonEncode(accountsList));
      }
    }
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final passwordController = TextEditingController(text: _password);
    bool obscurePassword = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Editar perfil'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setDialogState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: obscurePassword,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();
                    final newEmail = emailController.text.trim();
                    final newPassword = passwordController.text.trim();
                    if (newName.isNotEmpty && newEmail.isNotEmpty && newPassword.isNotEmpty) {
                      setState(() {
                        _name = newName;
                        _email = newEmail;
                        _password = newPassword;
                      });
                      await _saveProfile(newName, newEmail, newPassword);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perfil actualizado')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Completa todos los campos')),
                      );
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserLoginPage()),
                );
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Editar perfil',
            onPressed: _showEditDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue[200],
              child: const Icon(Icons.person, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              _name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('Correo'),
                subtitle: Text(_email),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Nombre'),
                subtitle: Text(_name),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.lock, color: Colors.blue),
                title: const Text('Contraseña'),
                subtitle: Text(_password.isNotEmpty ? '••••••••' : 'No establecida'),
                trailing: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}