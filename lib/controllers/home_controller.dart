import 'dart:developer';

import 'package:get/get.dart';
import 'package:mindrealm/models/quote_model.dart';
import 'package:mindrealm/utils/collection.dart';
import 'package:share_plus/share_plus.dart';

class HomeController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    await getQuotesWithTodayDay();
  }

  Rx<QuoteModel?> todayQuote = Rx<QuoteModel?>(null);

  Future getQuotesWithTodayDay() async {
    final todayDay = DateTime.now().day;

    final snapshot = await dailyQuotesCollection.get();

    final allQuotes =
        snapshot.docs.map((doc) => QuoteModel.fromFirestore(doc)).toList();

    // Filter by day number only
    final filteredQuotes =
        allQuotes.where((quote) => quote.dateTime.day == todayDay).toList();
    if (filteredQuotes.isNotEmpty) {
      todayQuote.value = filteredQuotes.first;
      for (var q in filteredQuotes) {
        log("📜 ${q.quote} — ${q.by}");
      }
    } else {
      log("No quotes found for today.");
    }
  }

  Future<void> shareQuote() async {
    final quoteText = todayQuote.value?.quote ?? "";
    final author = todayQuote.value?.by ?? "Unknown";

    final params = ShareParams(
      text: '$quoteText\n- $author',
      subject: "Inspiring Quote of the Day",
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      log('Thank you for sharing my quote!');
    } else if (result.status == ShareResultStatus.dismissed) {
      log('Share cancelled.');
    }
  }
}
