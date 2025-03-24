// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/carrito_provider.dart';
import 'screens/home_screen.dart';
import 'screens/productos_screen.dart';
import 'screens/carrito_screen.dart';
import 'screens/agregar_producto_screen.dart';
import 'screens/gps_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CarritoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frutas y Verduras Luisitos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/productos': (context) => ProductosScreen(),
        '/carrito': (context) => CarritoScreen(),
        '/agregar': (context) => AgregarProductoScreen(),
        
      },
    );
  }
}
