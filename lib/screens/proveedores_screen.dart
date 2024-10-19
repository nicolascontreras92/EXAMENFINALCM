import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_nicolascontreras/services/provider_service.dart';

class ProveedoresScreen extends StatelessWidget {
  const ProveedoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final providerService = Provider.of<ProviderService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: providerService.getProviders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay proveedores disponibles'));
                }

                final providers = snapshot.data!;

                return ListView.builder(
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    final String estado = provider['provider_state'] == 'Activo' ? 'Activo' : 'Inactivo';

                    return ListTile(
                      title: Text('${provider['provider_name']} ${provider['provider_last_name']}'),
                      subtitle: Text(
                        'Correo: ${provider['provider_mail']}\n'
                        'Estado: $estado',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await providerService.deleteProvider(provider['providerid']);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Proveedor eliminado')),
                                );
                                Navigator.pushReplacementNamed(context, 'proveedores');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error al eliminar proveedor: $e')),
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
                                  final editNameController = TextEditingController(text: provider['provider_name']);
                                  final editLastnameController = TextEditingController(text: provider['provider_last_name']);
                                  final editEmailController = TextEditingController(text: provider['provider_mail']);
                                  String selectedState = provider['provider_state'];

                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        title: const Text('Editar Proveedor'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: editNameController,
                                              decoration: const InputDecoration(labelText: 'Nombre'),
                                            ),
                                            TextField(
                                              controller: editLastnameController,
                                              decoration: const InputDecoration(labelText: 'Apellido'),
                                            ),
                                            TextField(
                                              controller: editEmailController,
                                              decoration: const InputDecoration(labelText: 'Correo'),
                                            ),
                                            const SizedBox(height: 20),
                                            DropdownButton<String>(
                                              value: selectedState,
                                              items: <String>['Activo', 'Inactivo'].map((String value) {
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
                                                await providerService.editProvider(
                                                  provider['providerid'],
                                                  editNameController.text,
                                                  editLastnameController.text,
                                                  editEmailController.text,
                                                  selectedState,
                                                );

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Proveedor editado correctamente')),
                                                );
                                                Navigator.pop(context);
                                              } catch (e) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error al editar proveedor: $e')),
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
                    final newLastnameController = TextEditingController();
                    final newEmailController = TextEditingController();
                    String selectedState = 'Activo';

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Agregar Nuevo Proveedor'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: newNameController,
                                decoration: const InputDecoration(labelText: 'Nombre'),
                              ),
                              TextField(
                                controller: newLastnameController,
                                decoration: const InputDecoration(labelText: 'Apellido'),
                              ),
                              TextField(
                                controller: newEmailController,
                                decoration: const InputDecoration(labelText: 'Correo'),
                              ),
                              const SizedBox(height: 20),
                              DropdownButton<String>(
                                value: selectedState,
                                items: <String>['Activo', 'Inactivo'].map((String value) {
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
                                  await providerService.addProvider(
                                    newNameController.text,
                                    newLastnameController.text,
                                    newEmailController.text,
                                    selectedState,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Proveedor agregado correctamente')),
                                  );
                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al agregar proveedor: $e')),
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
              child: const Text('Agregar Proveedor'),
            ),
          ),
        ],
      ),
    );
  }
}
