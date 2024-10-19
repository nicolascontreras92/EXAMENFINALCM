import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/auth_service.dart';
import 'package:examen_nicolascontreras/services/provider_service.dart';
import 'package:examen_nicolascontreras/services/category_service.dart';
import 'package:examen_nicolascontreras/services/product_service.dart';
import 'package:examen_nicolascontreras/routes/app_routes.dart';
import 'firebase_options.dart';
import 'package:examen_nicolascontreras/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProviderService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => ProductService()), 
      ],
      child: MaterialApp(
        title: 'Examen Nicolas Contreras',
        debugShowCheckedModeBanner: false,

        // Aplicar el tema global
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black, // Fondo de las pantallas negro
          brightness: Brightness.dark, // Activar el tema oscuro

          // Definir esquema de colores
          colorScheme: ColorScheme.dark(
            primary: Colors.red, // Color principal: rojo
            secondary: Colors.red, // Color de acento
          ),

          // Estilos para los textos (nueva estructura)
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.red), // Texto grande en rojo
            bodyMedium: TextStyle(color: Colors.red), // Texto mediano en rojo
            bodySmall: TextStyle(color: Colors.red), // Texto pequeño en rojo
          ),

          // Tema para las AppBars (barras superiores)
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red, // Fondo de la barra en rojo
            titleTextStyle: TextStyle(color: Colors.black), // Texto del AppBar en negro
            iconTheme: IconThemeData(color: Colors.black), // Iconos en negro
          ),

          // Tema para los botones elevados (ElevatedButton)
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Fondo de los botones en rojo
              foregroundColor: Colors.black, // Texto en los botones en negro
            ),
          ),

          // Tema para los TextFields (campos de texto)
          inputDecorationTheme: const InputDecorationTheme(
            labelStyle: TextStyle(color: Colors.red), // Etiquetas en rojo
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red), // Borde en rojo
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red), // Borde en rojo al enfocar
            ),
          ),
        ),

        home: _FirebaseInitializer(),
        routes: AppRoutes.routes,
      ),
    );
  }
}

class _FirebaseInitializer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (authService.isAuthenticated) {
            authService.logout();
            return const LoginScreen();
          } else {
            return const LoginScreen();
          }
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('Error inicializando Firebase')),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
