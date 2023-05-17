import 'package:flutter/material.dart';

class ExpenseCountScreen extends StatefulWidget {
  const ExpenseCountScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseCountScreen> createState() => _ExpenseCountScreenState();
}

class _ExpenseCountScreenState extends State<ExpenseCountScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 14),
                child: Text(
                  'Total Trip Expense',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const Text(
              '6000',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.only(right: 8),
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.currency_rupee_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
