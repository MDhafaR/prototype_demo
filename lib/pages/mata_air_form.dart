import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/mata_air_cubit.dart';
import '../models/mata_air.dart';

class MataAirFormScreen extends StatefulWidget {
  final MataAir? mataAir;

  MataAirFormScreen({this.mataAir});

  @override
  _MataAirFormScreenState createState() => _MataAirFormScreenState();
}

class _MataAirFormScreenState extends State<MataAirFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _kotaController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.mataAir?.nama ?? '');
    _kotaController = TextEditingController(text: widget.mataAir?.kota ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mataAir == null ? 'Tambah Mata Air' : 'Edit Mata Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Mata Air'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kotaController,
                decoration: InputDecoration(labelText: 'Kota'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kota tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final mataAir = MataAir(
                      id: widget.mataAir?.id,
                      localId: widget.mataAir?.localId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                      nama: _namaController.text,
                      kota: _kotaController.text,
                      isSync: false,
                      lastModified: DateTime.now().toIso8601String(),
                    );

                    if (widget.mataAir == null) {
                      context.read<MataAirCubit>().addMataAir(mataAir);
                    } else {
                      context.read<MataAirCubit>().updateMataAir(mataAir);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kotaController.dispose();
    super.dispose();
  }
}