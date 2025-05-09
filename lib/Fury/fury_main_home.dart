// ignore_for_file: deprecated_member_use, unused_field, unused_element, unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import '../Affialiates/affiliates_screen.dart';
import '../Agencies/agencies_screen.dart';
import '../Commissions/commissions_screen.dart';
import '../Downlines/downlines_screen.dart';
import '../Easy/easy_screen.dart';
import '../Funding/funding_home.dart';
import '../Historic/historic_home.dart';
import 'Teams Data/TeamwiseBreakdown/teamwise_screen.dart';
import 'Teams Data/TeamwiseSalesGraph/teamwise_sales_graph.dart';
import 'widgets/rotating_logo.dart';
import 'widgets/stat_cards.dart';
import 'widgets/headers.dart';

class FuryHome extends StatefulWidget {
  const FuryHome({super.key});

  @override
  State<FuryHome> createState() => _FuryHomeState();
}

class _FuryHomeState extends State<FuryHome>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showOverlay = false;
  bool _showSidebar = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey _menuButtonKey = GlobalKey();

  final List<Widget> _screens = [
    const _HomeContent(),
    const HistoricHome(),
    const FundingScreen(),
    const CommissionsScreen(),
    const AffiliatesScreen(),
    const AgenciesScreen(),
    const DownlinesScreen(),
    const EasyScreen(),
  ];

  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Fury',
      'icon': Icons.dashboard,
      'subItems': ['Overview', 'Analytics'],
    },
    {
      'title': 'Historic',
      'icon': Icons.history,
      'subItems': ['Daily', 'Weekly', 'Monthly'],
    },
    {
      'title': 'Funding',
      'icon': Icons.money,
      'subItems': ['Deposits', 'Withdrawals', 'Transactions'],
    },
    {
      'title': 'Commissions',
      'icon': Icons.payments,
      'subItems': ['History', 'Reports'],
    },
    {
      'title': 'Affiliates',
      'icon': Icons.people,
      'subItems': ['Performance', 'Payments'],
    },
    {
      'title': 'Agencies',
      'icon': Icons.business,
      'subItems': ['Overview', 'Reports'],
    },
    {
      'title': 'Downlines',
      'icon': Icons.account_tree,
      'subItems': ['Structure', 'Performance', 'Analytics'],
    },
    {
      'title': 'Easy',
      'icon': Icons.speed,
      'subItems': ['Quick Access', 'Settings', 'Help'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 0.0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    debugPrint(
      'Sidebar icon clicked. Current state: ' + _showSidebar.toString(),
    );
    setState(() {
      _showSidebar = !_showSidebar;
      if (_showSidebar) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _removeOverlay();
      }
    });
  }

  void _showOverlayMenu(BuildContext context, int index) {
    if (_overlayEntry != null) {
      _removeOverlay();
    }
    setState(() {
      _selectedIndex = index;
      _showOverlay = true;
    });
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    // Close sidebar when a screen is opened
    if (_showSidebar) {
      _toggleSidebar();
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _showOverlay = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox button =
        _menuButtonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonSize = button.size;
    final buttonPosition = button.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => Positioned(
            left: buttonPosition.dx + buttonSize.width,
            top: buttonPosition.dy,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shrinkWrap: true,
                  itemCount: _menuItems[_selectedIndex]['subItems'].length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[_selectedIndex]['subItems'][index];
                    return ListTile(
                      title: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        // Handle sub-item selection
                      },
                    );
                  },
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxHeight > constraints.maxWidth;
        final isSmallScreen = constraints.maxWidth < 600;

        return Scaffold(
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  // Top bar background
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 68,
                      color: Colors.black.withOpacity(0.18),
                    ),
                  ),
                  // Top Left Menu Icon
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      key: _menuButtonKey,
                      icon: const Icon(
                        Icons.menu,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: _toggleSidebar,
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                  // Logo at top right
                  Positioned(
                    top: 8,
                    right: 16,
                    child: RotatingLogo(imagePath: 'assets/icon.png', size: 44),
                  ),
                  // Top Center Heading
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _menuItems[_selectedIndex]['title'] + ' Dashboard',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Main Content Area
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        if (_showSidebar) {
                          _toggleSidebar();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: _screens[_selectedIndex],
                      ),
                    ),
                  ),
                  // Sidebar overlay
                  if (_showSidebar)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      width: 240,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.92),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Sidebar Logo and Title
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const RotatingLogo(),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Fury Dashboard',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Navigation Items
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                children: List.generate(_menuItems.length, (
                                  index,
                                ) {
                                  return _buildNavIcon(
                                    _menuItems[index]['icon'],
                                    index,
                                    _menuItems[index]['title'],
                                  );
                                }),
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
        );
      },
    );
  }

  Widget _buildNavIcon(IconData icon, int index, String tooltip) {
    final isSelected = _selectedIndex == index;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          if (_showSidebar) {
            _toggleSidebar();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.blue : Colors.grey[400],
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey[400],
                    fontSize: isSelected ? 16 : 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: Text(tooltip, overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = constraints.maxHeight > constraints.maxWidth;
        final isSmallScreen = constraints.maxWidth < 600;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16), // Add extra spacing at the top
                    const TodayHeader(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 16),
                    const StatCards(),
                    const SizedBox(height: 32),
                    const GraphHeader(),
                    const SizedBox(height: 16),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(height: 320, child: TeamSalesScreen()),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const BreakdownHeader(),
                    const SizedBox(height: 16),
                    const TeamwiseScreen(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
