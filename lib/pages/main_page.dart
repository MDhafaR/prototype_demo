import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Save Data And Sync"),
          actions: [
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.sync),
              onPressed: () {},
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
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Product",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Price",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Price",
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    minimumSize: WidgetStatePropertyAll(Size(100, 50)),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    )
                  ),
                  child: Column(children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Text("Product List"),
                    Divider(),
                    Expanded(
                      child: ListView(children: [
                        ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue),
                          ),
                          title: Text("Product 1"),
                          subtitle: Text("20.000"),
                        )
                      ],),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],),
                ),
              )
            ],
          ),
        ));
  }
}
