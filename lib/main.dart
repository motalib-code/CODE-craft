import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase init
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SharedPreferences init
  await StorageService.init();

  runApp(const ProviderScope(child: CodeCraftApp()));
}

class CodeCraftApp extends ConsumerWidget {
  const CodeCraftApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CodeCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        if (kIsWeb) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0818),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.bg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: child!,
                ),
              ),
            ),
          );
        }
        return child!;
      },
    );
  }
}
