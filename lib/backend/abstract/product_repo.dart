import 'package:wow_shopping/models/product_item.dart';

abstract class AbstractProductsRepo {
  List<ProductItem> get cachedItems;

  Future<List<ProductItem>> fetchTopSelling();

  ProductItem findProduct(String id);
}
