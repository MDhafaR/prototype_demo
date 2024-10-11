import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:high_q_paginated_drop_down/high_q_paginated_drop_down.dart';
import 'package:prototype_demo/cubit/nama_balai_cubit.dart';
import 'package:prototype_demo/models/nama_balai.dart';

class NamaBalaiDropdown extends StatelessWidget {
  final Function(NamaBalai?) onChanged;

  const NamaBalaiDropdown({Key? key, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NamaBalaiCubit, NamaBalaiState>(
      builder: (context, state) {
        return HighQPaginatedDropdown<NamaBalai>.paginated(
          hintText: const Text('Search Nama Balai'),
          searchHintText: 'Search for Nama Balai',
          paginatedRequest: (int page, String? searchText) async {
            return await context
                .read<NamaBalaiCubit>()
                .getPaginatedNamaBalai(page, searchText);
          },
          backgroundDecoration: (child) {
            return InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelText: 'Nama Balai',
              ),
              child: child,
            );
          },
          loadingWidget: const CircularProgressIndicator(
            color: Colors.green,
          ),
          padding: const EdgeInsets.all(0),
          hasTrailingClearIcon: true,
          searchDelayDuration: const Duration(milliseconds: 800),
          spaceBetweenDropDownAndItemsDialog: 10,
          isEnabled: true,
          onTapWhileDisableDropDown: () {},
          dropDownMaxHeight: 200,
          isDialogExpanded: true,
          paddingValueWhileIsDialogExpanded: 16,
          onChanged: onChanged,
        );
      },
    );
  }
}
