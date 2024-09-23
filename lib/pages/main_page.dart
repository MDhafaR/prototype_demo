import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prototype_demo/cubit/product_cubit.dart';
import 'package:prototype_demo/services/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController productController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    context.read<ProductCubit>().getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save Data And Sync"),
        actions: [
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.sync),
            onPressed: () async {
              final isOnline = await checkConnection();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isOnline ? "Syncing..." : "No internet"),
              ));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Product",
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            Text(
              "Price",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Price",
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  minimumSize: WidgetStatePropertyAll(Size(100, 50)),
                ),
                onPressed: () async {
                  print(
                      "ini po ${priceController.text} ${productController.text}");
                  await context.read<ProductCubit>().insert(
                      productController.text,
                      double.parse(priceController.text));
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text("Product List"),
                      Divider(),
                      BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          if (state is ProductLoaded) {
                            final products = state.products;
                            print("products: $products");
                            if (products != null && products.isNotEmpty) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  final product = products[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        title: Text(product.name),
                                        subtitle:
                                            Text(product.price.toString()),
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text("No Products Available"),
                              );
                            }
                          } else if (state is ProductInitial) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ProductEmpty) {
                            return Center(
                              child: Text("No Products Available"),
                            );
                          } else {
                            return Center(
                              child: Text("No Products Available"),
                            );
                          }
                        },
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
