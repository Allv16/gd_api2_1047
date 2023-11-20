import 'package:flutter/material.dart';

import 'package:gd_api_1047/client/BarangClient.dart';
import 'package:gd_api_1047/entity/Barang.dart';
import 'package:gd_api_1047/pages/Homepage.dart';

class EditBarang extends StatefulWidget {
  const EditBarang({super.key, this.id});
  final int? id;

  @override
  State<EditBarang> createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  bool isLoading = false;

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      Barang res = await BarangClient.find(widget.id);
      setState(() {
        isLoading = false;
        nameController.value = TextEditingValue(text: res.nama);
        descriptionController.value = TextEditingValue(text: res.deskripsi);
        stockController.value = TextEditingValue(text: res.stok.toString());
      });
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.red);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    void onSubmit() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      Barang input = Barang(
          id: widget.id ?? 0,
          nama: nameController.text,
          deskripsi: descriptionController.text,
          stok: stockController.text);

      try {
        if (widget.id == null) {
          await BarangClient.create(input);
        } else {
          await BarangClient.update(input);
        }

        showSnackBar(context, 'Success', Colors.green);
        Navigator.pop(context);
      } catch (err) {
        showSnackBar(context, err.toString(), Colors.red);
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Tambah Barang' : 'Edit Barang'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Masukkan nama',
                        ),
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Masukkan deskripsi',
                        ),
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Masukkan stok',
                        ),
                        controller: stockController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field required';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        child: Text(widget.id == null ? 'Tambah' : 'Edit'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
