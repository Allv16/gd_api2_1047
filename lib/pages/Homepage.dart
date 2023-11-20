import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gd_api_1047/client/BarangClient.dart';
import 'package:gd_api_1047/entity/Barang.dart';
import 'package:gd_api_1047/pages/EditBarang.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final listBarangProvider = FutureProvider<List<Barang>>((ref) async {
    return await BarangClient.fetchAll();
  });

  void onAdd(context, ref) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const EditBarang()))
        .then((value) => ref.refresh(listBarangProvider));
  }

  void onDelete(id, context, ref) async {
    try {
      await BarangClient.destroy(id);
      ref.refresh(listBarangProvider);
      showSnackBar(context, 'Data berhasil dihapus', Colors.green);
      ref.refresh(listBarangProvider);
    } catch (err) {
      showSnackBar(context, err.toString(), Colors.red);
    }
  }

  ListTile scrollViewItem(Barang b, context, ref) => ListTile(
        title: Text(b.nama),
        subtitle: Text(b.deskripsi),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditBarang(
                      id: b.id,
                    ))).then((value) => ref.refresh(listBarangProvider)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onDelete(b.id, context, ref),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listBarangProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('GD API 1047'),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => onAdd(context, ref),
        ),
        body: listener.when(
          data: (data) => SingleChildScrollView(
              child: Column(
            children: data.map((e) => scrollViewItem(e, context, ref)).toList(),
          )),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(
            child: Text(err.toString()),
          ),
        ));
  }
}

void showSnackBar(BuildContext context, String text, Color color) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: color,
    action:
        SnackBarAction(label: 'hide', onPressed: scaffold.hideCurrentSnackBar),
  ));
}
