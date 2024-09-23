import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prototype_demo/models/product.dart';
import 'package:prototype_demo/services/local_database.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());
  LocalDatabase localDatabase = LocalDatabase();

  Future<void> getAll() async {
    emit(ProductInitial());

    final result = await localDatabase.getAll();
    if (result.isNotEmpty) {
      try {
        emit(ProductLoaded(result));
        print("getAll: $result");
      } catch (e) {
        print("error getAll: $e");
      }
    } else {
      emit(ProductEmpty());
    }
  }

  Future<void> insert(String productName, double price) async {
    emit(ProductInitial());
    print("insert: $productName, $price");
    await LocalDatabase().insert({
      'product': productName,
      'price': price,
    });

    emit(ProductLoaded(await localDatabase.getAll()));
  }
}
