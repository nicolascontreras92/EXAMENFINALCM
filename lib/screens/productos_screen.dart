import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/product_service.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay productos disponibles'));
                }

                final products = snapshot.data!;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final String estado = product['product_state'] == 'Activo' ? 'Activo' : 'Inactivo';

                    return ListTile(
                      title: Text(product['product_name']),
                      subtitle: Text(
                        'Precio: \$${product['product_price']}\n'
                        'Estado: $estado\n'
                        'Imagen: ${product['product_image'] ?? 'Sin imagen'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await productService.deleteProduct(product['product_id']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Producto eliminado')),
                                );
                                Navigator.pushReplacementNamed(context, 'productos');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al eliminar producto: $e')),
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
                                  final editNameController = TextEditingController(text: product['product_name']);
                                  final editPriceController = TextEditingController(text: product['product_price'].toString());
                                  final editImageController = TextEditingController(text: product['product_image']);

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Editar Producto'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: editNameController,
                                              decoration: const InputDecoration(labelText: 'Nombre'),
                                            ),
                                            TextField(
                                              controller: editPriceController,
                                              decoration: const InputDecoration(labelText: 'Precio'),
                                              keyboardType: TextInputType.number,
                                            ),
                                            TextField(
                                              controller: editImageController,
                                              decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                await productService.editProduct(
                                                  product['product_id'],
                                                  editNameController.text,
                                                  editPriceController.text,
                                                  editImageController.text,
                                                );

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Producto editado correctamente')),
                                                );
                                                Navigator.pop(context);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error al editar producto: $e')),
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
                    final newPriceController = TextEditingController();
                    final newImageController = TextEditingController();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Agregar Nuevo Producto'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: newNameController,
                                decoration: const InputDecoration(labelText: 'Nombre'),
                              ),
                              TextField(
                                controller: newPriceController,
                                decoration: const InputDecoration(labelText: 'Precio'),
                                keyboardType: TextInputType.number,
                              ),
                              TextField(
                                controller: newImageController,
                                decoration: const InputDecoration(labelText: 'URL de la Imagen'),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await productService.addProduct(
                                    newNameController.text,
                                    newPriceController.text,
                                    newImageController.text,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Producto agregado correctamente')),
                                  );

                                    
                                     await Future.delayed(const Duration(milliseconds: 500));
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al agregar producto: $e')),
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
              child: const Text('Agregar Producto'),
            ),
          ),
        ],
      ),
    );
  }
}
