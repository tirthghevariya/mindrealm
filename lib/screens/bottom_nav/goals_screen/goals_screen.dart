import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routers/app_routes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_size_config.dart';
import '../../../utils/app_text.dart';
import '../goal_details/goal_details_screen.dart';

class GoalsMenuScreen extends StatefulWidget {
  const GoalsMenuScreen({super.key});

  @override
  State<GoalsMenuScreen> createState() => _GoalsMenuScreenState();
}

class _GoalsMenuScreenState extends State<GoalsMenuScreen> {
  List<String> _slideshowImages = [];
  int _currentImageIndex = 0;

  // Default fallback images
  final List<String> _defaultImages = [
    AppImages.yourself,
    AppImages.health,
    AppImages.love,
    AppImages.career,
    AppImages.family,
    AppImages.friend,
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchGoalImages();
    });
  }

  // Simulated fetch function
  Future<List<String?>> fetchMoodboardFirstImages() async {
    // Simulate user not uploading some images (replace with your real logic)
    return [
      null, // no image uploaded for yourself
      "https://yourcdn.com/user_health.jpg",
      null,
      "https://yourcdn.com/user_career.jpg",
      null,
      null,
    ];
  }

  void _fetchGoalImages() async {
    List<String?> userImages = await fetchMoodboardFirstImages();

    // Merge fallback and uploaded
    List<String> finalImages = [];
    for (int i = 0; i < _defaultImages.length; i++) {
      finalImages.add(userImages[i] ?? _defaultImages[i]);
    }

    if (!mounted) return;
    setState(() {
      _slideshowImages = finalImages;
    });

    _startSlideshow();
  }

  void _startSlideshow() {
    if (_slideshowImages.isEmpty) return;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2)); // 🔁 Faster switch
      if (!mounted || _slideshowImages.isEmpty) return false;
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _slideshowImages.length;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              AppImages.goalsMenuBg,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Positioned.fill(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.getWidth(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Left Side
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.getHeight(60),
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Text(
                            AppText.reachYourGoals,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 40,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(16)),

                          /// Slideshow Container
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.GoalsOverviewScreen);
                            },
                            child: Container(
                              height: SizeConfig.getHeight(290),
                              width: SizeConfig.getWidth(175),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.transparent,
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _slideshowImages.isNotEmpty
                                      ? AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 800),
                                          child: _slideshowImages[
                                                      _currentImageIndex]
                                                  .startsWith("http")
                                              ? Image.network(
                                                  _slideshowImages[
                                                      _currentImageIndex],
                                                  key: ValueKey(
                                                      _slideshowImages[
                                                          _currentImageIndex]),
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  _slideshowImages[
                                                      _currentImageIndex],
                                                  key: ValueKey(
                                                      _slideshowImages[
                                                          _currentImageIndex]),
                                                  fit: BoxFit.cover,
                                                ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.photo,
                                            size: 48,
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                        ),
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: RotatedBox(
                                      quarterTurns: -1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.getHeight(14),
                                          horizontal: SizeConfig.getHeight(36),
                                        ),
                                        child: Text(
                                          AppText.overview,
                                          style: GoogleFonts.dmSerifDisplay(
                                            fontSize: 40,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.getHeight(10)),
                        ],
                      ),
                    ),
                  ),

                  /// Right Side
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: SizeConfig.getHeight(30)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          for (var label in [
                            AppText.yourself,
                            AppText.health,
                            AppText.love,
                            AppText.career,
                            AppText.family,
                            AppText.friendships,
                          ])
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.getWidth(10)),
                              child: InkWell(
                                onTap: () {
                                  int tabIndex = [
                                    AppText.yourself,
                                    AppText.health,
                                    AppText.love,
                                    AppText.career,
                                    AppText.family,
                                    AppText.friendships,
                                  ].indexOf(label);

                                  Get.to(() =>
                                      GoalDetailScreen(tabIndex: tabIndex));
                                },
                                child: Container(
                                  width: SizeConfig.getWidth(157),
                                  height: SizeConfig.getHeight(105),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: SizeConfig.getWidth(16),
                                      left: SizeConfig.getWidth(12),
                                    ),
                                    child: Text(
                                      label,
                                      style: GoogleFonts.openSans(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.brown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
