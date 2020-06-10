import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/components/expenses_calculator.dart';
import 'package:snapsheetapp/models/scanner.dart';
import 'package:snapsheetapp/models/user_data.dart';
import 'package:snapsheetapp/screens/editinfo_screen.dart';
import 'package:flutter/rendering.dart';

class AddExpensesScreen extends StatelessWidget {
  static const String id = 'addexpenses_screen';
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(builder: (context, userData, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              //TODO: more complex navigation
              Navigator.pop(context);
            },
          ),
          title: Text('EXPENSES EDITOR'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, EditInfoScreen.id);
              },
            ),
            IconButton(
              icon: Icon(Icons.receipt),
              onPressed: () {
                Scanner scanner =
                    Scanner(userData: userData, screenId: AddExpensesScreen.id);
                scanner.process(context);
              },
            )
          ],
        ),
        body: ExpensesCalculator(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.check),
          onPressed: () {
            userData.addRecord();
            Navigator.pop(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 40.0,
            child: Container(
              child: null,
            ),
          ),
        ),
      );
    });
  }
}
