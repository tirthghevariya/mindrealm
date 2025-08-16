// // models/weekly_reflection_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';

// class WeeklyReflectionDocument {
//   final String yearWeek; // e.g., "2025_33"
//   final DateTime startDate;
//   final DateTime endDate;
//   final Map<String, ReflectionEntry> reflections;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   WeeklyReflectionDocument({
//     required this.yearWeek,
//     required this.startDate,
//     required this.endDate,
//     required this.reflections,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory WeeklyReflectionDocument.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     Map<String, ReflectionEntry> reflections = {};
//     if (data['reflections'] != null) {
//       (data['reflections'] as Map<String, dynamic>).forEach((key, value) {
//         reflections[key] =
//             ReflectionEntry.fromMap(value as Map<String, dynamic>);
//       });
//     }

//     return WeeklyReflectionDocument(
//       yearWeek: doc.id,
//       startDate: (data['startDate'] as Timestamp).toDate(),
//       endDate: (data['endDate'] as Timestamp).toDate(),
//       reflections: reflections,
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       updatedAt: (data['updatedAt'] as Timestamp).toDate(),
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     Map<String, dynamic> reflectionsMap = {};
//     reflections.forEach((key, value) {
//       reflectionsMap[key] = value.toMap();
//     });

//     return {
//       'startDate': Timestamp.fromDate(startDate),
//       'endDate': Timestamp.fromDate(endDate),
//       'reflections': reflectionsMap,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': Timestamp.fromDate(updatedAt),
//     };
//   }

//   // Check if all reflections are complete
//   bool get isComplete {
//     return reflections.length == ReflectionCategories.categories.length &&
//         reflections.values
//             .every((entry) => entry.rating != null && entry.note.isNotEmpty);
//   }

//   // Get completion percentage
//   double get completionPercentage {
//     if (ReflectionCategories.categories.isEmpty) return 0.0;
//     return reflections.length / ReflectionCategories.categories.length;
//   }
// }

// class ReflectionEntry {
//   final int rating;
//   final String note;

//   ReflectionEntry({
//     required this.rating,
//     required this.note,
//   });

//   factory ReflectionEntry.fromMap(Map<String, dynamic> map) {
//     return ReflectionEntry(
//       rating: map['rating'] ?? 0,
//       note: map['note'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'rating': rating,
//       'note': note,
//     };
//   }
// }

// // Reflection categories configuration
// class ReflectionCategories {
//   static const Map<String, String> categories = {
//     'career': 'How are you feeling about your career?',
//     'family': 'How are you feeling about your family?',
//     'friendships': 'How are you feeling about your friendships?',
//     'health': 'How are you feeling about your health?',
//     'yourself': 'How are you feeling about yourself?',
//     'love': 'How are you feeling about your love life?',
//   };

//   static const String ratingPrompt =
//       'How content are you on a scale from 1-10?';
//   static const String notePrompt =
//       'Add a word or note about this area of your life';

//   static List<String> get categoryKeys => categories.keys.toList();
//   static List<String> get categoryQuestions => categories.values.toList();
// }

// models/weekly_reflection_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class WeeklyReflectionDocument {
  final String yearWeek; // e.g., "2025_33"
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, ReflectionEntry> reflections;
  final DateTime createdAt;
  final DateTime updatedAt;

  WeeklyReflectionDocument({
    required this.yearWeek,
    required this.startDate,
    required this.endDate,
    required this.reflections,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WeeklyReflectionDocument.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WeeklyReflectionDocument.fromMap(doc.id, data);
  }

  factory WeeklyReflectionDocument.fromMap(
      String weekId, Map<String, dynamic> data) {
    Map<String, ReflectionEntry> reflections = {};
    if (data['reflections'] != null) {
      (data['reflections'] as Map<String, dynamic>).forEach((key, value) {
        reflections[key] =
            ReflectionEntry.fromMap(value as Map<String, dynamic>);
      });
    }

    return WeeklyReflectionDocument(
      yearWeek: weekId,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      reflections: reflections,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> reflectionsMap = {};
    reflections.forEach((key, value) {
      reflectionsMap[key] = value.toMap();
    });

    return {
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'reflections': reflectionsMap,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Check if all reflections are complete
  bool get isComplete {
    return reflections.length == ReflectionCategories.categories.length &&
        reflections.values
            .every((entry) => entry.rating != null && entry.note.isNotEmpty);
  }

  // Get completion percentage
  double get completionPercentage {
    if (ReflectionCategories.categories.isEmpty) return 0.0;
    return reflections.length / ReflectionCategories.categories.length;
  }
}

class ReflectionEntry {
  final int rating;
  final String note;

  ReflectionEntry({
    required this.rating,
    required this.note,
  });

  factory ReflectionEntry.fromMap(Map<String, dynamic> map) {
    return ReflectionEntry(
      rating: map['rating'] ?? 0,
      note: map['note'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'note': note,
    };
  }
}

// Reflection categories configuration
class ReflectionCategories {
  static const Map<String, String> categories = {
    'career': 'How are you feeling about your career?',
    'family': 'How are you feeling about your family?',
    'friendships': 'How are you feeling about your friendships?',
    'health': 'How are you feeling about your health?',
    'yourself': 'How are you feeling about yourself?',
    'love': 'How are you feeling about your love life?',
  };

  static const String ratingPrompt =
      'How content are you on a scale from 1-10?';
  static const String notePrompt =
      'Add a word or note about this area of your life';

  static List<String> get categoryKeys => categories.keys.toList();
  static List<String> get categoryQuestions => categories.values.toList();
}
