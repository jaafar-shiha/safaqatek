import 'package:flutter/cupertino.dart';
import 'package:safaqtek/models/Products/product.dart';

class CartProductsProvider with ChangeNotifier{

  final List<Product> _cartProducts = [];

  List<Product> get cartProducts => _cartProducts;

  bool get isCartEmpty => _cartProducts.isEmpty;

  int _getProductsCountInCart = 0;

  int get getProductsCountInCart => _getProductsCountInCart;

  void changeProductsCountInCart(int addedProducts){
    _getProductsCountInCart += addedProducts;
    notifyListeners();
  }

  bool _isDonate = false;

  bool get isDonate => _isDonate;

  set isDonate(bool isDonate){
    _isDonate = isDonate;
    notifyListeners();
  }

  int _total = 0;

  int get total => _total;


  void setTotal(int newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  void addProductToCart({required Product product}){
    try{
      Product cartProduct = _cartProducts.singleWhere((element) => element.id == product.id);
      cartProduct.countOfThisProductInCart  += 1;
      setTotal(_total+cartProduct.price);
      changeProductsCountInCart(1);
    }
    catch (_){
      _cartProducts.add(product.copyWith(countOfThisProductInCart: 1));
      setTotal(_total+product.price);
      changeProductsCountInCart(1);
    }
    notifyListeners();
  }

  void removeProductFromCart({required Product product}){
    Product cartProduct = _cartProducts.singleWhere((element) => element.id == product.id);
    if (cartProduct.countOfThisProductInCart >1){
      cartProduct.countOfThisProductInCart -= 1;
      setTotal(_total-cartProduct.price);
      changeProductsCountInCart(-1);
    }
    else{
      _cartProducts.removeWhere((element) => product.id == element.id);
      setTotal(_total-cartProduct.price);
      changeProductsCountInCart(-1);

    }
    notifyListeners();
  }

  void clear(){
    _cartProducts.clear();
    _getProductsCountInCart = 0;
    _isDonate = false;
    _total = 0;
    notifyListeners();
  }
}