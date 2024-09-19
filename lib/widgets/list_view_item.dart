import 'package:flutter/material.dart';

class ListViewItem extends StatelessWidget {
  final String groceryType;
  final int quantity;
  final Color color;
  const ListViewItem(
      {super.key,
      required this.groceryType,
      required this.quantity,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        color: color,
      ),
      title: Text(groceryType),
      trailing: Text(quantity.toString()),
    );
  }
}
