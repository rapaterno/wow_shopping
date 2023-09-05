import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/abstract/product_repo.dart';
import 'package:wow_shopping/backend/abstract/wishlist_repo.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';

void setupDi() {
  di.registerSingletonAsync<AbstractProductsRepo>(() => ProductsRepo().init());
  di.registerSingletonAsync<CartRepo>(() => CartRepo().init());
  di.registerSingletonAsync<AbstractWishlistRepo>(() => WishlistRepo().init(),
      dependsOn: [AbstractProductsRepo]);
  di.registerSingletonAsync<ApiService>(
      () async => ApiService(() async => '123'));
  di.registerSingletonAsync<AuthRepo>(() => AuthRepo().init(),
      dependsOn: [ApiService]);
}
