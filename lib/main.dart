import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype_demo/pages/main_page.dart';
import 'cubit/mata_air_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MataAirCubit()..loadMataAir(),
      child: MaterialApp(
        title: 'Mata Air App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MataAirListScreen(),
      ),
    );
  }
}
