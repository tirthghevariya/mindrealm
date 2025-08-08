import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_style.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _entries = [];
  final int _maxChars = 1000;

  void _submitEntry() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && text.length <= _maxChars) {
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(now);
      setState(() {
        _entries.insert(0, {'date': formattedDate, 'text': text});
        _controller.clear();
      });
    }
  }

  void _goToOverview() {
    Get.to(() => JournalOverview(entries: _entries));
  }

  @override
  Widget build(BuildContext context) {
    _entries.insert(0, {
      'date': DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'text': "Hello"
    });
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back,
                    size: 28, color: AppColors.brown),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  AppText.journal,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: SizeConfig.getWidth(200),
                  child: Text(
                    AppText.journalDescription,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: AppStyle.textStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brown,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                maxLength: _maxChars,
                maxLines: 8,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0XFFfae5c2), // White background
                  hintText: 'Input',
                  hintStyle: TextStyle(color: AppColors.black),
                  counterText: '',
                  contentPadding: const EdgeInsets.all(12),

                  // Only bottom border in red
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black,
                        width: 2), // slightly thicker on focus
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getHeight(45)),
              Center(
                child: SizedBox(
                  width: SizeConfig.getWidth(249),
                  child: ElevatedButton(
                    onPressed: _submitEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Done",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.getWidth(29)),
              Center(
                child: Container(
                  width: SizeConfig.getWidth(249),
                  child: TextButton(
                    onPressed: _goToOverview,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "See your previous journal entries",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JournalOverview extends StatelessWidget {
  final List<Map<String, String>> entries;

  const JournalOverview({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.brown),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Journal overview',
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry['date'] ?? '',
                              style: AppStyle.textStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                  fontSize: 15)),
                          const SizedBox(height: 15),
                          Text(
                            entry['text'] ?? '',
                            style: AppStyle.textStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.brown,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
