import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSScreen extends StatefulWidget {
  @override
  _GPSScreenState createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  String _ubicacion = 'Obteniendo ubicación...';

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    bool servicioHabilitado;
    LocationPermission permiso;

    // Verificar si el servicio de ubicación está habilitado
    servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      setState(() {
        _ubicacion = 'El servicio de ubicación está desactivado.';
      });
      return;
    }

    // Verificar permisos
    permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        setState(() {
          _ubicacion = 'Permiso de ubicación denegado.';
        });
        return;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      setState(() {
        _ubicacion =
            'Permiso de ubicación denegado permanentemente. No se puede solicitar.';
      });
      return;
    }

    // Obtener ubicación
    Position posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _ubicacion =
          'Latitud: ${posicion.latitude}, Longitud: ${posicion.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación GPS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _ubicacion,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _obtenerUbicacion,
              icon: Icon(Icons.gps_fixed),
              label: Text('Actualizar ubicación'),
            ),
          ],
        ),
      ),
    );
  }
}
