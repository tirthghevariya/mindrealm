class GoalCategory {
  String goal;
  String affirmation;
  String continueDoing;
  String improveOn;

  GoalCategory({
    this.goal = '',
    this.affirmation = '',
    this.continueDoing = '',
    this.improveOn = '',
  });

  factory GoalCategory.fromMap(Map<String, dynamic> map) {
    return GoalCategory(
      goal: map['goal'] ?? '',
      affirmation: map['affirmation'] ?? '',
      continueDoing: map['continue_doing'] ?? '',
      improveOn: map['improve_on'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal': goal,
      'affirmation': affirmation,
      'continue_doing': continueDoing,
      'improve_on': improveOn,
    };
  }
}