

class SampleItem {
  const SampleItem(this.name, this.date, this.category);

  final String name;
  final DateTime date;
  final String category;

  Map<String, dynamic> toJson() => {
        'name': name,
        'date': date.toIso8601String(),
        'category': category,
      };

  static SampleItem fromJson(Map<String, dynamic> json) => SampleItem(
        json['name'],
        DateTime.parse(json['date']),
        json['category'],
      );
}