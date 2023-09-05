part of 'wishlist_bloc.dart';

enum WishlistStatus { initial, loading, success, failure }

final class WishlistState extends Equatable {
  const WishlistState(
      {this.status = WishlistStatus.initial,
      this.wishlistItems = const [],
      this.selectedItems = const {}});

  final WishlistStatus status;
  final List<ProductItem> wishlistItems;
  final Set<String> selectedItems;

  WishlistState copyWith({
    WishlistStatus Function()? status,
    List<ProductItem> Function()? wishlistItems,
    Set<String> Function()? selectedItems,
  }) {
    return WishlistState(
        status: status != null ? status() : this.status,
        wishlistItems:
            wishlistItems != null ? wishlistItems() : this.wishlistItems,
        selectedItems:
            selectedItems != null ? selectedItems() : this.selectedItems);
  }

  @override
  List<Object?> get props => [status, selectedItems, wishlistItems];
}
