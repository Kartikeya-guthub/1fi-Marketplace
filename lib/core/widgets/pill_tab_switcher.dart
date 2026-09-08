import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PillTabSwitcher extends StatelessWidget {
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  const PillTabSwitcher({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AppColors.tabTrackBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;

          return Stack(
            children: [
              // Sliding Indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                left: activeIndex * tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.tabActiveSegment,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      width: 24,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.tabUnderlineTick,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              // Tab Texts
              Row(
                children: List.generate(tabs.length, (index) {
                  final isActive = index == activeIndex;
                  return SizedBox(
                    width: tabWidth,
                    child: GestureDetector(
                      onTap: () => onChanged(index),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 250),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 13,
                                    color: isActive
                                        ? AppColors.tabActiveText
                                        : AppColors.tabInactiveText,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                  ),
                              child: Text(
                                tabs[index],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 7), // Space for the sliding tick
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}


