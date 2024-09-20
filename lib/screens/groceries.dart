import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/list_view_item.dart';
import 'package:http/http.dart' as http;

class Groceries extends StatefulWidget {
  const Groceries({super.key});

  @override
  State<Groceries> createState() => _GroceriesState();
}

class _GroceriesState extends State<Groceries> {
  var _groceriesItems = [];
  bool _isLoading = true;
  String? _error;
  void _loadItems() async {
    final url = Uri.https('shopping-list-bb6e3-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      Map<String, dynamic> items = json.decode(response.body);

      final loadedItems = [];

      for (final item in items.entries) {
        loadedItems.add(
          GroceryItem(
              id: item.key,
              name: item.value['name'],
              quantity: item.value['quantity'],
              category: categories.entries.firstWhere((test) {
                return test.value.category == item.value['category'];
              }).value),
        );
      }
      setState(() {
        _groceriesItems = loadedItems;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something get wrong try again later';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addNewItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    setState(() {
      _groceriesItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('no items to display'),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceriesItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceriesItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) async {
            final dummy = _groceriesItems[index];
            setState(() {
              _groceriesItems.remove(_groceriesItems[index]);
            });
            final url = Uri.https(
                'shopping-list-bb6e3-default-rtdb.firebaseio.com',
                'shopping-list/${dummy.id}.json');
            final response = await http.delete(url);

            if (response.statusCode > 400) {
              setState(() {
                _groceriesItems.insert(index, dummy);
              });
            }
          },
          key: ValueKey(_groceriesItems[index]),
          child: ListViewItem(
              groceryType: _groceriesItems[index].name,
              quantity: _groceriesItems[index].quantity,
              color: _groceriesItems[index].category.color),
        ),
      );
    }

    if (_error != null) {
      content = Center(
        child: Text(_error!),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text('Your Groceries'),
          actions: [
            IconButton(onPressed: _addNewItem, icon: const Icon(Icons.add))
          ],
        ),
        body: content);
  }
}
