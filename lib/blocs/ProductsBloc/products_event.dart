import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class GetProducts extends ProductsEvent{
  final int prizeTypeId;

  const GetProducts({required this.prizeTypeId});

  @override
  List<Object?> get props => [];
}

class GetImagesSlider extends ProductsEvent{

  const GetImagesSlider();

  @override
  List<Object?> get props => [];
}

class AddProductToFavorite extends ProductsEvent{
  final int id;
  const AddProductToFavorite({required this.id});

  @override
  List<Object?> get props => [];
}

class RemoveProductFromFavorite extends ProductsEvent{
  final int id;
  const RemoveProductFromFavorite({required this.id});

  @override
  List<Object?> get props => [];
}

class GetSoldOutProducts extends ProductsEvent{

  const GetSoldOutProducts();

  @override
  List<Object?> get props => [];
}

class GetClosingSoonProducts extends ProductsEvent{

  const GetClosingSoonProducts();

  @override
  List<Object?> get props => [];
}

class GetWinners extends ProductsEvent{

  const GetWinners();

  @override
  List<Object?> get props => [];
}

class GetFavoriteProducts extends ProductsEvent{

  const GetFavoriteProducts();

  @override
  List<Object?> get props => [];
}

