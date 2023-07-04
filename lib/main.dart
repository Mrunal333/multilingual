import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multilingual/cubit/locale_cubit/locale_cubit.dart';
import 'package:multilingual/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

// localization
var localization = S();

// Global navigator key
final GlobalKey<NavigatorState> navigationKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => LocaleCubit(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      buildWhen: (previousState, currentState) => previousState != currentState,
      builder: (context, localeState) {
        return MaterialApp(
          navigatorKey: navigationKey,
          title: 'Localization Demo',
          locale: localeState.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            S.delegate,
            AppLocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const MyHomePage(title: 'Flutter Localization Demo'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      buildWhen: (previousState, currentState) => previousState != currentState,
      builder: (context, localeState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  S().home,
                ),
                Text(
                  S().gretting,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Change Locale'),
            onPressed: () {
              if (localeState.locale.languageCode == 'en') {
                BlocProvider.of<LocaleCubit>(context)
                    .setLocale(const Locale('hi'));
              } else {
                BlocProvider.of<LocaleCubit>(context)
                    .setLocale(const Locale('en'));
              }
            },
            tooltip: 'Change Locale',
          ),
        );
      },
    );
  }
}
