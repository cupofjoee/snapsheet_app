import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapsheetapp/models/account.dart';
import 'package:snapsheetapp/models/category.dart';
import 'package:snapsheetapp/models/record.dart';
import 'package:snapsheetapp/services/export.dart';
import 'package:sorted_list/sorted_list.dart';

class UserData extends ChangeNotifier {
  int _selectedAccount = -1;
  Record _tempRecord;
  bool _isEditing = false;
  Exporter _exporter;
  bool _isScanned = false;
  static int imageCounter = 0;
  List<Record> records =
      SortedList<Record>((r1, r2) => r2.date.compareTo(r1.date));

  UserData() {
    records.addAll([
      Record("Steam Dota", 12, DateTime(2020, 4, 12), 3, 0, "SGD"),
      Record("UNIQLO", 30, DateTime(2020, 5, 12), 2, 0, "SGD"),
      Record("Mother's Day", 20, DateTime(2020, 5, 10), 2, 0, "SGD"),
      Record("Sentosa Outing", 14.50, DateTime(2020, 2, 12), 3, 1, "SGD"),
      Record("Netflix Subscription", 12, DateTime(2020, 6, 1), 3, 0, "SGD"),
      Record("Food & Beverage", 5.8, DateTime(2020, 5, 29), 0, 1, "SGD"),
      Record("Dental check up", 30, DateTime(2020, 6, 3), 4, 1, "SGD"),
      Record("First Aid kit", 20, DateTime(2020, 3, 12), 4, 2, "SGD"),
      Record("Group outing", 15, DateTime(2020, 4, 5), 0, 2, "SGD"),
      Record("Bus transport", 25, DateTime(2020, 5, 6), 1, 2, "SGD"),
      Record("CCA book", 16.75, DateTime(2020, 5, 3), 5, 2, "SGD"),
      Record("Online course", 5.75, DateTime(2020, 5, 20), 6, 2, "SGD"),
      Record("Teacher's Birthday Gift", 4, DateTime(2020, 4, 3), 3, 2, "SGD"),
    ]);
    Account.accountIndexGen = accounts.length;
  }

  List<Account> _accounts = [
    Account('DBS', Colors.red[900], 0),
    Account('Cash', Colors.deepPurple[700], 1),
    Account('CCA', Colors.blue[600], 2),
  ];

  List<Category> _categories = [
    Category('Food & Drinks', Icon(FontAwesomeIcons.utensils), Colors.red),
    Category(
        'Transportation', Icon(FontAwesomeIcons.shuttleVan), Colors.blueGrey),
    Category(
        'Shopping', Icon(FontAwesomeIcons.shoppingBag), Colors.lightBlueAccent),
    Category('Entertainment', Icon(FontAwesomeIcons.glassCheers),
        Colors.deepPurpleAccent),
    Category('Health', Icon(FontAwesomeIcons.pills), Colors.indigoAccent),
    Category('Education', Icon(FontAwesomeIcons.graduationCap), Colors.orange),
    Category('Electronics', Icon(FontAwesomeIcons.tv), Colors.teal),
    Category(
        'Income', Icon(FontAwesomeIcons.moneyBill), Colors.amberAccent, true),
    Category('Others', Icon(Icons.category), Colors.black),
  ];

  List<Record> get specifiedRecords => _selectedAccount == -1
      ? records
      : records.where((rec) => rec.accountId == _selectedAccount).toList();

  int get recordsCount => records.length;

  int get selectedAccount => _selectedAccount;

  int get categoriesCount => _categories.length;

  List<Account> get accounts => _accounts;

  List<Category> get categories => _categories;

  Record get tempRecord => _tempRecord;

  bool get isEditing => _isEditing;

  bool get isScanned => _isScanned;

  void toggleScanned() {
    _isScanned = !_isScanned;
  }

  void addRecord() {
    if (!_isEditing) {
      records.add(_tempRecord);
    }

    if (_isEditing) {
      _isEditing = false;
    }

    notifyListeners();
  }

  void addAccount(String title, Color color) {
    _accounts.add(Account(title, color, accounts.length));
    notifyListeners();
  }

  void addCategory(String categoryTitle, Icon icon) {
    _categories.add(Category(categoryTitle, icon, Colors.black));
    notifyListeners();
  }

  void selectAccount(int accId) {
    _selectedAccount = accId;
    notifyListeners();
  }

  void newRecord() {
    _tempRecord =
        new Record("", 0, DateTime.now(), Record.catId, Record.accId, "SGD");
    notifyListeners();
  }

  void changeCategory(int catId) {
    _tempRecord.categoryId = catId;
    notifyListeners();
  }

  void changeAccount(int accId) {
    _tempRecord.accountId = accId;
    notifyListeners();
  }

  void changeValue(double newValue) {
    _tempRecord.value = newValue;
    notifyListeners();
  }

  void changeTempRecord(int recordIndex) {
    _tempRecord = records[recordIndex];
    _isEditing = true;
    notifyListeners();
  }

  void changeImage(File imageFile) {
    _tempRecord.image = imageFile;
    notifyListeners();
  }

  Account getCurrentAccount() {
    return accounts.firstWhere((acc) => acc.accountId == _selectedAccount);
  }

  Account getThisAccount(int id) {
    return accounts.firstWhere((acc) => acc.accountId == id);
  }

  void editAccount(String newTitle, Color newColor) {
    Account target = getCurrentAccount();
    target.title = newTitle;
    target.color = newColor;
    notifyListeners();
  }

  bool hasIncome(int id) {
    return records.any((rec) => rec.accountId == id && rec.isIncome);
  }

  bool recordMatchesStats(Record rec) {
    return (_selectedAccount == -1 || rec.accountId == _selectedAccount);
  }

  double get currentExpensesTotal {
    double total = 0;
    for (Record rec in records) {
      if (!rec.isIncome && recordMatchesStats(rec)) {
        total += rec.value;
      }
    }
    return num.parse(total.toStringAsFixed(2));
  }

  void changeTitle(String newTitle) {
    _tempRecord.title = newTitle;
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    _tempRecord.date = newDate;
    notifyListeners();
  }

  Exporter get exporter => _exporter;

  void Export() {
    _exporter = Exporter(records, accounts, categories);
  }

  void toggleExport(index) {
    _exporter.toggleExport(index);
    notifyListeners();
  }

  void deleteAccount() {
    Account target = getCurrentAccount();
    int pos = target.accountOrder;
    accounts.remove(target);
    records.removeWhere((rec) => rec.accountId == target.accountId);
    _selectedAccount = accounts[pos - 1].accountId;
    for (Account acc in accounts) {
      if (acc.accountOrder > pos) acc.accountOrder--;
    }

    notifyListeners();
  }

  double statsGetCategTotalFromCurrent(int catId) {
    if (categories[catId].isIncome) {
      return 0;
    } else {
      double total = 0;
      for (Record rec in records) {
        if (recordMatchesStats(rec) && rec.categoryId == catId) {
          total += rec.value;
        }
      }
      return num.parse(total.toStringAsFixed(2));
    }
  }

  List<Record> statsGetRecords(int limit) {
    List<Record> res = [];

    for (Record rec in records) {
      if (res.length == limit) {
        break;
      }
      if (recordMatchesStats(rec)) {
        res.add(rec);
      }
    }

    return res;
  }

  List<double> statsGetBalanceData() {
    double incomeSum = hasIncome(selectedAccount)
        ? records
            .where((rec) => rec.isIncome)
            .map((rec) => rec.value)
            .reduce((value, element) => value + element)
        : 0;

    double expenseSum = currentExpensesTotal;
    double balanceSum = incomeSum - expenseSum;
    double incomePercent = incomeSum * 100 / (incomeSum + expenseSum);
    double expensePercent = expenseSum * 100 / (incomeSum + expenseSum);

    return [incomeSum, expenseSum, balanceSum, incomePercent, expensePercent];
  }

  int statsCountRecords(int accId) {
    int count = 0;
    for (Record rec in records) {
      if (rec.accountId == accId) {
        count++;
      }
    }
    return count;
  }

  double statsGetAccountTotal(int accId) {
    double expensesTotal = 0;
    double incomeTotal = 0;

    for (Record rec in records) {
      if (rec.accountId == accId) {
        if (rec.isIncome) {
          incomeTotal += rec.value;
        } else {
          expensesTotal += rec.value;
        }
      }
    }

    return hasIncome(accId) ? incomeTotal - expensesTotal : expensesTotal;
  }

  List<Account> orderGetAccounts() {
    List<Account> res = [];
    for (Account acc in accounts) {
      res.insert(acc.accountOrder, acc);
    }
    return res;
  }

  void orderUpdateAccount(int oldOrder, int newOrder) {
    Account target = accounts.firstWhere((acc) => acc.accountOrder == oldOrder);
    target.accountOrder = newOrder;
    notifyListeners();
  }
}
