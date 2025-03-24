import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> initDB() async {
    final pathDB = await getDatabasesPath();
    final path = join(pathDB, 'productos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            imagen TEXT,
            precio REAL
          )
        ''');
      },
    );
  }

  static Future<void> insertarProducto(String nombre, String imagen, double precio) async {
    final db = await initDB();
    await db.insert('productos', {
      'nombre': nombre,
      'imagen': imagen,
      'precio': precio,
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerProductos() async {
    final db = await initDB();
    return await db.query('productos');
  }

  static Future<void> eliminarProducto(int id) async {
    final db = await initDB();
    await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> eliminarTodos() async {
    final db = await initDB();
    await db.delete('productos');
  }
}
