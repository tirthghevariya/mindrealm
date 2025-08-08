import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/utils/app_colors.dart';

import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';

class Gratitude extends StatefulWidget {
  const Gratitude({super.key});

  @override
  State<Gratitude> createState() => _GratitudeState();
}

class _GratitudeState extends State<Gratitude> {
  String? _selectedValue;
  final TextEditingController _wordController = TextEditingController();

  final List<String> _happinessScale =
      List.generate(10, (index) => '${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: SizeConfig.getHeight(80)),
        Center(
          child: Text(
            AppText.gratitudecheck,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 30,
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(80)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            AppText.inOneOrAFewWords,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.brown,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(33)),
        Container(
          height: 40,
          child: TextField(
            controller: _wordController,
            decoration: InputDecoration(
              hintText: AppText.fillHere,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(20)),
      ],
    );
  }
}
