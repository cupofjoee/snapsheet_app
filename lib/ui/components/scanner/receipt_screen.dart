import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/default_data/categories.dart';
import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/business_logic/view_models/bulk_scan/bulk_scan_viewmodel.dart';
import 'package:snapsheetapp/ui/components/button/delete_button.dart';
import 'package:snapsheetapp/ui/components/button/rounded_button.dart';
import 'package:snapsheetapp/ui/components/receipt_image_dialog.dart';
import 'package:snapsheetapp/ui/config/config.dart';

class ReceiptScreen extends StatefulWidget {
  final int recordId;

  ReceiptScreen({this.recordId});

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  int recordId;

  @override
  void initState() {
    super.initState();
    recordId = widget.recordId;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BulkScanViewModel>(
      builder: (context, model, child) {
        Record record = model.records[recordId];
        return GestureDetector(
          onTap: () => unfocus(context),
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            backgroundColor: kBlack,
            body: SingleChildScrollView(
              child: Theme(
                data: ThemeData.dark(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "${recordId + 1} / ${model.records.length}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ReceiptImage(imagePath: record.imagePath),
                      SizedBox(height: 30),
                      // Value + Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: ValueFormField(recordId: recordId),
                          ),
                          SizedBox(width: 10),
                          Flexible(
                            flex: 4,
                            child: TitleFormField(recordId: recordId),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(child: DateFormField(recordId: recordId)),
                          SizedBox(width: 10),
                          Expanded(
                              child: CategoryFormField(recordId: recordId)),
                        ],
                      ),
                      DeleteConfirmButton(
                          isDelete: model.isDelete[recordId],
                          callBack: () {
                            setState(() {
                              model.isDelete[recordId] =
                                  !model.isDelete[recordId];
                            });
                          }),
                      RoundedButton(
                        color: Colors.white,
                        textColor: kBlack,
                        title: 'Confirm All Receipts',
                        icon: Icon(Icons.done_all, color: kBlack),
                        onPressed: () {
                          model.addAll();
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ValueFormField extends StatelessWidget {
  final int recordId;

  ValueFormField({this.recordId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BulkScanViewModel>(
      builder: (context, model, child) {
        return TextFormField(
            initialValue: model.records[recordId].value.toString(),
            keyboardType: TextInputType.number,
            cursorColor: Colors.white,
            decoration:
                kTitleEditInfoInputDecoration.copyWith(labelText: 'Value'),
            onChanged: (value) {
              model.changeValue(recordId, double.parse(value));
            });
      },
    );
  }
}

class TitleFormField extends StatelessWidget {
  final int recordId;

  TitleFormField({this.recordId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BulkScanViewModel>(
      builder: (context, model, child) {
        return TextFormField(
          initialValue: model.records[recordId].title,
          decoration: kTitleEditInfoInputDecoration,
          cursorColor: Colors.white,
          onChanged: (value) {
            model.changeTitle(recordId, value);
          },
        );
      },
    );
  }
}

class CategoryFormField extends StatelessWidget {
  final int recordId;

  CategoryFormField({this.recordId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BulkScanViewModel>(
      builder: (context, model, child) {
        int categoryId = model.records[recordId].categoryId;
        return OutlineButton(
            padding: EdgeInsets.all(10.0),
            child: PopupMenuButton(
              initialValue: categoryId,
              onSelected: (input) {
                model.changeCategory(recordId, input);
              },
              itemBuilder: (context) {
                List<String> categoryTitles =
                    categories.map((category) => category.title).toList();
                return categoryTitles
                    .map(
                      (e) => PopupMenuItem(
                        value: categoryTitles.indexOf(e),
                        child: ListTile(
                          leading: categories[categoryTitles.indexOf(e)].icon,
                          title: Text(e),
                        ),
                      ),
                    )
                    .toList();
              },
              child: Text(
                categories[categoryId].title,
                style: TextStyle(color: Colors.white),
              ),
            ));
      },
    );
  }
}

class DateFormField extends StatelessWidget {
  final int recordId;

  DateFormField({this.recordId});

  @override
  Widget build(BuildContext context) {
    return Consumer<BulkScanViewModel>(
      builder: (context, model, child) {
        DateTime date = model.records[recordId].dateTime;
        return OutlineButton(
            padding: EdgeInsets.all(10.0),
            child: Text(
              DateFormat.yMMMd().format(date),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(date.year - 5),
                lastDate: DateTime(date.year + 5),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark(),
                    child: child,
                  );
                },
              ).then((value) {
                model.changeDate(
                    recordId,
                    DateTime(
                      value.year,
                      value.month,
                      value.day,
                    ));
              });
            });
      },
    );
  }
}

class ReceiptImage extends StatelessWidget {
  String imagePath;

  ReceiptImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (_) => ReceiptImageDialog(imagePath: imagePath));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagePath),
          fit: BoxFit.fitWidth,
          width: 800,
          height: 200,
        ),
      ),
    );
  }
}
