import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shake_gesture/shake_gesture.dart'; // Import the shake gesture package
import 'package:rocketxv3/src/login_screen/login-view.dart';
import 'package:rocketxv3/src/registration_screen/registration-view.dart';
import 'package:rocketxv3/src/splash_screen/splash-screen-view.dart';
import 'package:rocketxv3/src/view-tickets/view-tickets.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// Global key for navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return ShakeGesture(
          onShake: () {
            // Handle shake event
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shake detected!')),
            );
            // You can also navigate or perform any action here
            navigatorKey.currentState?.pushNamed('/splash');
          },
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            restorationScopeId: 'app',
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],
            theme: ThemeData(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case '/splash':
                      return SplashScreen();
                    case '/login':
                      return LoginView();
                    case '/register':
                      return RegistrationView();
                    case '/view-tickets':
                      return ViewTickets();
                    default:
                      return SplashScreen();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
