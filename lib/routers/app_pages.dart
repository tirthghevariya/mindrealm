import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mindrealm/routers/app_bindings.dart';
import 'package:mindrealm/screens/auth/page/login_screen.dart';
import 'package:mindrealm/screens/bottom_nav/reflection/daily_reflection/daily_gratitude.dart';
import 'package:mindrealm/screens/splash/splashscreen.dart';

import '../screens/auth/page/signup_screen.dart';
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
import '../screens/bottom_nav/reflection/daily_reflection/daily_reflection_flow_screen.dart';
import '../screens/bottom_nav/reflection/weekly_reflection/weekly_refecation.dart';
import '../screens/bottom_nav/reflection/reflection_overview/wellbeing_overview.dart';
import '../screens/splash/quote_screen.dart';
import 'app_routes.dart';

class AppPages {
  static List<GetPage> get listRoutes => [
        GetPage(
          name: Routes.splashScreen,
          page: () => Splashscreen(),
        ),
        GetPage(
            name: Routes.loginScreen,
            page: () => LoginScreen(),
            binding: AuthBinding()),
        GetPage(
            name: Routes.signUpScreen,
            page: () => SignUpScreen(),
            binding: AuthBinding()),
        GetPage(
          name: Routes.quoteScreen,
          page: () => QuoteScreen(),
        ),
        GetPage(
            name: Routes.bottomNavBar,
            page: () => BottomNavBar(),
            binding: BottomBarBunding()),
        GetPage(
          name: Routes.goalsOverviewScreen,
          page: () => GoalsOverviewScreen(),
        ),
        GetPage(
            name: Routes.goalDetailScreen,
            page: () => GoalDetailScreen(),
            binding: GoalDetailBunding()),
        GetPage(
          name: Routes.profileNotificationsScreen,
          page: () => ProfileNotificationsScreen(),
        ),
        GetPage(
            name: Routes.dailyReflectionScreen,
            page: () => DailyReflectionFlowScreen(),
            binding: DailyReflectionBinding()),
        GetPage(
          name: Routes.dailyGratitude,
          page: () => DailyGratitude(),
        ),
        GetPage(
          name: Routes.weeklyReflection,
          page: () => WeeklyReflection(),
          binding: WeeklyReflectionBinding(),
        ),
        GetPage(
          name: Routes.aboutMindRealmScreen,
          page: () => AboutMindRealmScreen(),
        ),
        GetPage(
            name: Routes.wellBeingOverview,
            page: () => WellBeingOverview(),
            binding: WellBeingOverviewBinding()),
        GetPage(
          name: Routes.soundHealing,
          page: () => SoundHealing(),
        ),
        GetPage(
          name: Routes.guidedMeditation,
          page: () => GuidedMeditation(),
        ),
        GetPage(
          name: Routes.motivationalSpeech,
          page: () => MotivationalSpeech(),
        ),
        GetPage(
          name: Routes.affirmations,
          page: () => Affirmations(),
        ),
        GetPage(
            name: Routes.journal,
            page: () => Journal(),
            binding: JournalBinding()),
      ];
}
