import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mindrealm/screens/auth/page/login_screen.dart';
import 'package:mindrealm/screens/splash/splashscreen.dart';

import '../screens/auth/page/alternative_signup_screen.dart';
import '../screens/auth/page/signup_screen.dart';
import '../screens/auth/page/signup_screen_dup.dart';
import '../screens/bottom_nav/bottom_nav.dart';
import '../screens/bottom_nav/goal_details/goal_details_screen.dart';
import '../screens/bottom_nav/goals_overview/goals_overview.dart';
import '../screens/bottom_nav/heals/sound_healing/affirmation.dart';
import '../screens/bottom_nav/heals/sound_healing/guided_meditation.dart';
import '../screens/bottom_nav/heals/sound_healing/journal.dart';
import '../screens/bottom_nav/heals/sound_healing/motivationalspeech.dart';
import '../screens/bottom_nav/heals/sound_healing/sound_healing.dart';
import '../screens/bottom_nav/home/home_description.dart';
import '../screens/bottom_nav/profile/profile_notification.dart';
import '../screens/bottom_nav/reflection/dailygratitude.dart';
import '../screens/bottom_nav/reflection/reflectionflowscreen.dart';
import '../screens/bottom_nav/reflection/weeklyRefecation.dart';
import '../screens/bottom_nav/wellbeing_overview/wellbeing_overview.dart';
import '../screens/splash/quote_screen.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> get listRoutes => [
        GetPage(
          name: Routes.SPLASH,
          page: () => Splashscreen(),
          preventDuplicates: true,
        ),
        GetPage(
            name: Routes.LOGIN,
            page: () => LoginScreen(),
            preventDuplicates: true,
            transition: Transition.rightToLeftWithFade,
            transitionDuration: Duration(milliseconds: 1800)),
        GetPage(
          name: Routes.signUpScreen,
          page: () => SignupScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.SignupScreenDup,
          page: () => SignupScreenDup(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.AlternativeSignupScreen,
          page: () => AlternativeSignupScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.QuoteScreen,
          page: () => QuoteScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.BottomNavBar,
          page: () => BottomNavBar(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.GoalsOverviewScreen,
          page: () => GoalsOverviewScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.GoalDetailScreen,
          page: () => GoalDetailScreen(
            tabIndex: 0,
          ),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.ProfileNotificationsScreen,
          page: () => ProfileNotificationsScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.ReflectionFlowScreen,
          page: () => ReflectionFlowScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.WeeklyReflection,
          page: () => WeeklyReflection(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.DailyGratitude,
          page: () => DailyGratitude(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.AboutMindRealmScreen,
          page: () => AboutMindRealmScreen(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.WellBeingOverview,
          page: () => WellBeingOverview(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.SoundHealing,
          page: () => SoundHealing(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.GuidedMeditation,
          page: () => GuidedMeditation(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.MotivationalSpeech,
          page: () => MotivationalSpeech(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.Affirmations,
          page: () => Affirmations(),
          preventDuplicates: true,
        ),
        GetPage(
          name: Routes.Journal,
          page: () => Journal(),
          preventDuplicates: true,
        ),
      ];
}
