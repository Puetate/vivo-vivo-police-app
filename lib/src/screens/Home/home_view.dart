import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:vivo_vivo_police_app/src/commons/permissions.dart';
import 'package:vivo_vivo_police_app/src/data/datasource/mongo/api_repository_notification_impl.dart';
import 'package:vivo_vivo_police_app/src/domain/models/user_auth.dart';
import 'package:vivo_vivo_police_app/src/providers/user_provider.dart';
import 'package:vivo_vivo_police_app/src/screens/Alerts/alerts.dart';
import 'package:vivo_vivo_police_app/src/screens/Home/controllers/home_controller.dart';
import 'package:vivo_vivo_police_app/src/utils/app_styles.dart';

class HomeView extends StatefulWidget {
  static const String id = 'home_view';

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController homeController;
  late String idAlarm;
  late UserAuth user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  ApiRepositoryNotificationImpl serviceAlert = ApiRepositoryNotificationImpl();
  int _selectedIndex = 0;
  List<GButton> listButtonsNavBar = [
    GButton(
      textStyle: Styles.textStyleBody,
      icon: Icons.supervised_user_circle_rounded,
      text: "Civiles",
      iconSize: 30,
    ),
    // GButton(
    //   icon: Icons.business_rounded,
    //   text: "Hospitales",
    // ),
  ];

  @override
  void initState() {
    super.initState();
    homeController = HomeController(context);
    homeController.openPreferences(context);
    user = context.read<UserProvider>().getUserPrefProvider!.getUser;
    homeController.initSocket(user);
    initPlatform(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Styles.primaryColor,
              child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Alerts(
                      userID: user.userID,
                    ),
                    /* Alerts(
                      userID: user.userID,
                    ), */
                  ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: Styles.buttonNBarBorderColor),
          ),
          color: Styles.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(            
            mainAxisAlignment: MainAxisAlignment.center,
            gap: 8,
            haptic: true,
            color: Styles.white,
            activeColor: Styles.white,
            tabBackgroundColor: Styles.containerNavButton,
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            padding: const EdgeInsets.all(10),
            tabs: listButtonsNavBar,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> initPlatform(BuildContext context) async {
    if (!mounted) return;
    homeController.initPlatform();
    getPermissions();
  }

  void getPermissions() async {
    bool hasPermission = false;

    if (mounted) {
      hasPermission = await Permissions.checkPermission(context);
    }

    if (!hasPermission) {
      homeController.openPermissionLocations();
    }
  }
}
