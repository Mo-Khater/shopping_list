import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widgets/list_view_item.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text('Your Groceries'),
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            itemCount: groceryItems.length,
            itemBuilder: (ctx, index) => ListViewItem(
                groceryType: groceryItems[index].name,
                quantity: groceryItems[index].quantity,
                color: groceryItems[index].category.color)));
  }
}
