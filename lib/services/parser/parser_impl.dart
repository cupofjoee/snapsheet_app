import 'package:snapsheetapp/business_logic/models/models.dart';
import 'package:snapsheetapp/services/parser/parser.dart';
import 'package:string_similarity/string_similarity.dart';

class ParserImpl implements Parser {
  static var mthToMM = {
    'jan': '01',
    'feb': '02',
    'mar': '03',
    'apr': '04',
    'may': '05',
    'jun': '06',
    'jul': '07',
    'aug': '08',
    'sep': '09',
    'oct': '10',
    'nov': '11',
    'dec': '12'
  };

  var shops = {
    "4fingers": Shop(title: '4Fingers', categoryId: 0),
    "cheers": Shop(title: 'Cheers', categoryId: 0),
    "cold storage": Shop(title: 'Cold Storage', categoryId: 0),
    "fairprice": Shop(title: 'Fairprice', categoryId: 0),
    "golden village": Shop(title: 'Golden Village', categoryId: 3),
    "hachi tech": Shop(title: 'Hachi Tech', categoryId: 6),
    "kfc": Shop(title: 'KFC', categoryId: 0),
    "koi": Shop(title: 'Koi', categoryId: 0),
    "mcdonald's": Shop(title: "McDonald's", categoryId: 0),
    "paylah": Shop(title: 'Paylah', categoryId: 8),
    "paynow": Shop(title: 'Paynow', categoryId: 8),
    "pepper lunch": Shop(title: 'Pepper Lunch', categoryId: 0),
    "popular": Shop(title: 'Popular', categoryId: 5),
    "ride": Shop(title: 'Grab ride', categoryId: 1),
    "starbucks": Shop(title: 'Starbucks', categoryId: 0),
    "uniqlo": Shop(title: 'UNIQLO', categoryId: 2),
    "monster curry": Shop(title: 'Monster Curry', categoryId: 0)
  };

  String matchedName;

  String findTitle(List<String> input) {
    // Remove Strings that are non alphabetical
    RegExp alphabetical = RegExp(r"^.*[a-zA-Z].*$");
    List<String> filtered =
        input.where((e) => alphabetical.hasMatch(e)).toList();

    // Prepare the list of shop lowercased name
    List<String> shopNames = shops.keys.toList();

    // Find the best match
    for (String word in filtered) {
      BestMatch match = StringSimilarity.findBestMatch(word, shopNames);
      Rating best = match.bestMatch;
      if (best.rating > 0.7) {
        matchedName = best.target;
        return shops[matchedName].title;
      }
    }

    for (int i = 0; i < filtered.length - 1; i++) {
      String twoWords = filtered[i] + " " + filtered[i + 1];
      BestMatch match = StringSimilarity.findBestMatch(twoWords, shopNames);
      Rating best = match.bestMatch;
      if (best.rating > 0.7) {
        matchedName = best.target;
        return shops[matchedName].title;
      }
    }

    for (int i = 0; i < filtered.length - 2; i++) {
      String threeWords =
          filtered[i] + " " + filtered[i + 1] + " " + filtered[i + 2];
      BestMatch match = StringSimilarity.findBestMatch(threeWords, shopNames);
      Rating best = match.bestMatch;
      if (best.rating > 0.7) {
        matchedName = best.target;
        return shops[matchedName].title;
      }
    }

    return "";
  }

  int findCategoryId() {
    return matchedName != null ? shops[matchedName].categoryId : 0;
  }

  DateTime findDate(String input) {
    for (Function parser in parsers) {
      DateTime parsed = parser(input);
      if (parsed != null) {
        return parsed;
      }
    }
    return DateTime.now();
  }

  double findCost(String input) {
    RegExp alertWords = RegExp(r"(discount|change|coupon)");
    RegExp money = RegExp(r"\d+\.\d{2}");

    Iterable<RegExpMatch> matches = money.allMatches(input);

    if (matches.isEmpty) return 0;

    List<double> costs = [];
    for (RegExpMatch match in matches) {
      String cost = input.substring(match.start, match.end);
      costs.add(double.parse(cost));
    }

    costs.sort();
    List<double> reversed = costs.reversed.toSet().toList();

    return alertWords.hasMatch(input) ? reversed[1] : reversed[0];
  }

  List<Function> parsers = [ddmmyy, yyyymmdd];

  static DateTime ddmmyy(String input) {
    RegExp date = RegExp(r"(\d{2}/\d{2}/\d{2,4}|\d{2} \w{3} \d{2,4})");
    String match = date.stringMatch(input);
    if (match == null) return null;
    String strDate;
    if (match.length == 8) {
      // DDMMYY
      strDate = "20" +
          match.substring(6, 8) +
          match.substring(3, 5) +
          match.substring(0, 2);
    } else if (match.length == 10) {
      // DDMMYYYY
      strDate = match.substring(6, 10) +
          match.substring(3, 5) +
          match.substring(0, 2);
    } else if (match.length == 9) {
      // DDMMYY
      strDate = "20" +
          match.substring(7, 9) +
          mthToMM[match.substring(3, 6)] +
          match.substring(0, 2);
    } else {
      // DDMMYYYY
      strDate = match.substring(7, 11) +
          mthToMM[match.substring(3, 6)] +
          match.substring(0, 2);
    }
    return DateTime.parse(strDate);
  }

  static DateTime yyyymmdd(String input) {
    RegExp date = RegExp(r"\d{4}-\d{2}-\d{2}");
    String match = date.stringMatch(input);
    if (match == null) return null;
    return DateTime.parse(match.replaceAll(RegExp(r"/"), ""));
  }
}