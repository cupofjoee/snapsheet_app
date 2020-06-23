import 'package:flutter/material.dart';
import 'file:///C:/Users/jtedd/AndroidStudioProjects/snapsheet_app/lib/ui/components/scanner/bulk_scan_accounts_list.dart';

class BulkScanScreen extends StatelessWidget {
  static const String id = 'bulkscan_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(),
        title: Text('BULK SCAN'),
      ),
      body: BulkScanAccountsList(),
    );
  }
}