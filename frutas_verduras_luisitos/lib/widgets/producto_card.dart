import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frutas_verduras_luisitos/data/db_helper.dart';
import '../models/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onEliminado;

  const ProductoCard({super.key, required this.producto, this.onEliminado});

  @override
  Widget build(BuildContext context) {
    final bool esImagenLocal = !producto.imagen.startsWith('assets/');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          esImagenLocal
              ? Image.file(File(producto.imagen), height: 80, fit: BoxFit.contain)
              : Image.asset(producto.imagen, height: 80, fit: BoxFit.contain),
          SizedBox(height: 8),
          Text(producto.nombre, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('\$${producto.precio.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('¿Eliminar producto?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancelar')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Eliminar')),
                  ],
                ),
              );
              if (confirm ?? false) {
                // Llama a tu método para eliminar aquí si usas Provider o DBHelper
                await DBHelper.eliminarProducto(producto.id);
                if (onEliminado != null) onEliminado!();
              }
            },
          ),
        ],
      ),
    );
  }
}
