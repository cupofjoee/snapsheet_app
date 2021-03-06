import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String title;
  double value;
  DateTime dateTime;
  String categoryUid;
  String accountUid;
  bool isIncome;
  String receiptURL;
  String uid;
  String imagePath;
  bool hasCloudImage;

  /// CategoryId only used for initialization of demo categories.
  /// AccountId only used for initialization of demo accounts.
  int categoryId;
  int accountId;

  factory Record.newBlankRecord() {
    return Record(
      title: "",
      value: 0,
      dateTime: DateTime.now(),
      isIncome: false,
      hasCloudImage: false,
    );
  }

  Record.fromReceipt({
    this.title,
    this.value,
    this.dateTime,
    this.categoryUid,
    this.accountUid,
    this.isIncome = false,
    this.imagePath,
  });

  Record.demo(
      this.title, this.value, this.dateTime, this.categoryId, this.accountId,
      [this.isIncome = false, this.receiptURL, this.hasCloudImage = false]);

  Record({
    this.title,
    this.value,
    this.dateTime,
    this.categoryUid,
    this.accountUid,
    this.isIncome,
    this.receiptURL,
    this.uid,
    this.imagePath,
    this.hasCloudImage,
  });

  factory Record.of(Record record) {
    return Record(
      title: record.title,
      value: record.value,
      dateTime: record.dateTime,
      categoryUid: record.categoryUid,
      accountUid: record.accountUid,
      isIncome: record.isIncome,
      receiptURL: record.receiptURL,
      uid: record.uid,
      imagePath: record.imagePath,
      hasCloudImage: record.hasCloudImage,
    );
  }

  factory Record.fromFirestore(DocumentSnapshot doc) {
    Map json = doc.data;

    return Record(
      title: json['title'],
      value: json['value'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      categoryUid: json['categoryUid'],
      accountUid: json['accountUid'],
      isIncome: json['isIncome'],
      receiptURL: json['receiptURL'],
      imagePath: json['imagePath'],
      hasCloudImage: json['hasCloudImage'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'value': value,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'categoryUid': categoryUid,
      'accountUid': accountUid,
      'isIncome': isIncome,
      'receiptURL': receiptURL,
      'imagePath': imagePath,
      'hasCloudImage': hasCloudImage,
      'uid': uid,
    };
  }

  @override
  String toString() {
    Map<String, dynamic> map = {
      'title': title,
      'value': value,
      'dateTime': dateTime,
      'categoryUid': categoryUid,
      'accountUid': accountUid,
      'isIncome': isIncome,
      'receiptURL': receiptURL,
      'imagePath': imagePath,
      'hasCloudImage': hasCloudImage,
      'uid': uid,
    };
    return map.toString();
  }
}
