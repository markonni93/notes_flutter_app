import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/remote/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductLoadingState()) {
    on<GetProductEvent>((state, emit) async {
      try {
        print("fetching prodcuts");
        await _repository.fetchProducts();
        emit(ProductSuccessState());
      } catch (e) {
        emit(ProductErrorState());
      }
    });
  }
}

sealed class ProductState {}

class ProductLoadingState extends ProductState {}

class ProductSuccessState extends ProductState {}

class ProductErrorState extends ProductState {}

sealed class ProductEvent {}

class GetProductEvent extends ProductEvent {}
