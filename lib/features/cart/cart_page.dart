import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/features/cart/checkout_page.dart';
import 'package:wow_shopping/features/cart/widgets/cart_item.dart';
import 'package:wow_shopping/features/cart/widgets/cart_page_layout.dart';
import 'package:wow_shopping/features/cart/widgets/checkout_panel.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

final currentCartProvider = StreamProvider<List<CartItem>>((ref) async* {
  final cartRepo = ref.watch(cartRepoProvider);

  final stream = cartRepo.streamCartItems;

  yield [];

  await for (final items in stream) {
    yield items;
  }
});

@immutable
class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCart = ref.watch(currentCartProvider);

    return Material(
      child: CartPageLayout(
        checkoutPanel: CheckoutPanel(
          onPressed: () {
            Navigator.of(context).push(CheckoutPage.route());
          },
          label: 'Checkout',
        ),
        content: currentCart.when(
            data: (items) => CustomScrollView(
                  slivers: [
                    SliverTopNavBar(
                      title: items.isEmpty
                          ? const Text('No items in your cart')
                          : Text('${items.length} items in your cart'),
                      pinned: true,
                      floating: true,
                    ),
                    const SliverToBoxAdapter(
                      child: _DeliveryAddressCta(
                          // FIXME: onChangeAddress ?
                          ),
                    ),
                    if (items.isEmpty)
                      const SliverToBoxAdapter(
                          child: Center(child: Text('No items in your cart'))),
                    for (final item in items) //
                      SliverCartItemView(
                        key: Key(item.product.id),
                        item: item,
                      ),
                  ],
                ),
            error: (_, __) => const Center(child: Text('error')),
            loading: () => const Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

@immutable
class _DeliveryAddressCta extends StatelessWidget {
  const _DeliveryAddressCta();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: horizontalPadding12 + verticalPadding16,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Delivery to '),
                      TextSpan(
                        // FIXME: replace with selected address name
                        text: 'Designer Techcronus',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalMargin4,
                // FIXME: replace with selected address
                Text(
                  '4/C Center Point,Panchvati, '
                  'Ellisbridge, Ahmedabad, Gujarat 380006',
                ),
              ],
            ),
          ),
          AppButton(
            onPressed: () {
              // FIXME open Delivery address screen
            },
            style: AppButtonStyle.outlined,
            label: 'Change',
          ),
        ],
      ),
    );
  }
}
