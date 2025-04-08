import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'di/injection_container.dart' as di;
import 'core/utils/database_initializer.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/transaction/transaction_bloc.dart';
import 'presentation/bloc/transaction/transaction_event.dart';
import 'providers/auth_provider.dart';
import 'providers/balance_provider.dart';
import 'providers/transaction_provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // await Firebase.initializeApp();

  // Initialize the database
  try {
    // Initialize database factory for the current platform
    await DatabaseInitializer.initialize();

    // Initialize dependency injection
    await di.init();

    print("App initialized successfully");
  } catch (e) {
    print("Error initializing app: $e");
    // Provide fallback or show error dialog as needed
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<TransactionBloc>(
          create: (_) => di.sl<TransactionBloc>(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BalanceProvider()),
          ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ],
        child: Consumer<LocaleProvider>(builder: (context, localeProvider, _) {
          return MaterialApp(
            title: 'Budget App',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            theme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('mn', ''), // Mongolian
            ],
            routes: AppRouter.routes,
          );
        }),
      ),
    );
  }
}
