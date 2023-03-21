import 'package:customer/providers/auth.dart';
import 'package:customer/providers/bookings.dart';
import 'package:customer/providers/location.dart';
import 'package:customer/providers/search.dart';
import 'package:customer/screens/firstscreen.dart';
import 'package:customer/screens/individualsalondisplayscreen.dart';
import 'package:customer/screens/loginscreen.dart';
import 'package:customer/screens/profilescreen.dart';
import 'package:customer/screens/registerscreen.dart';
import 'package:customer/screens/searchresultscreen.dart';
import 'package:customer/screens/searchscreen.dart';
import 'package:customer/screens/selecttiming.dart';
import 'package:customer/screens/successscreen.dart';
import 'package:customer/screens/tabsscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: LocationState(),
        ),
        ChangeNotifierProxyProvider<Auth, Search>(
          create: ((context) => Search("", "", "")),
          update: ((context, value, previous) => Search(
                value.isAuth,
                value.username,
                value.userId,
              )),
        ),
        ChangeNotifierProxyProvider<Auth, Bookings>(
          create: ((context) => Bookings("", "", "")),
          update: ((context, value, previous) => Bookings(
                value.isAuth,
                value.username,
                value.userId,
              )),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth.isNotEmpty
              ? const TabsScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: ((context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const FirstScreen()),
                ),
          routes: {
            TabsScreen.routeName: (context) => const TabsScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            FirstScreen.routeName: (context) => const FirstScreen(),
            RegistrationScreen.routeName: (context) =>
                const RegistrationScreen(),
            IndividualSalonDisplayScreen.routeName: (context) =>
                const IndividualSalonDisplayScreen(),
            SelectTiming.routeName: (context) => const SelectTiming(),
            SearchResultScreen.routeName: (context) =>
                const SearchResultScreen(),
            SuccessScreen.routeName: (context) => const SuccessScreen(),
          },
        ),
      ),
    );
  }
}
