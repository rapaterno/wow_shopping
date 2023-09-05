import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/abstract/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

class ProductsRepo implements AbstractProductsRepo {
  late final List<ProductItem> _products;

  @override
  List<ProductItem> get cachedItems => List.of(_products);

  Future<ProductsRepo> init() async {
    try {
      final data = json.decode(
        await rootBundle.loadString(Assets.productsData),
      );
      final products = (data['products'] as List) //
          .cast<Map>()
          .map(ProductItem.fromJson)
          .toList();
      _products = products;
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
    return this;
  }

  @override
  Future<List<ProductItem>> fetchTopSelling() async {
    //await Future.delayed(const Duration(seconds: 3));
    return List.unmodifiable(_products); // TODO: filter to top-selling only
  }

  /// Find product from the top level products cache
  ///
  /// [id] for the product to fetch.
  @override
  ProductItem findProduct(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
      orElse: () => ProductItem.none,
    );
  }
}
