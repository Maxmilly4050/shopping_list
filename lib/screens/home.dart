import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class HomeScreen extends StatelessWidget {
  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

  final grocery = groceryItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        children: grocery.map((item) =>
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                padding: const EdgeInsets.all(16.0),
                color: item.category.color,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  item.category.name,
                  style: TextStyle(fontSize: 20,),
                ),
              ),
              Spacer(),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  item.quantity.toString(),
                  style: TextStyle(fontSize: 20.0,),
                ),
              ),
            ],
          ),
        ).toList(),
      ),
    );
  }
}