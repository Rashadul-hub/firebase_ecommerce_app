import 'package:firebase_ecommerce_flutter/models/products-model.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as ProductsModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("User's View"),
        centerTitle: true,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
