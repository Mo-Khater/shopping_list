import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/list_view_item.dart';

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  final _groceriesItems = [];

  void _addNewItem() async {
    final result = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (result == null) {
      return;
    }
    setState(() {
      _groceriesItems.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
          ],
        ),
        body: _groceriesItems.isNotEmpty
            ? ListView.builder(
                itemCount: _groceriesItems.length,
                itemBuilder: (ctx, index) => Dismissible(
                  onDismissed: (direction) {
                    setState(() {
                      _groceriesItems.remove(_groceriesItems[index]);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('item deleted'),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                _groceriesItems.insert(
                                    index, groceryItems[index]);
                              });
                            }),
                      ),
                    );
                  },
                  key: ValueKey(_groceriesItems[index]),
                  child: ListViewItem(
                      groceryType: _groceriesItems[index].name,
                      quantity: _groceriesItems[index].quantity,
                      color: _groceriesItems[index].category.color),
                ),
              )
            : const Center(
                child: Text('no items to display'),
              ));
  }
}
