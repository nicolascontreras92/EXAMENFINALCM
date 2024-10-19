import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryService extends ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  List<dynamic> _categories = [];

  List<dynamic> get categories => _categories;


  Future<List<dynamic>> getCategories() async {
    final response = await http.get(
      Uri.http(_baseUrl, 'ejemplos/category_list_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse.containsKey('Listado Categorias')) {
        _categories = decodedResponse['Listado Categorias'];
        notifyListeners();
        return _categories;
      } else {
        throw Exception('Clave "Listado Categorias" no encontrada en la respuesta');
      }
    } else {
      throw Exception('Error al cargar categorías. Código de estado: ${response.statusCode}');
    }
  }

  Future<void> addCategory(String name, String state) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/category_add_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'category_name': name,
        'category_state': state, 
      }),
    );

    if (response.statusCode == 200) {
      await getCategories();
    } else {
      throw Exception('Error al agregar categoría. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> editCategory(int id, String name, String state) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/category_edit_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'category_id': id,
        'category_name': name,
        'category_state': state, 
      }),
    );

    if (response.statusCode == 200) {
      await getCategories();
    } else {
      throw Exception('Error al editar categoría. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> deleteCategory(int id) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/category_del_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'category_id': id,
      }),
    );

    if (response.statusCode == 200) {
      await getCategories();
    } else {
      throw Exception('Error al eliminar categoría. Código de estado: ${response.statusCode}');
    }
  }
}
