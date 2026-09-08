import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/bottom_nav_bar.dart';
import '../../core/widgets/pill_tab_switcher.dart';
import '../marketplace/presentation/pages/marketplace_tab.dart';
import 'nearby_stores_tab.dart';
import 'top_brands_tab.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _activeTabIndex = 2; // Default to Marketplace as per assignment
  
  final List<String> _tabs = [
    'Top Brands',
    'Nearby Stores',
    'Marketplace',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(currentIndex: 1), // Shop active
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0), // Half of the pill height
                  child: _buildHero(context),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PillTabSwitcher(
                    tabs: _tabs,
                    activeIndex: _activeTabIndex,
                    onChanged: (index) {
                      setState(() {
                        _activeTabIndex = index;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildActiveTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    Widget content;
    switch (_activeTabIndex) {
      case 0:
        content = const TopBrandsTab(key: ValueKey('topBrands'));
        break;
      case 1:
        content = const NearbyStoresTab(key: ValueKey('nearbyStores'));
        break;
      case 2:
      default:
        content = const MarketplaceTab(key: ValueKey('marketplace'));
        break;
    }
    
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      child: content,
    );
  }

  Widget _buildHero(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: Image.asset(
        'assets/images/hero_banner.jpg',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
