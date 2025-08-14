import 'package:cloud_firestore/cloud_firestore.dart';

class DailyReflectionModel {
  final String? userId;
  final DateTime? createdAt;
  List<DailyReflectionEntry> reflections;

  DailyReflectionModel({
    this.userId,
    this.createdAt,
    List<DailyReflectionEntry>? reflections,
  }) : reflections = reflections ?? [];

  /// Convert Firestore document to model
  factory DailyReflectionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyReflectionModel(
      userId: doc.id,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      reflections: (data['reflections'] as List<dynamic>? ?? [])
          .map((item) => DailyReflectionEntry.fromMap(item))
          .toList(),
    );
  }

  /// Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'reflections': reflections.map((r) => r.toMap()).toList(),
    };
  }
}

class DailyReflectionEntry {
  final DateTime datetime;
  final String scaleNumber;
  final String feelingWord;
  final String todayDescription;

  DailyReflectionEntry({
    required this.datetime,
    required this.scaleNumber,
    required this.feelingWord,
    required this.todayDescription,
  });

  /// Convert Firestore map to entry
  factory DailyReflectionEntry.fromMap(Map<String, dynamic> map) {
    return DailyReflectionEntry(
      datetime: (map['datetime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scaleNumber: map['scaleNumber'] ?? '',
      feelingWord: map['feelingWord'] ?? '',
      todayDescription: map['todayDescription'] ?? '',
    );
  }

  /// Convert entry to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'datetime': Timestamp.fromDate(datetime),
      'scaleNumber': scaleNumber,
      'feelingWord': feelingWord,
      'todayDescription': todayDescription,
    };
  }
}
