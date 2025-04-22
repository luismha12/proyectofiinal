import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String nombre = '';

  @override
  void initState() {
    super.initState();
    obtenerNombre();
  }

  Future<void> obtenerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    final guardado = prefs.getString('nombre_usuario');
    if (guardado == null || guardado.isEmpty) {
      Navigator.pushReplacementNamed(context, '/agregar');
    } else {
      setState(() => nombre = guardado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido $nombre')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hola $nombre 👋', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/productos'),
              child: Text('Ver productos'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/carrito'),
              child: Text('Ver carrito'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/gps'),
              child: Text('Ver ubicación'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/gps'),
              child: Text('Ubicación GPS'),
            ),

          ],
        ),
      ),
    );
  }
}
