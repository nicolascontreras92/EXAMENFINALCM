import 'package:flutter/material.dart';
import 'package:examen_nicolascontreras/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Colors.red, 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Productos',
              onPressed: () {
                Navigator.pushNamed(context, 'productos');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Categorías',
              onPressed: () {
                Navigator.pushNamed(context, 'categorias');
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Proveedores',
              onPressed: () {
                Navigator.pushNamed(context, 'proveedores');
              },
            ),
          ],
        ),
      ),
    );
  }
}
