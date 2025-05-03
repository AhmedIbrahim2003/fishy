class Catch {
  final int id;
  final String fishName;
  final String timestamp;
  final String photoPath;
  final double confidence;

  Catch({
    required this.id,
    required this.fishName,
    required this.timestamp,
    required this.photoPath,
    required this.confidence,
  });

  factory Catch.fromJson(Map<String, dynamic> map) {
    return Catch(
      id: map['id'] as int,
      fishName: map['fish_name'] as String,
      timestamp: map['timestamp'] as String,
      photoPath: map['photo_path'] as String,
      confidence: (map['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fish_name': fishName,
      'timestamp': timestamp,
      'photo_path': photoPath,
      'confidence': confidence,
    };
  }

  @override
  String toString() {
    return 'Catch(id: $id, fishName: $fishName, timestamp: $timestamp, photoPath: $photoPath, confidence: $confidence)';
  }
}
