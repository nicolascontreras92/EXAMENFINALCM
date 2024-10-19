import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/auth_service.dart';
import 'package:examen_nicolascontreras/ui/input_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Iniciar Sesión',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            _LoginForm(),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'registro'),
              child: const Text('¿No tienes una cuenta? Regístrate aquí'),
            )
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<_LoginForm> createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: emailController,
          decoration: InputDecorations.authInputDecoration(
            labelText: 'Correo Electrónico',
            hintText: 'Ingrese su correo',
            prefixIcon: Icons.email,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecorations.authInputDecoration(
            labelText: 'Contraseña',
            hintText: '********',
            prefixIcon: Icons.lock,
          ),
        ),
        const SizedBox(height: 20),
        MaterialButton(
onPressed: () async {
  final authService = Provider.of<AuthService>(context, listen: false);
final bool loginSuccess = await authService.login(emailController.text, passwordController.text);

if (loginSuccess) {

  Navigator.pushReplacementNamed(context, 'home');
} else {
  
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Credenciales incorrectas')));
}
},
          color: Colors.red,
          child: const Text(
            'Ingresar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

