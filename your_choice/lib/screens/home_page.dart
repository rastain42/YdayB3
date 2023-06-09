import 'package:flutter/material.dart';
import 'package:your_choice/entities/product.dart';
import 'package:your_choice/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../entities/basket.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  static const path = '/home';

  final bool needUpdate = true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SkateShop"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () => context.go('/home/user'),
              icon: const Icon(Icons.account_circle, size: 40),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton(
            onPressed: () => context.go('/home/basket'),
            icon: const Icon(Icons.add_shopping_cart, size: 40),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ref.watch(productsProvider).when(data: (products) {
              return SizedBox(
                width: 900,
                height: 700,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.network(products[index].image),
                            Text(products[index].name),
                            Text(products[index].category),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    ref
                                        .watch(productBasketProvider.notifier)
                                        .addProduct(newProduct: products[index], user: ref.watch(userProvider));
                                  },
                                  child: const Text("add to panier"),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    // context.go('/home/user',{});
                                  },
                                  child: const Text("Voir détails"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }, loading: () {
              return const CircularProgressIndicator();
            }, error: (error, stack) {
              return Text('$error\n$stack');
            }),
            ElevatedButton(
              onPressed: () {
                ref.watch(userProvider.notifier).logout();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
