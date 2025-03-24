import 'package:flutter/material.dart';
import '../models/producto.dart';

class CarritoProvider with ChangeNotifier {
  final List<Producto> _carrito = [];

  List<Producto> get carrito => _carrito;

  void agregarProducto(Producto producto) {
    _carrito.add(producto);
    notifyListeners();
  }

  void eliminarProducto(Producto producto) {
    _carrito.remove(producto);
    notifyListeners();
  }

  void vaciarCarrito() {
    _carrito.clear();
    notifyListeners();
  }

  double get total => _carrito.fold(0, (sum, item) => sum + item.precio);
}
