import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

/// The Madrassti app shell.
class MadrasstiApp extends StatefulWidget {
  const MadrasstiApp({super.key});

  @override
  State<MadrasstiApp> createState() => _MadrasstiAppState();
}

class _MadrasstiAppState extends State<MadrasstiApp> {
  late final _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Madrassti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      routerConfig: _router,
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      // French only for now. The layouts are built with directional insets so
      // an Arabic RTL locale can be added without reworking them.
      locale: const Locale('fr'),
    );
  }
}
