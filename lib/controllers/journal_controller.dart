import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindrealm/utils/app_text.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:mindrealm/widgets/common_tost.dart';
import '../models/journal_model.dart';

class JournalController extends GetxController {
  final TextEditingController journalTextController = TextEditingController();
  final RxList<JournalEntry> entries = <JournalEntry>[].obs;

  /// Add journal entry to Firestore (array inside user's doc)
  Future<void> addJournalEntry() async {
    try {
      if (journalTextController.text.isEmpty) {
        showToast(AppText.pleaseAddJournal, err: true);
        return;
      }
      final journalEntry = JournalEntry(
        datetime: DateTime.now(),
        journalText: journalTextController.text.trim(),
      );

      await journalsCollection.doc(firebaseUserId()).set({
        "journal": FieldValue.arrayUnion([journalEntry.toMap()])
      }, SetOptions(merge: true));
      showToast(AppText.journalEntryAdded);
      journalTextController.clear();
      await fetchJournalEntries();
    } catch (e) {
      log("Error adding journal entry: $e");
    }
  }

  /// Fetch all journal entries for the current user
  Future<void> fetchJournalEntries() async {
    try {
      final docSnapshot = await journalsCollection.doc(firebaseUserId()).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?; // Cast here

        if (data != null && data['journal'] != null) {
          final List<dynamic> journalList = data['journal'];

          entries.value = journalList
              .map((e) => JournalEntry.fromMap(e as Map<String, dynamic>))
              .toList()
              .reversed
              .toList();
        } else {
          entries.clear();
        }
      } else {
        entries.clear();
      }
    } catch (e) {
      log("Error fetching journal entries: $e");
    }
  }
}
