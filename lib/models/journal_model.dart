import 'package:cloud_firestore/cloud_firestore.dart';

class JournalDocument {
  final String id;
  final List<JournalEntry> journal;

  JournalDocument({
    required this.id,
    required this.journal,
  });

  factory JournalDocument.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalDocument(
      id: doc.id,
      journal: (data['journal'] as List<dynamic>)
          .map((e) => JournalEntry.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'journal': journal.map((j) => j.toMap()).toList(),
    };
  }
}

class JournalEntry {
  final DateTime datetime;
  final String journalText;

  JournalEntry({
    required this.datetime,
    required this.journalText,
  });

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      datetime: (map['datetime'] as Timestamp).toDate(),
      journalText: map['journalText'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'datetime': Timestamp.fromDate(datetime),
      'journalText': journalText,
    };
  }
}
