class Fish {
  final String name;
  final bool poisonous;
  final List<String> popularRegions;

  Fish({
    required this.name,
    required this.poisonous,
    required this.popularRegions,
  });

  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      name: json['name'],
      poisonous: json['poisonous'],
      popularRegions: List<String>.from(json['popular_regions']),
    );
  }
}
