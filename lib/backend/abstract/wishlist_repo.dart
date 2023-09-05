import 'package:wow_shopping/models/product_item.dart';

abstract class AbstractWishlistRepo {
  List<ProductItem> get currentWishlistItems;

  Stream<List<ProductItem>> get streamWishlistItems;

  bool isInWishlist(ProductItem item);

  Stream<bool> streamIsInWishlist(ProductItem item);

  void addToWishlist(String productId);

  void removeToWishlist(String productId);
}
