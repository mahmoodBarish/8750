import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class DetailItemScreen extends StatefulWidget {
  const DetailItemScreen({super.key});

  @override
  State<DetailItemScreen> createState() => _DetailItemScreenState();
}

class _DetailItemScreenState extends State<DetailItemScreen> {
  String _selectedSize = 'M'; // Default selected size based on Figma's pre-selected 'M'

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    // Define base dimensions from Figma 375x812 for responsive scaling
    const double baseWidth = 375;
    const double baseHeight = 812;

    // Calculate scaling factors
    final double scaleX = screenWidth / baseWidth;
    final double scaleY = screenHeight / baseHeight;

    // Helper functions for responsive sizing
    double scaleW(double value) => value * scaleX;
    double scaleH(double value) => value * scaleY;
    double scaleFont(double value) => value * (scaleX + scaleY) / 2; // Average for better font scaling

    // Heights for fixed elements
    final double statusBarHeight = mediaQuery.padding.top > 0 ? mediaQuery.padding.top : scaleH(44);
    final double headerHeight = scaleH(44); // Height of the "Detail" header
    final double bottomActionBarHeight = scaleH(118);
    final double homeIndicatorHeight = mediaQuery.padding.bottom > 0 ? mediaQuery.padding.bottom : scaleH(34);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main scrollable content area
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: statusBarHeight + headerHeight + scaleH(12), // Status bar + header + spacing to image
                bottom: bottomActionBarHeight + homeIndicatorHeight, // Bottom bar + home indicator
                left: scaleW(24),
                right: scaleW(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(scaleW(16)),
                    child: Image.asset(
                      'assets/images/I184_204_417_715.png',
                      width: screenWidth - scaleW(48), // Total screen width minus horizontal padding
                      height: scaleH(202),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: scaleH(24)), // Spacing between image and details

                  // Product Details (Caffe Mocha section)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Caffe Mocha',
                                style: GoogleFonts.sora(
                                  fontSize: scaleFont(20),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2F2D2C),
                                ),
                              ),
                              SizedBox(height: scaleH(4)),
                              Text(
                                'Ice/Hot',
                                style: GoogleFonts.sora(
                                  fontSize: scaleFont(12),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFA9A9A9),
                                ),
                              ),
                            ],
                          ),
                          // Superiority Icons
                          Row(
                            children: [
                              _buildSuperiorityIcon(
                                'assets/images/I184_198_418_950.png', // Motorbike/Fast Delivery icon
                              ),
                              SizedBox(width: scaleW(12)),
                              _buildSuperiorityIcon(
                                'assets/images/I184_200_418_971.png', // Coffee bean/Quality Bean icon
                              ),
                              SizedBox(width: scaleW(12)),
                              _buildSuperiorityIcon(
                                'assets/images/I184_202_418_967.png', // Packaging/Extra Milk icon
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: scaleH(16)),
                      // Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded, // Using a standard star icon
                            color: const Color(0xFFFBBE21),
                            size: scaleFont(20),
                          ),
                          SizedBox(width: scaleW(4)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '4.8 ',
                                  style: GoogleFonts.sora(
                                    fontSize: scaleFont(14),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2F2D2C),
                                  ),
                                ),
                                TextSpan(
                                  text: '(230)',
                                  style: GoogleFonts.sora(
                                    fontSize: scaleFont(12),
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFFA9A9A9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: scaleH(16)), // Spacing before divider
                      // Divider
                      Container(
                        height: scaleH(1),
                        color: const Color(0xFFEAEAEA),
                        width: double.infinity,
                      ),
                    ],
                  ),
                  SizedBox(height: scaleH(16)), // Spacing after divider

                  // Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: GoogleFonts.sora(
                          fontSize: scaleFont(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F2D2C),
                        ),
                      ),
                      SizedBox(height: scaleH(8)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk the fo..',
                              style: GoogleFonts.sora(
                                fontSize: scaleFont(14),
                                fontWeight: FontWeight.w300, // Light in Figma, regular in text property
                                color: const Color(0xFFA9A9A9),
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: ' Read More',
                              style: GoogleFonts.sora(
                                fontSize: scaleFont(14),
                                fontWeight: FontWeight.w600, // SemiBold in Figma
                                color: const Color(0xFFC67C4E),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scaleH(24)),

                  // Size Selection
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Size',
                        style: GoogleFonts.sora(
                          fontSize: scaleFont(16),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2F2D2C),
                        ),
                      ),
                      SizedBox(height: scaleH(16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['S', 'M', 'L'].map((size) {
                          bool isSelected = _selectedSize == size;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = size;
                              });
                            },
                            child: Container(
                              width: scaleW(96),
                              height: scaleH(41),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFF9F9F9)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(scaleW(12)),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFFC67C4E)
                                      : const Color(0xFFEAEAEA),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                size,
                                style: GoogleFonts.sora(
                                  fontSize: scaleFont(14),
                                  fontWeight: FontWeight.w400,
                                  color: isSelected
                                      ? const Color(0xFFC67C4E)
                                      : const Color(0xFF2F2D2C),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: scaleH(24)),
                ],
              ),
            ),
          ),

          // Top Header (Back, Title, Favorite) - Fixed position
          Positioned(
            top: statusBarHeight + scaleH(24), // Place below status bar
            left: scaleW(24),
            right: scaleW(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop(); // Go back using go_router
                  },
                  child: Container(
                    width: scaleW(44),
                    height: scaleH(44),
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Background not explicitly in Figma for back/fav but often implied transparent
                      borderRadius: BorderRadius.circular(scaleW(12)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: scaleFont(20),
                      color: const Color(0xFF2F2D2C),
                    ),
                  ),
                ),
                Text(
                  'Detail',
                  style: GoogleFonts.sora(
                    fontSize: scaleFont(16),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2F2D2C),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle favorite button tap
                  },
                  child: Container(
                    width: scaleW(44),
                    height: scaleH(44),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(scaleW(12)),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.favorite_border,
                      size: scaleFont(20),
                      color: const Color(0xFF2F2D2C),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Action Bar (Price and Buy Now button) - Fixed position
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              padding: EdgeInsets.fromLTRB(
                scaleW(24),
                scaleH(16),
                scaleW(24),
                scaleH(46) + mediaQuery.padding.bottom, // Add safe area bottom
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(scaleW(16)),
                  topRight: Radius.circular(scaleW(16)),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price',
                        style: GoogleFonts.sora(
                          fontSize: scaleFont(14),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF909090),
                        ),
                      ),
                      SizedBox(height: scaleH(4)),
                      Text(
                        '\$ 4.53',
                        style: GoogleFonts.sora(
                          fontSize: scaleFont(18),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFC67C4E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: scaleW(217),
                    height: scaleH(56),
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/checkout'); // Navigate to checkout screen using go_router
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC67C4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(scaleW(16)),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: scaleW(20),
                          vertical: scaleH(16),
                        ),
                      ),
                      child: Text(
                        'Buy Now',
                        style: GoogleFonts.sora(
                          fontSize: scaleFont(16),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Status Bar Overlay (Figma shows specific elements)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: statusBarHeight, // Dynamic height for notch or default
              color: Colors.white,
              alignment: Alignment.bottomCenter, // Align content to the bottom of this container
              padding: EdgeInsets.symmetric(horizontal: scaleW(24)),
              child: Padding(
                padding: EdgeInsets.only(bottom: statusBarHeight > scaleH(44) ? scaleH(10) : scaleH(12)), // Adjust padding for consistent placement
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '9:41',
                      style: GoogleFonts.sora(
                        fontSize: scaleFont(15),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2F2D2C),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_alt, size: scaleFont(17), color: const Color(0xFF2F2D2C)),
                        SizedBox(width: scaleW(5)),
                        Icon(Icons.wifi, size: scaleFont(17), color: const Color(0xFF2F2D2C)),
                        SizedBox(width: scaleW(5)),
                        Icon(Icons.battery_full, size: scaleFont(17), color: const Color(0xFF2F2D2C)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Home Indicator Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Covers any content underneath
              height: homeIndicatorHeight, // Dynamic height
              alignment: Alignment.center,
              child: Container(
                width: scaleW(134),
                height: scaleH(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F2D2C),
                  borderRadius: BorderRadius.circular(scaleW(100)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build the superiority icons with consistent styling
  Widget _buildSuperiorityIcon(String assetPath) {
    // Define base dimensions from Figma for responsive scaling
    const double baseWidth = 375;
    const double baseHeight = 812;

    // Calculate scaling factors
    final double scaleX = MediaQuery.of(context).size.width / baseWidth;
    final double scaleY = MediaQuery.of(context).size.height / baseHeight;

    // Helper functions for responsive sizing
    double scaleW(double value) => value * scaleX;
    double scaleH(double value) => value * scaleY;

    return Container(
      width: scaleW(44),
      height: scaleH(44),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA).withOpacity(0.35), // Color from Figma (0.929411768913269, a: 0.3499999940395355)
        borderRadius: BorderRadius.circular(scaleW(12)),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: scaleW(24), // Icon size based on Figma
        height: scaleH(24),
        fit: BoxFit.contain,
        color: const Color(0xFFC67C4E), // Apply accent color as per Figma
      ),
    );
  }
}