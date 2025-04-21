import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth BLE',
      debugShowCheckedModeBanner: false,
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<BluetoothDevice> _devices = [];
  List<String> _receivedDataList = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _askPermissions();
    _startScan();
  }

  // Solicita permisos de Bluetooth y Ubicación
  void _askPermissions() async {
    try {
      await FlutterBluePlus.turnOn();

      if (await Permission.bluetoothScan.isDenied) {
        await Permission.bluetoothScan.request();
      }
      if (await Permission.bluetoothConnect.isDenied) {
        await Permission.bluetoothConnect.request();
      }
      if (await Permission.location.isDenied) {
        await Permission.location.request();
      }
    } catch (e) {
      print("❌ Error al pedir permisos: $e");
    }
  }

  void _startScan() async {
    setState(() {
      _devices.clear();
      _isScanning = true;
    });

    print("🔍 Escaneando dispositivos...");
    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _devices = results.map((r) => r.device).toList();
      });
    });

    await Future.delayed(Duration(seconds: 6));
    await FlutterBluePlus.stopScan();
    setState(() => _isScanning = false);
    print("✅ Escaneo finalizado.");
  }

  void _connectToDevice(BluetoothDevice device) async {
    try {
      print("🔗 Conectando a: ${device.name} (${device.id})");
      await device.connect();
      print("✅ Conectado.");

      List<BluetoothService> services = await device.discoverServices();
      print("🔍 Servicios encontrados: ${services.length}");

      for (var service in services) {
        print("🧩 Servicio: ${service.uuid}");

        for (var characteristic in service.characteristics) {
          print("📌 Característica: ${characteristic.uuid}");
          print("➡ Propiedades: ${characteristic.properties}");

          if (characteristic.properties.read) {
            var value = await characteristic.read();
            print("📥 Valor leído: $value");
            setState(() {
              _receivedDataList.add(String.fromCharCodes(value));
            });
          }

          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              print("🔔 Notificación: $value");
              setState(() {
                _receivedDataList.add(String.fromCharCodes(value));
              });
            });
          }
        }
      }
    } catch (e) {
      print("❌ Error al conectar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth BLE Flutter"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: _devices.isEmpty
                ? Center(child: Text("No se encontraron dispositivos"))
                : ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        title: Text(device.name.isEmpty
                            ? "Dispositivo sin nombre"
                            : device.name),
                        subtitle: Text(device.id.toString()),
                        trailing: Icon(Icons.bluetooth),
                        onTap: () {
                          print("🖱 Tocaste: ${device.name}");
                          _connectToDevice(device);
                        },
                      );
                    },
                  ),
          ),
          Divider(),
          Expanded(
            child: _receivedDataList.isEmpty
                ? Center(child: Text("No hay datos recibidos"))
                : ListView.builder(
                    itemCount: _receivedDataList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.data_usage),
                          title: Text(_receivedDataList[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blueAccent,
        onPressed: _isScanning ? null : _startScan,
      ),
    );
  }
}
