import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'register.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    // Obtener datos guardados en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('profile_email');
    final storedPassword = prefs.getString('profile_password');

    // Verificar si el usuario existe y la contraseña es correcta
    if (storedEmail == null || storedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario no registrado. Por favor regístrate primero')),
      );
      return;
    }

    if (email != storedEmail || password != storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
      return;
    }

    // Login exitoso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Bienvenido!')),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CastlePrecinct')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Por favor ingresa tus datos para iniciar sesión',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Card ahora con fondo azul y campos con fondo blanco para legibilidad
              Card(
                elevation: 8,
                color: Colors.blue[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Ingresar'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('Registrarse'),
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}