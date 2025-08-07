import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindrealm/models/gole_model.dart';
import 'package:mindrealm/utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';

class GoalDetailScreen extends StatefulWidget {
  final int? tabIndex;
  const GoalDetailScreen({super.key, this.tabIndex = 0});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<bool> _isEditing = List.generate(4, (_) => false);
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;

  final List<String> _icons = [
    AppImages.yourself,
    AppImages.health,
    AppImages.love,
    AppImages.career,
    AppImages.family,
    AppImages.friend,
  ];

  final List<String> _fieldKeys = [
    'goal',
    'affirmation',
    'continue_doing',
    'improve_on',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 6, vsync: this, initialIndex: widget.tabIndex ?? 0);
    _tabController.addListener(_onTabChanged);
    _loadGoalData();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      // Reset editing states when tab changes
      setState(() {
        for (int i = 0; i < _isEditing.length; i++) {
          _isEditing[i] = false;
        }
      });
      _loadGoalData();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadGoalData() async {
    if (_user == null) return;
    setState(() => _isLoading = true);

    try {
      final doc = await _firestore.collection('goals').doc(_user.uid).get();
      final data = doc.data();
      if (data != null) {
        final categoryName = _getCategoryName();
        final categoryData = data[categoryName];
        if (categoryData != null) {
          final goal =
              GoalCategory.fromMap(Map<String, dynamic>.from(categoryData));

          // Set each field individually with proper null/empecks
          _controllers[0].text = goal.goal ;
          _controllers[1].text = goal.affirmation ;
          _controllers[2].text = goal.continueDoing ;
          _controllers[3].text = goal.improveOn ;
        } else {
          // Clear all controllers if no data exists for this category
          for (var controller in _controllers) {
            controller.clear();
          }
        }
      } else {
        // Clear all controllers if no document exists
        for (var controller in _controllers) {
          controller.clear();
        }
      }
    } catch (e) {
      log("Error loading goal data: $e");
      Get.snackbar(
        'Error',
        'Failed to load goal data',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Add method to save individual field
  Future<void> _saveIndividualField(int fieldIndex) async {
    if (_user == null) return;

    try {
      final categoryName = _getCategoryName();
      final fieldKey = _fieldKeys[fieldIndex];
      final fieldValue = _controllers[fieldIndex].text.trim();

      await _firestore.collection('goals').doc(_user.uid).set({
        categoryName: {
          fieldKey: fieldValue,
        },
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar(
        'Success',
        'Field updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log("Error saving field data: $e");
      Get.snackbar(
        'Error',
        'Failed to save field data',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  String _getCategoryName() {
    switch (_tabController.index) {
      case 0:
        return 'yourself';
      case 1:
        return 'health';
      case 2:
        return 'love';
      case 3:
        return 'career';
      case 4:
        return 'family';
      case 5:
        return 'friendships';
      default:
        return 'yourself';
    }
  }

  Widget _editableField(
    int index,
    String label,
    String hint,
    Color textColor, {
    Color hintColor = Colors.grey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: index == 0 ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        _isEditing[index]
            ? TextField(
                controller: _controllers[index],
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: AppColors.brown,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(14),
                  hintText: hint,
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 14,
                    color: hintColor,
                  ),
                  filled: true,
                  fillColor: AppColors.lightPrimary,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.getWidth(4)),
                child: Text(
                  _controllers[index].text.isEmpty
                      ? hint
                      : _controllers[index].text,
                  style: GoogleFonts.openSans(
                    fontSize: index == 0 ? 20 : 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
        InkWell(
          onTap: () async {
            setState(() {
              _isEditing[index] = !_isEditing[index];
            });

            if (!_isEditing[index]) {
              // Save individual field when done editing
              await _saveIndividualField(index);
            }
          },
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  _isEditing[index] ? AppText.done : AppText.edit,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: index == 0 ? AppColors.brown : Colors.orange,
                  ),
                ),
              ),
              Container(
                height: 2,
                width:
                    (_isEditing[index] ? AppText.done : AppText.edit).length *
                        6,
                color: index == 0 ? AppColors.red : Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightPrimary,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.getHeight(24)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.getHeight(30),
                      vertical: SizeConfig.getHeight(24),
                    ),
                    child: SizedBox(
                      height: SizeConfig.screenHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getCategoryName().capitalizeFirst!,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              color: AppColors.brown,
                              height: 1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(16)),
                          TabBar(
                            controller: _tabController,
                            dividerColor: AppColors.lightPrimary,
                            indicatorColor: Colors.transparent,
                            dividerHeight: 0,
                            padding: EdgeInsets.zero,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 4),
                            onTap: (index) {
                              setState(() {
                                _tabController.index = index;
                                _loadGoalData(); // Load data for new category
                              });
                            },
                            tabs: List.generate(_icons.length, (index) {
                              final isSelected = _tabController.index == index;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.8)
                                      : AppColors.white.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  _icons[index],
                                  width: 24,
                                  height: 24,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: SizeConfig.getHeight(20)),
                          Expanded(
                            child: ListView(
                              children: [
                                _editableField(
                                  0,
                                  AppText.goalLabel,
                                  AppText.goalHint,
                                  AppColors.brown,
                                ),
                                SizedBox(height: SizeConfig.getHeight(26)),
                                _editableField(
                                  1,
                                  AppText.affirmation,
                                  AppText.affirmationHint,
                                  AppColors.primary,
                                ),
                                SizedBox(height: SizeConfig.getHeight(30)),
                                _editableField(
                                  2,
                                  AppText.continueLabel,
                                  AppText.continueHint,
                                  AppColors.primary,
                                  hintColor: Colors.orange,
                                ),
                                SizedBox(height: SizeConfig.getHeight(30)),
                                _editableField(
                                  3,
                                  AppText.improveLabel,
                                  AppText.improveHint,
                                  AppColors.primary,
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppText.youGotThis,
                                      style: GoogleFonts.dmSerifDisplay(
                                        fontSize: 24,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        height: 1,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppText.moodboard,
                                      style: GoogleFonts.openSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: SizeConfig.getHeight(16)),
                                GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(4, (index) {
                                    return Container(
                                      height: SizeConfig.getHeight(160),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(Icons.image,
                                              size: 50, color: Colors.white),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: SizeConfig.getHeight(40)),
                                Image.asset(
                                  AppImages.logo,
                                  width: SizeConfig.getWidth(216),
                                  height: SizeConfig.getHeight(108),
                                  color: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
