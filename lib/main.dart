import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype_demo/cubit/nama_balai_cubit.dart';
import 'package:prototype_demo/models/nama_balai.dart';
import 'package:prototype_demo/pages/nama_balai_dropdown.dart';
import 'package:prototype_demo/services/local_nama_balai.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Nama Balai Dropdown')),
        body: BlocProvider(
          create: (context) => NamaBalaiCubit(LocalNamaBalai()),
          child: NamaBalaiDropdown(
            onChanged: (NamaBalai? selectedNamaBalai) {
              if (selectedNamaBalai != null) {
                print('Selected Nama Balai: ${selectedNamaBalai.nama}');
              }
            },
          ),
        ),
      ),
    );
  }
}

