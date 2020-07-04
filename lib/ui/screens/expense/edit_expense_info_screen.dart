import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/business_logic/view_models/dashboard/dashboard_viewmodel.dart';
import 'package:snapsheetapp/business_logic/view_models/expense/expense_viewmodel.dart';
import 'package:snapsheetapp/ui/components/button/rounded_button.dart';
import 'package:snapsheetapp/ui/components/date_time.dart';
import 'package:snapsheetapp/ui/components/receipt_image_dialog.dart';
import 'package:snapsheetapp/ui/config/config.dart';

class EditExpenseInfoScreen extends StatefulWidget {
  static const String id = 'edit_expense_info_screen';

  const EditExpenseInfoScreen({
    Key key,
  }) : super(key: key);

  @override
  _EditExpenseInfoScreenState createState() => _EditExpenseInfoScreenState();
}

class _EditExpenseInfoScreenState extends State<EditExpenseInfoScreen> {
  String title;
  ExpenseViewModel model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var temp = title;
    model = Provider.of<ExpenseViewModel>(context);
    title = model.tempRecord.title;
//    print('Title changed: $temp -> $title');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(),
        title: Text('EDIT INFORMATION'),
      ),
      body: Theme(
        data: ThemeData.dark(),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                ),
                onChanged: (value) {
                  setState(() {
                    model.changeTitle(value);
                  });
                },
              ),
              SizedBox(height: 10.0),
              RecordDateTime(),
              SizedBox(height: 10.0),
              ReceiptImage(tempRecord: model.tempRecord),
              SizedBox(height: 10),
              RoundedButton(
                color: Colors.white,
                textColor: Colors.black,
                title: 'Add Receipt',
                icon: Icon(Icons.receipt, color: Colors.black),
                onPressed: () async {
                  await model.showChoiceDialog(context);
                  model.imageToTempRecord();
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, EditExpenseInfoScreen.id);
                  });
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(Icons.check),
        onPressed: () {
          final dashboardModel =
              Provider.of<DashboardViewModel>(context, listen: false);
//          print("Adding to record: \$${model.tempRecord.value}");
          model.addRecord();
          bool isEditing = model.isEditing;
          dashboardModel.selectAccount(model.getAccountIndexFromTempRecord());
          dashboardModel.syncController();
          Navigator.pop(context);
          Navigator.pop(context);
          String title = dashboardModel.getSelectedAccount().title;
          String messageStatus =
              isEditing ? 'updated' : 'added to account: $title';
          Flushbar(
            message: "Record successfully $messageStatus.",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Colors.blue[300],
          )..show(context);
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
//      },
//    );
  }
}

class ReceiptImage extends StatelessWidget {
  Record tempRecord;

  ReceiptImage({this.tempRecord});
  @override
  Widget build(BuildContext context) {
    if (tempRecord.imagePath != null) {
      return GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (_) =>
                  ReceiptImageDialog(imagePath: tempRecord.imagePath));
        },
        child: Image.file(
          File(tempRecord.imagePath),
          fit: BoxFit.cover,
          height: 200,
        ),
      );
    } else if (tempRecord.receiptURL != null) {
      return GestureDetector(
        onTap: () async {
          await showDialog(
              context: context,
              builder: (_) => ReceiptImageDialog(
                    receiptURL: tempRecord.receiptURL,
                  ));
        },
        child: Image.network(
          tempRecord.receiptURL,
          fit: BoxFit.cover,
          height: 200,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                  backgroundColor: kDarkCyan,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
