// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavtra_ui_test/core/services/api_service.dart';
import 'package:mavtra_ui_test/features/login/bloc/auth_bloc.dart';
import 'package:mavtra_ui_test/features/splash/views/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';
import 'core/services/auth_service.dart';
import 'features/bottom_nav_bar/views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Add a small delay to ensure platform is fully ready
  await Future.delayed(const Duration(milliseconds: 100));

  // Initialize APIService - it will automatically load saved base URL from SharedPreferences
  // or use default URL if none is saved
  await APIServiceSingleton.initialize(
    connectTimeout: 30000,
    receiveTimeout: 30000,
    sendTimeout: 30000,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authService: AuthService(), // AuthService will use the initialized APIServiceSingleton.instance
          ),
        ),
        // Add other BLoCs here as your app grows
        // BlocProvider<OtherBloc>(
        //   create: (context) => OtherBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Mavtra App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'Inter',
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            iconTheme: IconThemeData(color: AppColors.primary),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}