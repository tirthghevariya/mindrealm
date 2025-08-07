import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/utils/app_colors.dart';

import '../../../../utils/app_size_config.dart';
import '../../../../utils/app_text.dart';

class Screenfour extends StatefulWidget {
  final VoidCallback onValid;

  const Screenfour({super.key, required this.onValid});

  @override
  State<Screenfour> createState() => _ScreenFourState();
}

class _ScreenFourState extends State<Screenfour> {
  String? _selectedValue;
  final TextEditingController _wordController = TextEditingController();

  final List<String> _happinessScale =
      List.generate(10, (index) => '${index + 1}');

  void _handleSelection(int index) {
    setState(() {
      _selectedValue = _happinessScale[index];
    });
    widget.onValid(); // mark this step as valid
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            AppText.howAreYouFeelingAboutFriendships,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 30,
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(60)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            AppText.howContentQuestion,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.brown,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(40)),
        Container(
          child: GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (_) => Container(
                  height: 250,
                  color: Colors.white,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 40,
                    scrollController: FixedExtentScrollController(
                      initialItem: _selectedValue != null
                          ? _happinessScale.indexOf(_selectedValue!)
                          : 0,
                    ),
                    onSelectedItemChanged: _handleSelection,
                    children: _happinessScale
                        .map((value) => Center(child: Text(value)))
                        .toList(),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightPrimary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.brown),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedValue ?? AppText.selectScale,
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: AppColors.brown),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: SizeConfig.getHeight(63)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            AppText.addWordPrompt,
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
