import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype_demo/pages/mata_air_form.dart';
import '../cubit/mata_air_cubit.dart';
import '../cubit/mata_air_state.dart';

class MataAirListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Mata Air'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              context.read<MataAirCubit>().syncMataAir();
            },
          ),
        ],
      ),
      body: BlocBuilder<MataAirCubit, MataAirState>(
        builder: (context, state) {
          if (state is MataAirLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MataAirLoaded) {
            return ListView.builder(
              itemCount: state.mataAirList.length,
              itemBuilder: (context, index) {
                final mataAir = state.mataAirList[index];
                return Card(
                  color: mataAir.isSync ? Colors.white : Colors.grey[300],
                  child: ListTile(
                    title: Text(mataAir.nama),
                    subtitle: Text(mataAir.kota),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context
                            .read<MataAirCubit>()
                            .deleteMataAir(mataAir.localId);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MataAirFormScreen(mataAir: mataAir),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is MataAirError) {
            return Center(child: Text(state.message));
          }
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Wait for loading...'),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MataAirFormScreen(),
            ),
          );
        },
      ),
    );
  }
}
