import 'package:flutter/material.dart';
import 'package:mindrealm/utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_style.dart';
import '../../../utils/app_text.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(
        label: AppText.home,
        icon: AppImages.home,
        selectedIcon: AppImages.home,
      ),
      _NavItem(
        label: AppText.reflection,
        icon: AppImages.reflection,
        selectedIcon: AppImages.reflection,
      ),
      _NavItem(
        label: AppText.goals,
        icon: AppImages.goals,
        selectedIcon: AppImages.goals,
      ),
      _NavItem(
        label: AppText.heal,
        icon: AppImages.heal,
        selectedIcon: AppImages.heal,
      ),
      _NavItem(
        label: AppText.community,
        icon: AppImages.group,
        selectedIcon: AppImages.heal,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onItemTapped(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                   item.icon,
                  width: 24,
                  height: 24,
                  color: isSelected?AppColors.primary:AppColors.brown,
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: AppStyle.textStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.brown,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String icon;
  final String selectedIcon;

  _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
