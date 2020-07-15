import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/business_logic/view_models/bulk_scan/bulk_scan_viewmodel.dart';
import 'package:snapsheetapp/business_logic/view_models/expense/expense_viewmodel.dart';
import 'package:snapsheetapp/business_logic/view_models/export/export_viewmodel.dart';
import 'package:snapsheetapp/business_logic/view_models/recurring/recurring_viewmodel.dart';
import 'package:snapsheetapp/business_logic/view_models/user_data_impl.dart';
import 'package:snapsheetapp/services/auth/auth_impl.dart';
import 'package:snapsheetapp/ui/components/scanner/receipt_preview.dart';
import 'package:snapsheetapp/ui/screens/recurring/add_recurring_screen.dart';
import 'package:snapsheetapp/ui/screens/recurring/recurring_screen.dart';
import 'package:snapsheetapp/ui/screens/screens.dart';
import 'package:snapsheetapp/ui/screens/splash_screen.dart';
import 'package:snapsheetapp/ui/shared/splash.dart';

import 'business_logic/view_models/homepage/homepage_viewmodel.dart';

void main() {
  //To lock orientation of the app.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(Snapsheet());
  });
}

class Snapsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(value: AuthServiceImpl().user),
        ChangeNotifierProvider<ExpenseViewModel>(
            create: (context) => ExpenseViewModel()),
        ChangeNotifierProvider<HomepageViewModel>(
            create: (context) => HomepageViewModel()),
        ChangeNotifierProvider<BulkScanViewModel>(
            create: (context) => BulkScanViewModel()),
        ChangeNotifierProvider<RecurringViewModel>(
            create: (context) => RecurringViewModel()),
        ChangeNotifierProvider<UserData>(create: (context) => UserData())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          Wrapper.id: (context) => Wrapper(),
          LoginScreen.id: (context) => LoginScreen(),
          HomepageScreen.id: (context) => HomepageScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          ExpenseScreen.id: (context) => ExpenseScreen(),
          EditExpenseInfoScreen.id: (context) => EditExpenseInfoScreen(),
          ExportScreen.id: (context) => ExportScreen(),
//          AddCategoryScreen.id: (context) => AddCategoryScreen(),
          EditProfileScreen.id: (context) => EditProfileScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          BulkScanScreen.id: (context) => BulkScanScreen(),
          RecurringScreen.id: (context) => RecurringScreen(),
          AddRecurringScreen.id: (context) => AddRecurringScreen(),
          ReceiptPreviewScreen.id: (context) => ReceiptPreviewScreen(),
          EditAccountsOrder.id: (context) => EditAccountsOrder(),
        },
        theme: ThemeData.light().copyWith(primaryColor: Colors.black),
      ),
    );
  }
}
