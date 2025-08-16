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
      children: [],
    );
  }
}
