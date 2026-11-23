// Renders a contact sheet of the shared primitives to PNG, so the drawing can
// be eyeballed against the mockups. Not an assertion test.
import 'dart:io';
import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:madrassti_app/core/theme/app_colors.dart';
import 'package:madrassti_app/core/theme/app_text_styles.dart';
import 'package:madrassti_app/core/theme/app_subjects.dart';
import 'package:madrassti_app/core/widgets/app_icon.dart';
import 'package:madrassti_app/core/widgets/app_icon_paths.dart';
import 'package:madrassti_app/core/widgets/subject_tile.dart';
import 'package:madrassti_app/core/widgets/zitoun.dart';

Future<void> _dump(WidgetTester tester, Finder finder, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(finder);
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2.0);
    final data = await image.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  final out = File('build/preview/$name.png')
    ..parent.createSync(recursive: true);
  out.writeAsBytesSync(bytes!);
}

void main() {
  testWidgets('icon sheet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(840, 420));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          color: AppColors.white,
          child: RepaintBoundary(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(12),
            child: DefaultTextStyle(
              style: const TextStyle(color: AppColors.navy, fontSize: 9),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final name in kIconShapes.keys)
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          AppIcon(name, size: 32),
                          Text(name, maxLines: 1),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
    await _dump(tester, find.byType(RepaintBoundary).first, 'icons');
  });

  testWidgets('zitoun moods', (tester) async {
    await tester.binding.setSurfaceSize(const Size(560, 220));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          color: AppColors.white,
          child: RepaintBoundary(
          child: Container(
            color: AppColors.background,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Zitoun(size: 180, mood: ZitounMood.content),
                Zitoun(size: 180, mood: ZitounMood.salut),
                Zitoun(size: 180, mood: ZitounMood.bravo),
              ],
            ),
            ),
          ),
        ),
      ),
    );
    await _dump(tester, find.byType(RepaintBoundary).first, 'zitoun');
  });

  testWidgets('type sample', (tester) async {
    await tester.binding.setSurfaceSize(const Size(700, 340));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          color: AppColors.white,
          child: RepaintBoundary(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('madrassti', style: AppTextStyles.logo.copyWith(
                  color: AppColors.navy)),
                Text('Bonjour Samia — éveil scientifique',
                    style: AppTextStyles.h1),
                Text('La journée de Yassine', style: AppTextStyles.h6),
                Text('Les enseignants répondent entre 8h et 17h.',
                    style: AppTextStyles.body),
                Text('Nunito 800 · ÀÉÈÇÏÔÛ', style: AppTextStyles.button),
                Text('مدرستي', style: AppTextStyles.baloo(size: 34,
                    color: AppColors.danger)),
                Text('النص : في السوق', style: AppTextStyles.baloo(size: 24)),
                Text('glyphes élève : ☀ ✿', style: AppTextStyles.h4),
              ],
            ),
            ),
          ),
        ),
      ),
    );
    await _dump(tester, find.byType(RepaintBoundary).first, 'type');
  });

  testWidgets('subject tiles', (tester) async {
    await tester.binding.setSurfaceSize(const Size(520, 110));
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          color: AppColors.white,
          child: RepaintBoundary(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final s in Subject.values) SubjectTile(subject: s, size: 64),
              ],
            ),
            ),
          ),
        ),
      ),
    );
    await _dump(tester, find.byType(RepaintBoundary).first, 'subjects');
  });
}
