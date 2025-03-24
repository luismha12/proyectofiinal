import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/db_helper.dart';

class AgregarProductoScreen extends StatefulWidget {
  @override
  _AgregarProductoScreenState createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  String? _imagenPath;

  Future<void> _tomarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagenPath = pickedFile.path;
      });
    }
  }

  Future<void> _guardarProducto() async {
    if (_formKey.currentState!.validate() && _imagenPath != null) {
      final nombre = _nombreController.text.trim();
      final precio = double.tryParse(_precioController.text.trim()) ?? 0.0;

      await DBHelper.insertarProducto(nombre, _imagenPath!, precio);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto agregado exitosamente')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre del producto'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese un nombre' : null,
              ),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Precio'),
                validator: (value) =>
                    value == null || double.tryParse(value) == null
                        ? 'Ingrese un precio válido'
                        : null,
              ),
              SizedBox(height: 20),
              _imagenPath != null
                  ? Image.file(File(_imagenPath!), height: 150)
                  : SizedBox(),
              ElevatedButton.icon(
                onPressed: _tomarFoto,
                icon: Icon(Icons.camera_alt),
                label: Text('Tomar foto'),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _guardarProducto,
                icon: Icon(Icons.save),
                label: Text('Guardar producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
