import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProviderService extends ChangeNotifier {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test"; 
  final String _pass = "test2023";  

  List<dynamic> _providers = [];

  List<dynamic> get providers => _providers;

 
  Future<List<dynamic>> getProviders() async {
    final response = await http.get(
      Uri.http(_baseUrl, 'ejemplos/provider_list_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      if (decodedResponse.containsKey('Proveedores Listado')) {
        _providers = decodedResponse['Proveedores Listado'];
        notifyListeners();
        return _providers;
      } else {
        throw Exception('Clave "Proveedores Listado" no encontrada en la respuesta');
      }
    } else {
      throw Exception('Error al cargar proveedores. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> addProvider(String name, String lastname, String email, String state) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/provider_add_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'provider_name': name,
        'provider_lastname': lastname,
        'provider_mail': email,
        'provider_state': state, 
      }),
    );

    if (response.statusCode == 200) {
      await getProviders();
    } else {
      throw Exception('Error al agregar proveedor. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> editProvider(int id, String name, String lastname, String email, String state) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'provider_id': id,
        'provider_name': name,
        'provider_lastname': lastname,
        'provider_mail': email,
        'provider_state': state, 
      }),
    );

    if (response.statusCode == 200) {
      await getProviders();
    } else {
      throw Exception('Error al editar proveedor. Código de estado: ${response.statusCode}');
    }
  }

  
  Future<void> deleteProvider(int id) async {
    final response = await http.post(
      Uri.http(_baseUrl, 'ejemplos/provider_del_rest/'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'provider_id': id,
      }),
    );

    if (response.statusCode == 200) {
      await getProviders();
    } else {
      throw Exception('Error al eliminar proveedor. Código de estado: ${response.statusCode}');
    }
  }
}
