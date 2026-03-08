import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> groceryItems = [];
  var _isLoading = true;
  
  Future<void> _loaditems () async {
    final url = Uri.https('flutter-prep-e9940-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];
    listData.forEach((itemId, itemData) {
      final category = categories.entries.firstWhere((catItem) => catItem.value.name == itemData['category']).value;
      loadedItems.add(
        GroceryItem(
          id: itemId,
          name: itemData['name'],
          quantity: int.parse(itemData['quantity']),
          category: category
        ),
      );
    });
    setState(() {
      groceryItems.clear();
      groceryItems.addAll(loadedItems);
      _isLoading = false;
    });
  }

  @override
    void initState() {
      super.initState();
      _loaditems();
    }

  Future<void> _addItem() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem != null) {
      setState(() {
        groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item) {
    final itemIndex = groceryItems.indexOf(item);
    setState(() {
      groceryItems.remove(item);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              groceryItems.insert(itemIndex, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No items yet. Start adding some groceries!',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(groceryItems[index].id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _removeItem(groceryItems[index]);
          },
          child: ListTile(
            title: Text(groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            trailing: Text(
              groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: content,
    );
  }
}