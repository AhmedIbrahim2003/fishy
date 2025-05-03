import 'catch_model.dart';

class CatchDay {
  final String date;
  final List<Catch> catches;

  CatchDay({
    required this.date,
    required this.catches,
  });

  factory CatchDay.fromJson(Map<String, dynamic> json) {
    return CatchDay(
      date: json['date'],
      catches: (json['catches'] as List)
          .map((item) => Catch.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'catches': catches.map((c) => c.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CatchDay(date: $date, catches: ${catches.map((c) => c.toString()).toList()})';
  }
}
