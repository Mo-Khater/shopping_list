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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              color: color,
            ),
            SizedBox(
              width: 10,
            ),
            Text(groceryType),
            const Spacer(),
            Container(
              child: Text(quantity.toString()),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            ),
          ],
        ),
      ),
    );
  }
}
