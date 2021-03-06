import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/business_logic/view_models/user_data/user_data_basemodel.dart';
import 'package:snapsheetapp/services/cloud_storage/cloud_storage_impl.dart';
import 'package:snapsheetapp/services/database/database_impl.dart';
import 'package:sorted_list/sorted_list.dart';

class UserData extends ChangeNotifier implements UserDataBaseModel {
  User user;
  DatabaseServiceImpl _db;
  CloudStorageService _cloud;
  Map<String, dynamic> credentials;

  List<Record> _records =
      SortedList<Record>((r1, r2) => r2.dateTime.compareTo(r1.dateTime));
  List<Account> _accounts =
      SortedList<Account>((a1, a2) => a1.index.compareTo(a2.index));
  List<Recurring> _recurrings = SortedList<Recurring>(
      (r1, r2) => r1.nextRecurrence.compareTo(r2.nextRecurrence));
  List<Category> _categories =
      SortedList<Category>((c1, c2) => c1.index.compareTo(c2.index));

  /// Initialize the model with UserData.
  /// Load Callback is needed to signal to the frontend that
  /// it is done fetching data from database.
  Future<void> init(User user, Function loadCallback) async {
    this.user = user;

    _records.clear();
    _accounts.clear();
    _recurrings.clear();
    _categories.clear();

    _db = DatabaseServiceImpl(uid: user.uid);
    _cloud = CloudStorageServiceImpl(uid: user.uid);
    credentials = await _db.getCredentials();

    List<Record> unorderedRecords = await _db.getRecords();
    List<Account> unorderedAccounts = await _db.getAccounts();
    List<Recurring> unorderedRecurrings = await _db.getRecurrings();
    List<Category> unorderedCategories = await _db.getCategories();

    _records.addAll(unorderedRecords);
    _accounts.addAll(unorderedAccounts);
    _recurrings.addAll(unorderedRecurrings);
    _categories.addAll(unorderedCategories);

    loadCallback();
  }

  /// Ensure that any due recurring records will be added.
  void addDueExpenses() {
    for (Recurring recurring in recurrings) {
      while (recurring.nextRecurrence.isBefore(DateTime.now())) {
        addRecord(recurring.record);
        recurring.update();
        updateRecurring(recurring);
      }
    }
  }

  /// Ensure the cloud storage for receipt images are updated and in sync.
  /// It calls the service to upload and delete image from cloud.
  Future<void> _processImage(Record record) async {
    if (record.imagePath != null) {
      record.receiptURL = await _cloud.addReceiptURL(record);
      record.hasCloudImage = true;
      record.imagePath = null;
    } else if (record.imagePath == null &&
        record.receiptURL == null &&
        record.hasCloudImage) {
      _cloud.deleteCloudImage(record);
      record.hasCloudImage = false;
    }
  }

  /// CREATE
  Future<void> addRecord(Record record) async {
    _records.add(record);
    notifyListeners();

    Future<String> uid = _db.addRecord(record);
    record.uid = await uid;
    await _processImage(record);

    _db.updateRecord(record);
  }

  Future<void> addAccount(Account account) async {
    _accounts.add(account);
    notifyListeners();
    Future<String> uid = _db.addAccount(account);
    account.uid = await uid;
  }

  Future<void> addRecurring(Recurring recurring) async {
    _recurrings.add(recurring);
    notifyListeners();
    Future<String> uid = _db.addRecurring(recurring);
    recurring.uid = await uid;
  }

  Future<void> addCategory(Category category) async {
    _categories.add(category);
    notifyListeners();
    Future<String> uid = _db.addCategory(category);
    category.uid = await uid;
  }

  /// READ
  List<Record> get records => _records;
  List<Account> get accounts => _accounts;
  List<Recurring> get recurrings => _recurrings;
  List<Category> get categories => _categories;

  /// Helper function to get a particular account given a uid.
  Account getThisAccount(String accountUid) {
    for (Account account in accounts) {
      if (account.uid == accountUid) {
        return account;
      }
    }
    return accounts.first;
  }

  /// Helper function to get a particular category given a uid.
  Category getThisCategory(String categoryUid) {
    for (Category category in categories) {
      if (category.uid == categoryUid) {
        return category;
      }
    }
    return categories.first;
  }

  /// UPDATE
  Future<void> updateRecord(Record record) async {
    await _processImage(record);
    _db.updateRecord(record);
  }

  Future<void> updateAccount(Account account) async {
    _db.updateAccount(account);
  }

  Future<void> updateRecurring(Recurring recurring) async {
    _db.updateRecurring(recurring);
  }

  Future<void> updateCategory(Category category) async {
    _db.updateCategory(category);
  }

  /// Clear all demo data and initialize the user with empty state.
  Future<void> demoDone() async {
    credentials['isDemo'] = false;
    records.forEach((record) => _db.deleteRecord(record));
    accounts.forEach((account) => _db.deleteAccount(account));
    categories.forEach((category) =>
        !category.isDefault ? _db.deleteCategory(category) : null);
    recurrings.forEach((recurring) => _db.deleteRecurring(recurring));

    records.clear();
    accounts.clear();
    categories.removeWhere((category) => !category.isDefault);
    recurrings.clear();
    notifyListeners();

    _db.updateCredentials(credentials);
  }

  /// DELETE
  Future<void> deleteRecord(Record record) async {
    _cloud.deleteCloudImage(record);
    _records.removeWhere((rec) => rec.uid == record.uid);
    _db.deleteRecord(record);
  }

  Future<void> deleteAccount(Account account) async {
    _accounts.removeWhere((acc) => acc.uid == account.uid);
    _db.deleteAccount(account);
  }

  Future<void> deleteRecurring(Recurring recurring) async {
    _recurrings.removeWhere((rec) => rec.uid == recurring.uid);
    _db.deleteRecurring(recurring);
  }

  Future<void> deleteCategory(Category category) async {
    _categories.removeWhere((cat) => cat.uid == category.uid);
    _db.deleteCategory(category);
  }
}
