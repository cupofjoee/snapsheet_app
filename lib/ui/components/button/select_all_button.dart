import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/business_logic/view_models/dashboard/homepage_viewmodel.dart';

class SelectAllButton extends StatelessWidget {
  const SelectAllButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageViewModel>(
      builder: (context, model, child) => Visibility(
        visible: model.selectedAccountIndex != -1,
        child: MaterialButton(
          visualDensity: VisualDensity.comfortable,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.blueAccent),
          ),
          child: Text(
            'SELECT ALL',
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
          onPressed: () {
            model.selectAccount(-1);
          },
        ),
      ),
    );
  }
}
