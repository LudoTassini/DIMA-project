import 'package:bloqo/pages/main/search_page.dart';
import 'package:bloqo/pages/main/user_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app_state/user_app_state.dart';
import '../../components/navigation/bloqo_app_bar.dart';
import '../../components/navigation/bloqo_nav_bar.dart';
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
  void dispose() {
    _pageController.dispose();
    _canPopNotifier.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
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

  void _updateCanPop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _canPopNotifier.value =
          _navigatorKeys[_selectedPageIndex].currentState?.canPop() ?? false;
    });
  }

  void _pushNewPage(GlobalKey<NavigatorState> key, Widget newPage) {
    key.currentState?.push(
      MaterialPageRoute(
        builder: (context) => newPage,
      ),
    ).then((_) => _updateCanPop());
  }

  @override
  Widget build(BuildContext context) {
    late String title;
    if (!context.mounted) return const Text("Error");
    switch (_selectedPageIndex) {
      case 0:
        title = "${AppLocalizations.of(context)!.home_page_title}, ${Provider.of<UserAppState>(context, listen: false).get()!.username}!";
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
              _navigatorKeys[_selectedPageIndex]
                  .currentState
                  ?.pop();
              _updateCanPop();
            }
                : null,
          ),
          bottomNavigationBar: BloqoNavBar(
            onItemTapped: _onItemTapped,
          ),
          body: PageView(
            controller: _pageController,
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
      _buildNavigator(_navigatorKeys[0], HomePage(onPush: (newPage) => _pushNewPage(_navigatorKeys[0], newPage))),
      _buildNavigator(_navigatorKeys[1], LearnPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[1], newPage))),
      _buildNavigator(_navigatorKeys[2], SearchPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[2], newPage))),
      _buildNavigator(_navigatorKeys[3], EditorPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[3], newPage))),
      _buildNavigator(_navigatorKeys[4], UserPage(onPush: (newPage) => _pushNewPage(_navigatorKeys[4], newPage))),
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

  @override
  void didPop(Route route, Route? previousRoute) {
    canPopNotifier.value = navigator?.canPop() ?? false;
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    canPopNotifier.value = navigator?.canPop() ?? false;
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    canPopNotifier.value = navigator?.canPop() ?? false;
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    canPopNotifier.value = navigator?.canPop() ?? false;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}