import 'package:dummy_e_commerce/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/remote_config_provider.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<void>? _loadProductsFuture;

  @override
  void initState() {
    super.initState();
    _loadProductsFuture = _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await productProvider.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
             await   authProvider.logout(context);

          
            
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
        future: _loadProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products'));
          }

          return Consumer<ProductProvider>(
            builder: (context, productProvider, _) {
              if (productProvider.products.isEmpty) {
                return const Center(child: Text('No products available'));
              }

              return ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (context, index) {
                  final product = productProvider.products[index];
                  final showDiscountedPrice =
                      Provider.of<RemoteConfigProvider>(context)
                          .showDiscountedPrice;

                  final originalPrice = product.price ?? 0;
                  final discountedPrice = product.price! *
                      (1 - (product.discountPercentage! / 100));

                  return ListTile(
                    leading: Image.network(product.images?.first ?? ""),
                    title: Text(product.title ?? ""),
                    subtitle: Text(product.description ?? ""),
                    trailing: showDiscountedPrice
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Strikethrough for the original price
                              Text(
                                '\$${originalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red,
                                ),
                              ),
                              // Discounted price
                              Text(
                                '\$${discountedPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '\$${originalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
