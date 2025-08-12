import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsModel {
  GoalCategory career;
  GoalCategory family;
  GoalCategory friendships;
  GoalCategory health;
  GoalCategory love;
  GoalCategory yourself;
  DateTime? lastUpdated;

  GoalsModel({
    required this.career,
    required this.family,
    required this.friendships,
    required this.health,
    required this.love,
    required this.yourself,
    this.lastUpdated,
  });

  factory GoalsModel.fromMap(Map<String, dynamic> map) {
    return GoalsModel(
      career: GoalCategory.fromMap(map['career']),
      family: GoalCategory.fromMap(map['family']),
      friendships: GoalCategory.fromMap(map['friendships']),
      health: GoalCategory.fromMap(map['health']),
      love: GoalCategory.fromMap(map['love']),
      yourself: GoalCategory.fromMap(map['yourself']),
      lastUpdated: map['last_updated'] != null
          ? (map['last_updated'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'career': career.toMap(),
      'family': family.toMap(),
      'friendships': friendships.toMap(),
      'health': health.toMap(),
      'love': love.toMap(),
      'yourself': yourself.toMap(),
      'last_updated': lastUpdated,
    };
  }
}

class GoalCategory {
  String goal;
  String affirmation;
  String continueDoing;
  String improveOn;
  List<String>? images;

  GoalCategory({
    this.goal = '',
    this.affirmation = '',
    this.continueDoing = '',
    this.improveOn = '',
    this.images,
  });

  factory GoalCategory.fromMap(Map<String, dynamic> map) {
    List<String> images = map['images'] != null
        ? List<String>.from(map['images'] is List ? map['images'] : [])
        : [];
    return GoalCategory(
      goal: map['goal'] ?? '',
      affirmation: map['affirmation'] ?? '',
      continueDoing: map['continue_doing'] ?? '',
      improveOn: map['improve_on'] ?? '',
      images: images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal': goal,
      'affirmation': affirmation,
      'continue_doing': continueDoing,
      'improve_on': improveOn,
      'images': images,
    };
  }
}
