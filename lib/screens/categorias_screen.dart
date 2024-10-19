import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/category_service.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryService = Provider.of<CategoryService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: categoryService.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay categorías disponibles'));
                }

                final categories = snapshot.data!;

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final String estado = category['category_state'] == 'Activa' ? 'Activo' : 'Inactivo';

                    return ListTile(
                      title: Text(category['category_name']),
                      subtitle: Text('Estado: $estado'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await categoryService.deleteCategory(category['category_id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Categoría eliminada')),
                                );
                                Navigator.pushReplacementNamed(context, 'categorias');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al eliminar categoría: $e')),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  final editNameController = TextEditingController(text: category['category_name']);
                                  String selectedState = category['category_state']; 

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Editar Categoría'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: editNameController,
                                              decoration: const InputDecoration(labelText: 'Nombre'),
                                            ),
                                            const SizedBox(height: 20),
                                            DropdownButton<String>(
                                              value: selectedState,
                                              items: <String>['Activa', 'Inactiva']
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  selectedState = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await categoryService.editCategory(
                                                  category['category_id'],
                                                  editNameController.text,
                                                  selectedState,
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Categoría editada correctamente')),
                                                );
                                                Navigator.pop(context);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error al editar categoría: $e')),
                                                );
                                              }
                                            },
                                            child: const Text('Guardar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final newNameController = TextEditingController();
                    String selectedState = 'Activa'; 

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Agregar Nueva Categoría'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: newNameController,
                                decoration: const InputDecoration(labelText: 'Nombre'),
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value: selectedState,
                                items: <String>['Activa', 'Inactiva']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedState = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await categoryService.addCategory(
                                    newNameController.text,
                                    selectedState,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Categoría agregada correctamente')),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al agregar categoría: $e')),
                                  );
                                }
                              },
                              child: const Text('Agregar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Agregar Categoría'),
            ),
          ),
        ],
      ),
    );
  }
}
