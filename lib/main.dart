import 'package:codepriest_portfolio/features/presentation/providers/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'core/router/app_router.dart';
import 'core/utils/app_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  appLogger.info('Starting Portfolio Website');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => DownloadProvider())],
      child: MaterialApp.router(
        title: 'Uchenna Ndukwe - Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.accentPurple,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: AppColors.primaryDark,
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
