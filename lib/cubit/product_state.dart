part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<Product>? products;

  const ProductLoaded(this.products);
}

final class ProductEmpty extends ProductState {}

