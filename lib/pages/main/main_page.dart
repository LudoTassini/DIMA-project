import 'dart:async';

import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/pages/main/search_page.dart';
import 'package:bloqo/pages/main/user_page.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_state/user_app_state.dart';
import '../../components/navigation/bloqo_app_bar.dart';
import '../../components/navigation/bloqo_nav_bar.dart';
import '../../model/bloqo_user_data.dart';
import '../../utils/constants.dart';
import '../from_any/notifications_page.dart';
import 'editor_page.dart';
import 'home_page.dart';
import 'learn_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPageIndex = 0;
  late PageController _pageController;
  final ValueNotifier<bool> _canPopNotifier = ValueNotifier(false);

  int notificationCount = 0;
  Timer? _firstNotificationTimer;
  Timer? _notificationTimer;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startNotificationTimers();
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    _firstNotificationTimer?.cancel();
    _pageController.dispose();
    _canPopNotifier.dispose();
    super.dispose();
  }

  void _startNotificationTimers() {
    var localizedText = getAppLocalizations(context)!;
    BloqoUserData myself = getUserFromAppState(context: context)!;

    _firstNotificationTimer?.cancel();
    _notificationTimer?.cancel();

    _firstNotificationTimer = Timer(const Duration(seconds: 0), () async {
      await _checkForNotifications(localizedText: localizedText, userId: myself.id);
    });

    _notificationTimer = Timer.periodic(
        const Duration(seconds: Constants.notificationCheckSeconds), (timer) async {
      await _checkForNotifications(localizedText: localizedText, userId: myself.id);
    });
  }

  Future<void> _checkForNotifications({required var localizedText, required String userId}) async {
    if (!mounted) return;
    try {
      var firestore = getFirestoreFromAppState(context: context);
      List<BloqoNotificationData> notifications = await getNotificationsFromUserId(
          firestore: firestore, localizedText: localizedText, userId: userId);
      int newNotificationCount = notifications.length;
      if (mounted) {
        setState(() {
          notificationCount = newNotificationCount;
        });
      }
    } catch (_) {
      // Handle error if necessary
    }
  }

  void _onItemTapped(int index) {
    _navigateToPage(index);
  }

  void _navigateToPage(int index) {
    if (_selectedPageIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedPageIndex = index;
      });
      _pageController.jumpToPage(index);
    }
    _updateCanPop();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    _updateCanPop();
  }

  void _updateCanPop() {
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _canPopNotifier.value =
            _navigatorKeys[_selectedPageIndex].currentState?.canPop() ?? false;
      });
    }
  }

  void _pushNewPage(GlobalKey<NavigatorState> key, Widget newPage) {
    key.currentState?.push(
      MaterialPageRoute(
        builder: (context) => newPage,
      ),
    ).then((_) => _updateCanPop());
  }

  @override
  void didUpdateWidget(MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    if (!context.mounted) return const Text("Error");
    BloqoUserData myself = getUserFromAppState(context: context)!;
    var localizedText = getAppLocalizations(context)!;
    switch (_selectedPageIndex) {
      case 0:
        title = "${AppLocalizations.of(context)!.home_page_title}, ${myself.username}!";
        break;
      case 1:
        title = AppLocalizations.of(context)!.learn_page_title;
        break;
      case 2:
        title = AppLocalizations.of(context)!.search_page_title;
        break;
      case 3:
        title = AppLocalizations.of(context)!.editor_page_title;
        break;
      case 4:
        title = AppLocalizations.of(context)!.user_page_title;
        break;
      default:
        title = "Error";
        break;
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _canPopNotifier,
      builder: (context, canPop, child) {
        return Scaffold(
          appBar: BloqoAppBar.get(
              context: context,
              title: title,
              canPop: canPop,
              onPop: canPop
                  ? () {
                _navigatorKeys[_selectedPageIndex].currentState?.pop();
                _updateCanPop();
              }
                  : null,
              onNotificationIconPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationsPage(
                      onNotificationRemoved: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await _checkForNotifications(localizedText: localizedText, userId: myself.id);
                        });
                      },
                    ),
                  ),
                );
              },
              notificationCount: notificationCount
          ),
          bottomNavigationBar: BloqoNavBar(
            currentIndex: _selectedPageIndex,
            onItemTapped: _onItemTapped,
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildPageViews(),
          ),
          resizeToAvoidBottomInset: false,
        );
      },
    );
  }

  List<Widget> _buildPageViews() {
    return [
      _buildNavigator(_navigatorKeys[0], HomePage(onPush: (newPage) => _pushNewPage(_navigatorKeys[0], newPage), onNavigateToPage: _navigateToPage)),
      _buildNavigator(_navigatorKeys[1], LearnPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[1], newPage), onNavigateToPage: _navigateToPage)),
      _buildNavigator(_navigatorKeys[2], SearchPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[2], newPage), onNavigateToPage: _navigateToPage)),
      _buildNavigator(_navigatorKeys[3], EditorPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[3], newPage), onNavigateToPage: _navigateToPage)),
      _buildNavigator(_navigatorKeys[4], UserPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[4], newPage), onNavigateToPage: _navigateToPage)),
    ];
  }

  Widget _buildNavigator(GlobalKey<NavigatorState> key, Widget child) {
    return Navigator(
      key: key,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child,
        );
      },
      observers: [
        NavigatorObserverWithNotifier(_canPopNotifier),
      ],
    );
  }
}

class NavigatorObserverWithNotifier extends NavigatorObserver {
  final ValueNotifier<bool> canPopNotifier;

  NavigatorObserverWithNotifier(this.canPopNotifier);

  void _updateCanPopState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      canPopNotifier.value = navigator?.canPop() ?? false;
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _updateCanPopState();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _updateCanPopState();
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _updateCanPopState();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _updateCanPopState();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}