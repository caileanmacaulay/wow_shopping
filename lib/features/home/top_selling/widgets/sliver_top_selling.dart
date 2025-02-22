import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/home/top_selling/bloc/bloc/top_selling_bloc.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/content_heading.dart';
import 'package:wow_shopping/widgets/product_card.dart';

@immutable
class SliverTopSelling extends StatefulWidget {
  const SliverTopSelling({super.key});

  @override
  State<SliverTopSelling> createState() => _SliverTopSellingState();
}

class _SliverTopSellingState extends State<SliverTopSelling> {
  // late Future<List<ProductItem>> _futureTopSelling;

  // @override
  // void initState() {
  //   super.initState();
  //   _futureTopSelling = productsRepo.fetchTopSelling();
  // }

  @override
  Widget build(BuildContext context) {
    //NB we send an Event ..add() on Bloc instance creation
    //analagous to the code we had in intiState()
    return BlocProvider(
      create: (context) => TopSellingBloc(productsRepo: context.productsRepo)
        ..add(TopSellingFetchRequested()),
      child: SliverTopSellingView(),
    );
  }
}

class SliverTopSellingView extends StatelessWidget {
  const SliverTopSellingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopSellingBloc, TopSellingState>(
      builder: (BuildContext context, state) {
        return switch (state) {
          TopSellingInitial() =>
            const SliverToBoxAdapter(child: SizedBox.shrink()),
          TopSellingLoading() => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          TopSellingError() => const SliverFillRemaining(
              child: Center(
                child: Text('There\'s been an error'),
              ),
            ),
          TopSellingLoaded(products: final products) =>
            TopSellingContent(products: products),
        };
      },
    );
  }
}

class TopSellingContent extends StatelessWidget {
  const TopSellingContent({
    super.key,
    required this.products,
  });

  final List<ProductItem> products;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: horizontalPadding8,
            child: ContentHeading(
              title: 'Top Selling Items',
              buttonLabel: 'Show All',
              onButtonPressed: () {
                // FIXME: show all top selling items
              },
            ),
          ),
          verticalMargin8,
          for (int index = 0; index < products.length; index += 2) ...[
            Builder(
              builder: (BuildContext context) {
                final item1 = products[index + 0];
                if (index + 1 < products.length) {
                  final item2 = products[index + 1];
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        horizontalMargin12,
                        Expanded(
                          child: ProductCard(
                            key: Key('top-selling-${item1.id}'),
                            item: item1,
                          ),
                        ),
                        horizontalMargin12,
                        Expanded(
                          child: ProductCard(
                            key: Key('top-selling-${item2.id}'),
                            item: item2,
                          ),
                        ),
                        horizontalMargin12,
                      ],
                    ),
                  );
                } else {
                  return Row(
                    children: [
                      horizontalMargin12,
                      Expanded(
                        child: ProductCard(
                          key: Key('top-selling-${item1.id}'),
                          item: item1,
                        ),
                      ),
                      horizontalMargin12,
                      const Spacer(),
                      horizontalMargin12,
                    ],
                  );
                }
              },
            ),
            verticalMargin12,
          ],
          verticalMargin48 + verticalMargin48,
        ],
      ),
    );
  }
}
