import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/view_models/dashboard/homepage_viewmodel.dart';
import 'package:snapsheetapp/ui/config/decoration.dart';
import 'package:snapsheetapp/ui/screens/home/rename_account_popup.dart';

class AccountOrderTile extends StatefulWidget {
  AccountOrderTile({Key key, this.index, this.color, this.title, this.total})
      : super(key: key);

  final int index;
  final Color color;
  final String title;
  final double total;

  @override
  _AccountOrderTileState createState() => _AccountOrderTileState();
}

class _AccountOrderTileState extends State<AccountOrderTile> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomepageViewModel>(context, listen: false);
    return ListTile(
      onTap: () {
        model.selectAccount(widget.index);
        model.syncController();
        model.syncBarAndTabToBeginning();
      },
      contentPadding: EdgeInsets.only(left: 20),
      dense: true,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(5.0)),
      ),
      title: Text(
        widget.title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        widget.total.toStringAsFixed(2),
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
      trailing: Theme(
          data: ThemeData.light(),
          child: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Colors.white,
                  onPressed: () {
                    model.initEditAccount(widget.index);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: RenameAccountPopup(),
                      ),
                      shape: kBottomSheetShape,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    model.selectAccount(widget.index);
                    showDialog(
                      context: context,
                      child: DeleteDialog(widget: widget),
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final AccountOrderTile widget;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageViewModel>(
      builder: (context, model, child) {
        return Theme(
          data: ThemeData.light(),
          child: AlertDialog(
            titlePadding: EdgeInsets.only(left: 20, right: 20, top: 20),
            contentPadding:
                EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            title: Text("Delete account?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Are you sure you want to delete ${widget.title}?'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        'DELETE',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      onPressed: () {
                        model.deleteAccount();
                        model.syncController();
                        Navigator.pop(context);
                      },
                    ),
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text('NO'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
