import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mindrealm/routers/app_bindings.dart';
import 'package:mindrealm/screens/auth/page/login_screen.dart';
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
import '../screens/bottom_nav/reflection/dailygratitude.dart';
import '../screens/bottom_nav/reflection/reflectionflowscreen.dart';
import '../screens/bottom_nav/reflection/weeklyRefecation.dart';
import '../screens/bottom_nav/wellbeing_overview/wellbeing_overview.dart';
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
          name: Routes.QuoteScreen,
          page: () => QuoteScreen(),
        ),
        GetPage(
          name: Routes.bottomNavBar,
          page: () => BottomNavBar(),
        ),
        GetPage(
          name: Routes.GoalsOverviewScreen,
          page: () => GoalsOverviewScreen(),
        ),
        GetPage(
            name: Routes.goalDetailScreen,
            page: () => GoalDetailScreen(
                // tabIndex: 0,
                ),
            binding: GoalDetailBunding()),
        GetPage(
          name: Routes.ProfileNotificationsScreen,
          page: () => ProfileNotificationsScreen(),
        ),
        GetPage(
          name: Routes.ReflectionFlowScreen,
          page: () => ReflectionFlowScreen(),
        ),
        GetPage(
          name: Routes.WeeklyReflection,
          page: () => WeeklyReflection(),
        ),
        GetPage(
          name: Routes.DailyGratitude,
          page: () => DailyGratitude(),
        ),
        GetPage(
          name: Routes.AboutMindRealmScreen,
          page: () => AboutMindRealmScreen(),
        ),
        GetPage(
          name: Routes.WellBeingOverview,
          page: () => WellBeingOverview(),
        ),
        GetPage(
          name: Routes.SoundHealing,
          page: () => SoundHealing(),
        ),
        GetPage(
          name: Routes.GuidedMeditation,
          page: () => GuidedMeditation(),
        ),
        GetPage(
          name: Routes.MotivationalSpeech,
          page: () => MotivationalSpeech(),
        ),
        GetPage(
          name: Routes.Affirmations,
          page: () => Affirmations(),
        ),
        GetPage(
          name: Routes.Journal,
          page: () => Journal(),
        ),
      ];
}
