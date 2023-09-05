import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:wow_shopping/features/wishlist/widgets/wishlist_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late WishlistBloc bloc;
  @override
  void initState() {
    bloc = WishlistBloc(context.wishlistRepo)..add(WishlistStreamRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: const WishlistView(),
    );
  }
}

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistItems =
        context.select((WishlistBloc bloc) => bloc.state.wishlistItems);
    final selectedItems =
        context.select((WishlistBloc bloc) => bloc.state.selectedItems);
    return SizedBox.expand(
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopNavBar(
              title: const Text('Wishlist'),
              actions: [
                TextButton(
                  onPressed: () => context
                      .read<WishlistBloc>()
                      .add(WishlistSelectAllToggled()),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Select All'),
                ),
              ],
            ),
            Expanded(
              child: MediaQuery.removeViewPadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  padding: verticalPadding12,
                  itemCount: wishlistItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = wishlistItems[index];
                    return Padding(
                      padding: verticalPadding12,
                      child: WishlistItem(
                        item: item,
                        onPressed: (item) {
                          // FIXME: navigate to product details
                        },
                        selected: selectedItems.contains(item.id),
                        onToggleSelection: (item, isSelected) =>
                            context.read<WishlistBloc>().add(
                                  WishlistItemSelectToggled(
                                    id: item.id,
                                    selected: isSelected,
                                  ),
                                ),
                      ),
                    );
                  },
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              alignment: Alignment.topCenter,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: selectedItems.isEmpty ? 0.0 : 1.0,
                child: AppPanel(
                  padding: allPadding24,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            context
                                .read<WishlistBloc>()
                                .add(WishlistRemoveSelected());
                          },
                          label: 'Remove',
                          iconAsset: Assets.iconRemove,
                        ),
                      ),
                      horizontalMargin16,
                      Expanded(
                        child: AppButton(
                          onPressed: () {
                            // FIXME: implement Buy Now button
                          },
                          label: 'Buy now',
                          iconAsset: Assets.iconBuy,
                          style: AppButtonStyle.highlighted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
