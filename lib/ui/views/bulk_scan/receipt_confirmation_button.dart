import 'package:flutter/material.dart';

class ReceiptConfirmationButton extends StatelessWidget {
  final bool isConfirmed;
  final Function callBack;

  ReceiptConfirmationButton({this.isConfirmed, this.callBack});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: isConfirmed ? Colors.teal : Colors.black,
      color: isConfirmed ? Colors.teal : Colors.grey,
      child: ListTile(
        onTap: () => callBack(),
        title: Text(
          "Tap to ${isConfirmed ? "skip" : "confirm"} this receipt",
          style: TextStyle(color: isConfirmed ? Colors.white : Colors.black),
        ),
        trailing: isConfirmed
            ? Icon(Icons.check_box, color: Colors.white)
            : Icon(
                Icons.check_box_outline_blank,
                color: Colors.black,
              ),
      ),
    );
  }
}
