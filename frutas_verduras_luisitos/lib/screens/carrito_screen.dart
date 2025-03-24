import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';

class CarritoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);
    final productos = carrito.carrito;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de compras'),
      ),
      body: productos.isEmpty
          ? Center(child: Text('Tu carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ListTile(
                        leading: Image.asset(
                          producto.imagen,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(producto.nombre),
                        subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            carrito.eliminarProducto(producto);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${carrito.total.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          carrito.vaciarCarrito();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Carrito vaciado')),
                          );
                        },
                        icon: Icon(Icons.delete_forever),
                        label: Text('Vaciar carrito'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
