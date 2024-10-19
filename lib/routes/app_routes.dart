import 'package:flutter/material.dart';
import 'package:examen_nicolascontreras/screens/home_screen.dart';
import 'package:examen_nicolascontreras/screens/login_screen.dart';
import 'package:examen_nicolascontreras/screens/registro_screen.dart';
import 'package:examen_nicolascontreras/screens/productos_screen.dart';
import 'package:examen_nicolascontreras/screens/categorias_screen.dart';
import 'package:examen_nicolascontreras/screens/proveedores_screen.dart'; 


class AppRoutes {
  static const String initialRoute = 'login';

  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'login': (BuildContext context) => const LoginScreen(),
    'registro': (BuildContext context) => const RegistroScreen(),
    'categorias': (BuildContext context) => const CategoriasScreen(),
    'proveedores': (BuildContext context) => const ProveedoresScreen(), 
    'productos': (BuildContext context) => const ProductosScreen(),

  };
}
