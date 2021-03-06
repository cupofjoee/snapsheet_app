import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/view_models/homepage/homepage_viewmodel.dart';
import 'package:snapsheetapp/ui/config/config.dart';
import 'package:snapsheetapp/ui/shared/shared.dart';

class AddAccountPopup extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  @override
  _AddAccountPopupState createState() => _AddAccountPopupState();
}

class _AddAccountPopupState extends State<AddAccountPopup> {
  String accountTitle;
  static int colorPointer = 0;

  static const List<ColorSwatch> materialColors = const <ColorSwatch>[
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey
  ];

  Color _color = materialColors[colorPointer];
  Color _tempColor;

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            OutlineButton(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _color = _tempColor);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: AddAccountPopup._formKey,
      child: Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0, top: 15.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Add account',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.close,
                      size: 25.0,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(right: 2.0),
              leading: Container(
                height: 40,
                width: 40,
                child: FlatButton(
                  padding: EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: _color,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    _openDialog(
                      "Color your account",
                      MaterialColorPicker(
                        shrinkWrap: true,
                        allowShades: false,
                        onMainColorChange: (newColor) {
                          setState(() {
                            _tempColor = newColor;
                          });
                        },
                        selectedColor: _color,
                      ),
                    );
                  },
                ),
              ),
              title: TextFormField(
                cursorColor: Colors.black,
                autofocus: true,
                onChanged: (value) {
                  accountTitle = value;
                },
                decoration: kAddAccountTextFieldDecoration,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text.';
                  }
                  return null;
                },
              ),
            ),
            Consumer<HomepageViewModel>(
              builder: (context, model, child) {
                return RoundedButton(
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  title: 'CREATE',
                  onPressed: () {
                    if (AddAccountPopup._formKey.currentState.validate()) {
                      model.selectAccount(model.accounts.length);
                      model.addAccount(accountTitle, _color);
                      HomepageViewModel.syncController();
                      colorPointer++;
                      if (colorPointer == materialColors.length) {
                        colorPointer = 0;
                      }
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
