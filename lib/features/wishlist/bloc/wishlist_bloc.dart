import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/product_item.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepo _repository;
  WishlistBloc(WishlistRepo repository)
      : _repository = repository,
        super(const WishlistState()) {
    on<WishlistStreamRequested>(_onStreamRequested);
    on<WishlistItemSelectToggled>(_onSelectToggled);
    on<WishlistSelectAllToggled>(_onSelectAllToggled);
    on<WishlistRemoveSelected>(_onRemoveSelected);
  }

  Future<void> _onRemoveSelected(
    WishlistRemoveSelected event,
    Emitter<WishlistState> emit,
  ) async {
    for (final productId in state.selectedItems) {
      _repository.removeToWishlist(productId);
    }

    emit(state.copyWith(selectedItems: () => {}));
  }

  Future<void> _onSelectAllToggled(
    WishlistSelectAllToggled event,
    Emitter<WishlistState> emit,
  ) async {
    final allIds = state.wishlistItems.map((x) => x.id).toList();

    if (state.selectedItems.containsAll(allIds)) {
      emit(state.copyWith(selectedItems: () => {}));
    } else {
      emit(state.copyWith(selectedItems: () => allIds.toSet()));
    }
  }

  Future<void> _onSelectToggled(
    WishlistItemSelectToggled event,
    Emitter<WishlistState> emit,
  ) async {
    final selectedItems = Set<String>.from(state.selectedItems);
    if (event.selected) {
      selectedItems.add(event.id);
    } else {
      selectedItems.remove(event.id);
    }
    emit(state.copyWith(selectedItems: () => selectedItems));
  }

  Future<void> _onStreamRequested(
    WishlistStreamRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(status: () => WishlistStatus.loading));

    await emit.forEach<List<ProductItem>>(
      _repository.streamWishlistItems,
      onData: (items) => state.copyWith(
        status: () => WishlistStatus.success,
        wishlistItems: () => items,
      ),
      onError: (_, __) => state.copyWith(
        status: () => WishlistStatus.failure,
      ),
    );
  }
}
