import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  String _currentTab = 'Home';

  void setTab(String newTab) {
    setState(() {
      _currentTab = newTab;
      _advancedDrawerController.hideDrawer();
    });
  }

  Widget _page() {
    switch (_currentTab) {
      case 'Home':
        return HomePage(controller: _advancedDrawerController);
      case 'Profile':
        return ProfilePage(controller: _advancedDrawerController);
      case 'Settings':
        return SettingsPage(controller: _advancedDrawerController);
      default:
        return HomePage(controller: _advancedDrawerController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 300),
      openRatio: 0.7,
      rtlOpening: false,
      childDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      backdrop: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.5)],
          ),
        ),
      ),
      drawer: SideBar(
        onTabChange: setTab,
        currentTab: _currentTab,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Drawer Example'),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _advancedDrawerController.showDrawer(),
          ),
        ),
        body: _page(),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final Function(String) onTabChange;
  final String currentTab;

  const SideBar({required this.onTabChange, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            selected: currentTab == 'Home',
            onTap: () => onTabChange('Home'),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            selected: currentTab == 'Profile',
            onTap: () => onTabChange('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            selected: currentTab == 'Settings',
            onTap: () => onTabChange('Settings'),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final AdvancedDrawerController controller;

  const HomePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (controller.value.visible) {
            controller.hideDrawer();
          } else {
            controller.showDrawer();
          }
        },
        child: Text(
          'Toggle Drawer from Home',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final AdvancedDrawerController controller;

  const ProfilePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (controller.value.visible) {
            controller.hideDrawer();
          } else {
            controller.showDrawer();
          }
        },
        child: Text(
          'Toggle Drawer from Profile',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final AdvancedDrawerController controller;

  const SettingsPage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (controller.value.visible) {
            controller.hideDrawer();
          } else {
            controller.showDrawer();
          }
        },
        child: Text(
          'Toggle Drawer from Settings',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
