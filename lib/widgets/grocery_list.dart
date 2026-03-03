import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';


class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> groceryItems = [];

  void _addItem() async {
     final newItem = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const NewItem(),
        ),
      );
      if (newItem == null) {
        return;
      }
      setState(() {
        groceryItems.addAll(newItem);
      });
    }

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) => ListTile(
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
}












































// import 'package:flutter/material.dart';
// import 'package:shopping_list/data/dummy_items.dart';

// class HomeScreen extends StatelessWidget {
//   final String title;

//   const HomeScreen({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {

//   final grocery = groceryItems;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: ListView(
//         children: grocery.map((item) =>
//           Row(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 10),
//                 padding: const EdgeInsets.all(16.0),
//                 color: item.category.color,
//               ),
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   item.category.name,
//                   style: TextStyle(fontSize: 20,),
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   item.quantity.toString(),
//                   style: TextStyle(fontSize: 20.0,),
//                 ),
//               ),
//             ],
//           ),
//         ).toList(),
//       ),
//     );
//   }
// }