import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/auth_service.dart';
import 'package:examen_nicolascontreras/ui/input_decorations.dart';

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Crear Cuenta',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            _RegistroForm(),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
              child: const Text('¿Ya tienes una cuenta? Inicia sesión aquí'),
            )
          ],
        ),
      ),
    );
  }
}

class _RegistroForm extends StatefulWidget {
  @override
  State<_RegistroForm> createState() => __RegistroFormState();
}

class __RegistroFormState extends State<_RegistroForm> {
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
  final String? errorMessage = await authService.createUser(emailController.text, passwordController.text);
  
  if (errorMessage == null) {
   
    Navigator.pushReplacementNamed(context, 'login');
  } else {
   
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),  
    ));
  }
},
          color: Colors.red,
          child: const Text(
            'Registrar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}