import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // For bottom navigation
  int _selectedCategoryIndex = 0; // For coffee categories

  final List<String> _coffeeCategories = [
    'All Coffee',
    'Machiato',
    'Latte',
    'Americano',
  ];

  final List<Map<String, dynamic>> _coffeeProducts = [
    {
      'id': 'I189:60;417:715',
      'name': 'Caffe Mocha',
      'description': 'Deep Foam',
      'rating': '4.8',
      'price': '4.53',
    },
    {
      'id': 'I189:76;417:717',
      'name': 'Flat White',
      'description': 'Espresso',
      'rating': '4.8',
      'price': '3.53',
    },
    {
      'id': 'I189:108;417:716',
      'name': 'Mocha Fusi',
      'description': 'Ice/Hot',
      'rating': '4.8',
      'price': '7.53',
    },
    {
      'id': 'I189:92;417:718',
      'name': 'Caffe Panna',
      'description': 'Ice/Hot',
      'rating': '4.8',
      'price': '5.53',
    },
  ];

  // Define base dimensions from Figma 375x812 for responsive scaling
  static const double baseWidth = 375;
  static const double baseHeight = 812;

  // Helper functions for responsive sizing - moved to class scope
  double _scaleW(double value) => value * (MediaQuery.of(context).size.width / baseWidth);
  double _scaleH(double value) => value * (MediaQuery.of(context).size.height / baseHeight);
  double _scaleFont(double value) {
    final double scaleX = MediaQuery.of(context).size.width / baseWidth;
    final double scaleY = MediaQuery.of(context).size.height / baseHeight;
    return value * (scaleX + scaleY) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    final double topPadding = mediaQuery.padding.top;
    final double bottomPadding = mediaQuery.padding.bottom;

    // Calculate the total fixed height of elements above the scrollable content.
    // This includes the actual system status bar area where the custom status bar overlay sits,
    // plus the fixed header elements (location, search, promo banner) and their respective spacings.
    final double fixedHeaderHeight = topPadding +
        _scaleH(22) + // SizedBox after status bar in original
        _scaleH(44) + // Height of location/profile section
        _scaleH(16) + // SizedBox after location/profile
        _scaleH(52) + // Height of search bar
        _scaleH(16) + // SizedBox after search bar
        _scaleH(140) + // Height of promo banner
        _scaleH(16); // SizedBox after promo banner

    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5), // Assuming a light background for scrollable content
      body: Stack(
        children: [
          // Top dark background section
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: screenHeight * 0.3448, // 280 / 812
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF111111), // R: 0.06666667014360428, G: 0.06666667014360428, B: 0.06666667014360428
                    Color(0xFF313131), // R: 0.19166666269302368, G: 0.19166666269302368, B: 0.19166666269302368
                  ],
                ),
              ),
            ),
          ),
          
          // Custom Status Bar (Time, Icons) overlay - fixed at top
          _buildStatusBarOverlay(screenWidth, topPadding),

          // Main scrollable content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: fixedHeaderHeight, // Content starts after the fixed header elements
                bottom: _scaleH(99) + bottomPadding, // Account for bottom nav bar and home indicator area
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories list and product grid are scrollable
                  _buildCategoriesList(screenWidth),
                  SizedBox(height: _scaleH(16)), // Spacing before product grid
                  _buildProductGrid(screenWidth),
                ],
              ),
            ),
          ),
          
          // Fixed Header Elements (Location, Search, Promo Banner) - positioned above scrollable content
          Positioned(
            top: topPadding, // Starts directly below the custom status bar overlay
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(height: _scaleH(22)), // Spacing after status bar
                _buildLocationAndProfile(screenWidth),
                SizedBox(height: _scaleH(16)), // Spacing after location/profile
                _buildSearchBar(screenWidth),
                SizedBox(height: _scaleH(16)), // Spacing after search bar
                _buildPromoBanner(screenWidth),
              ],
            ),
          ),

          // Bottom Navigation Bar with integrated Home Indicator - fixed at bottom
          _buildBottomNavBar(screenWidth, bottomPadding),
        ],
      ),
    );
  }

  // New Widget for the top status bar overlay
  Widget _buildStatusBarOverlay(double screenWidth, double topPadding) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: topPadding > 0 ? topPadding : _scaleH(44), // Dynamic height for notch or default
      child: Container(
        color: Colors.transparent, // Background of the actual status bar is handled by the gradient
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: _scaleW(24))
                 .copyWith(bottom: topPadding > 0 ? _scaleH(8) : _scaleH(12)), // Adjust bottom padding for content
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '9:41',
              style: GoogleFonts.sora(
                fontSize: _scaleFont(15),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(Icons.signal_cellular_alt, color: Colors.white.withOpacity(0.4), size: _scaleFont(17)),
                SizedBox(width: _scaleW(4)),
                Icon(Icons.wifi, color: Colors.white.withOpacity(0.4), size: _scaleFont(17)),
                SizedBox(width: _scaleW(4)),
                Icon(Icons.battery_full, color: Colors.white.withOpacity(0.4), size: _scaleFont(17)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationAndProfile(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scaleW(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: GoogleFonts.sora(
                  fontSize: _scaleFont(12),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA2A2A2),
                  letterSpacing: 0.12,
                  height: 1.2,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Bilzen, Tanjungbalai',
                    style: GoogleFonts.sora(
                      fontSize: _scaleFont(14),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD8D8D8),
                    ),
                  ),
                  SizedBox(width: _scaleW(4)),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFFD8D8D8),
                    size: _scaleFont(14),
                  ),
                ],
              ),
            ],
          ),
          // Profile Picture Placeholder
          ClipOval(
            child: Image.asset(
              'assets/images/I189_285_417_715.png', // Assuming a placeholder for profile pic
              width: _scaleW(44),
              height: _scaleH(44),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scaleW(24)),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: _scaleH(52),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(_scaleW(12)),
              ),
              child: TextField(
                style: GoogleFonts.sora(
                  fontSize: _scaleFont(14),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA2A2A2),
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: 'Search coffee',
                  hintStyle: GoogleFonts.sora(
                    fontSize: _scaleFont(14),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFA2A2A2),
                    height: 1.2,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white, size: _scaleFont(20)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: (_scaleH(52) - (_scaleFont(14) * 1.2)) / 2, // Adjusted font size to scaled value
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: _scaleW(16)),
          Container(
            width: _scaleW(52),
            height: _scaleH(52),
            decoration: BoxDecoration(
              color: const Color(0xFFC67C4E),
              borderRadius: BorderRadius.circular(_scaleW(12)),
            ),
            child: IconButton(
              onPressed: () {
                // Handle filter button press
              },
              icon: Icon(Icons.filter_list, color: Colors.white, size: _scaleFont(20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scaleW(24)),
      child: Container(
        width: _scaleW(327),
        height: _scaleH(140),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_scaleW(16)),
          image: const DecorationImage(
            image: AssetImage('assets/images/189_126.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(_scaleW(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: _scaleW(6), vertical: _scaleH(4)),
                decoration: BoxDecoration(
                  color: const Color(0xFFED5151),
                  borderRadius: BorderRadius.circular(_scaleW(8)),
                ),
                child: Text(
                  'Promo',
                  style: GoogleFonts.sora(
                    fontSize: _scaleFont(14),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Buy one get one FREE',
                style: GoogleFonts.sora(
                  fontSize: _scaleFont(32),
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(double screenWidth) {
    return SizedBox(
      height: _scaleH(29), // Fixed height for category buttons
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: _scaleW(24)),
        scrollDirection: Axis.horizontal,
        itemCount: _coffeeCategories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: _scaleW(16)),
              padding: EdgeInsets.symmetric(horizontal: _scaleW(8), vertical: _scaleH(4)),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFC67C4E)
                    : const Color(0xFFF3F3F3).withOpacity(0.35),
                borderRadius: BorderRadius.circular(_scaleW(6)),
              ),
              child: Text(
                _coffeeCategories[index],
                style: GoogleFonts.sora(
                  fontSize: _scaleFont(14),
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF313131),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _scaleW(24)),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: _scaleW(16),
          mainAxisSpacing: _scaleH(16),
          childAspectRatio:
              (_scaleW(156)) / (_scaleH(238)), // 156 width / 238 height roughly
        ),
        itemCount: _coffeeProducts.length,
        itemBuilder: (context, index) {
          final product = _coffeeProducts[index];
          return GestureDetector(
            onTap: () {
              context.push('/detail_item', extra: product); // Use go_router and pass data via extra
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_scaleW(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(_scaleW(12)),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/${product['id'].replaceAll(':', '_').replaceAll(';', '_')}.png',
                          height: _scaleH(128),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: _scaleW(8), vertical: _scaleH(8)),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF111111),
                                  Color(0xFF313131),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(_scaleW(12)),
                                topRight: Radius.circular(_scaleW(12)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded,
                                    color: const Color(0xFFFBBE21), size: _scaleFont(12)),
                                SizedBox(width: _scaleW(2)),
                                Text(
                                  product['rating']!,
                                  style: GoogleFonts.sora(
                                    fontSize: _scaleFont(8),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: _scaleW(8), vertical: _scaleH(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name']!,
                          style: GoogleFonts.sora(
                            fontSize: _scaleFont(16),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2F2D2C),
                          ),
                        ),
                        SizedBox(height: _scaleH(4)),
                        Text(
                          product['description']!,
                          style: GoogleFonts.sora(
                            fontSize: _scaleFont(12),
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFA2A2A2),
                          ),
                        ),
                        SizedBox(height: _scaleH(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$ ${product['price']}',
                              style: GoogleFonts.sora(
                                fontSize: _scaleFont(18),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0F0F0F),
                              ),
                            ),
                            Container(
                              width: _scaleW(32),
                              height: _scaleH(32),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC67C4E),
                                borderRadius: BorderRadius.circular(_scaleW(8)),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add,
                                    color: Colors.white, size: _scaleFont(16)),
                                onPressed: () {
                                  // Add to cart functionality
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // The bottom navigation bar, now integrates the home indicator bar
  Widget _buildBottomNavBar(double screenWidth, double bottomPadding) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: screenWidth,
        height: _scaleH(99) + bottomPadding, // Total height including safe area
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_scaleW(24)),
            topRight: Radius.circular(_scaleW(24)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home,
                    label: 'Home',
                    index: 0,
                    route: '/home',
                  ),
                  _buildNavItem(
                    icon: Icons.favorite_border,
                    label: 'Favorites',
                    index: 1,
                    route: '/favorites',
                  ),
                  _buildNavItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Cart',
                    index: 2,
                    route: '/cart',
                  ),
                  _buildNavItem(
                    icon: Icons.notifications_none,
                    label: 'Notifications',
                    index: 3,
                    route: '/notifications',
                  ),
                ],
              ),
            ),
            if (bottomPadding > 0) // Only show home indicator bar if there's a safe area
              Padding(
                padding: EdgeInsets.only(bottom: _scaleH(8)), // Original home indicator margin
                child: Container(
                  width: _scaleW(134),
                  height: _scaleH(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2D2C),
                    borderRadius: BorderRadius.circular(_scaleW(100)),
                  ),
                ),
              ),
            else if (bottomPadding == 0)
              SizedBox(height: _scaleH(8)), // Maintain a minimal padding if no physical home indicator
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = _selectedIndex == index;
    final Color iconColor =
        isSelected ? const Color(0xFFC67C4E) : const Color(0xFFA2A2A2);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        context.go(route); // Use go_router for navigation
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: _scaleFont(24)),
          if (isSelected)
            Container(
              margin: EdgeInsets.only(top: _scaleH(6)),
              width: _scaleW(10),
              height: _scaleH(5),
              decoration: BoxDecoration(
                color: const Color(0xFFC67C4E),
                borderRadius: BorderRadius.circular(_scaleW(18)),
              ),
            )
          else
            SizedBox(height: _scaleH(11)), // Maintain spacing if no dot
        ],
      ),
    );
  }
}