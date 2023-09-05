part of 'wishlist_bloc.dart';

@immutable
sealed class WishlistEvent {}

class WishlistStreamRequested extends WishlistEvent {}

class WishlistSelectAllToggled extends WishlistEvent {}

class WishlistItemSelectToggled extends WishlistEvent {
  final String id;
  final bool selected;

  WishlistItemSelectToggled({
    required this.id,
    required this.selected,
  });
}

class WishlistRemoveSelected extends WishlistEvent {}
