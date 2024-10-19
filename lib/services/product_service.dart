import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductService extends ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";  
  final String _pass = "test2023";  

  List<dynamic> _products = [];

  List<dynamic> get products => _products;

  
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.http(_baseUrl, 'ejemplos/product_list_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse.containsKey('Listado')) {
        _products = decodedResponse['Listado'];
        notifyListeners();
        return _products;
      } else {
        throw Exception('Clave "Listado" no encontrada en la respuesta');
      }
    } else {
      throw Exception('Error al cargar productos. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> addProduct(String name, String price, String image) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/product_add_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_name': name,
        'product_price': price,
        'product_image': image,
        'product_state': 'Activo', 
      }),
    );

    if (response.statusCode == 200) {
      await getProducts();
    } else {
      throw Exception('Error al agregar producto. Código de estado: ${response.statusCode}');
    }
  }

 
  Future<void> editProduct(int id, String name, String price, String image) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/product_edit_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': id,
        'product_name': name,
        'product_price': price,
        'product_image': image,
        'product_state': 'Activo', 
      }),
    );

    if (response.statusCode == 200) {
      await getProducts();
    } else {
      throw Exception('Error al editar producto. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> deleteProduct(int id) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/product_del_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'product_id': id,
      }),
    );

    if (response.statusCode == 200) {
      await getProducts();
    } else {
      throw Exception('Error al eliminar producto. Código de estado: ${response.statusCode}');
    }
  }
}
