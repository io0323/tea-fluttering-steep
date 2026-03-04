import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/tea_leaf.dart';
import '../presenters/steeping_timer_presenter.dart';
import '../state/steeping_timer_notifier.dart';

/**
 * Page that shows a steeping countdown for a tea leaf.
 */
class SteepingTimerPage extends ConsumerStatefulWidget {
  /**
   * Creates a SteepingTimerPage instance.
   */
  const SteepingTimerPage({
    required this.teaLeaf,
    super.key,
  });

  final TeaLeaf teaLeaf;

  /**
   * Creates mutable page state.
   */
  @override
  ConsumerState<SteepingTimerPage> createState() => _SteepingTimerPageState();
}

/**
 * State class for background animation and UI rendering.
 */
class _SteepingTimerPageState extends ConsumerState<SteepingTimerPage>
    with SingleTickerProviderStateMixin {
  static const SteepingTimerPresenter _presenter = SteepingTimerPresenter();
  late final AnimationController _breatheController;

  /**
   * Initializes page resources and starts breathing animation.
   */
  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  /**
   * Releases animation resources.
   */
  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  /**
   * Builds the full steeping timer UI.
   */
  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(
      steepingTimerProvider(widget.teaLeaf.defaultSteepTime),
    );
    final notifier = ref.read(
      steepingTimerProvider(widget.teaLeaf.defaultSteepTime).notifier,
    );
    final colorPalette = _paletteByTeaType(widget.teaLeaf.type);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _breatheController,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(_breatheController.value);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.lerp(colorPalette.$1, colorPalette.$2, t)!,
                  Color.lerp(colorPalette.$2, colorPalette.$3, 1 - t)!,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.teaLeaf.name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: Colors.brown.shade900),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _presenter.buildTeaMetaText(widget.teaLeaf),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.brown.shade700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _LeafBloom(progress: timerState.progress),
                    const SizedBox(height: 32),
                    Text(
                      _presenter.formatCountdown(timerState.remaining),
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: Colors.brown.shade900,
                            fontFamily: 'Times New Roman',
                            fontFeatures: const <FontFeature>[
                              FontFeature.oldstyleFigures(),
                            ],
                            letterSpacing: 1.2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _presenter.statusCaption(timerState),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.brown.shade700,
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _presenter.progressPercentText(timerState),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.brown.shade600,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FilledButton.tonal(
                          onPressed:
                              _presenter.isPrimaryActionEnabled(timerState)
                              ? () {
                                  if (timerState.isRunning) {
                                    notifier.pause();
                                    return;
                                  }
                                  notifier.start();
                                }
                              : null,
                          child: Text(
                            _presenter.primaryButtonLabel(timerState),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: notifier.reset,
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                    if (timerState.isCompleted) ...<Widget>[
                      const SizedBox(height: 20),
                      Text(
                        _presenter.buildCompletionMessage(widget.teaLeaf),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.brown.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /**
   * Returns a soft gradient palette for each tea type.
   */
  (Color, Color, Color) _paletteByTeaType(TeaType teaType) {
    switch (teaType) {
      case TeaType.green:
        return (
          const Color(0xFFDFF3DC),
          const Color(0xFFBFE4B8),
          const Color(0xFFF3FAF1),
        );
      case TeaType.black:
        return (
          const Color(0xFFFFE2BE),
          const Color(0xFFF3BC85),
          const Color(0xFFFFF1E2),
        );
      case TeaType.oolong:
        return (
          const Color(0xFFE8DCC8),
          const Color(0xFFD9BA97),
          const Color(0xFFF8F0E5),
        );
      case TeaType.herb:
        return (
          const Color(0xFFE6E2FF),
          const Color(0xFFCFC5FF),
          const Color(0xFFF6F4FF),
        );
    }
  }

}

/**
 * Widget that visualizes leaf bloom by progress.
 */
class _LeafBloom extends StatelessWidget {
  /**
   * Creates a _LeafBloom instance.
   */
  const _LeafBloom({
    required this.progress,
  });

  final double progress;

  /**
   * Renders leaf opening animation with AnimatedContainer.
   */
  @override
  Widget build(BuildContext context) {
    final width = lerpDouble(52, 128, progress) ?? 52;
    final height = lerpDouble(72, 152, progress) ?? 72;
    final radius = lerpDouble(52, 18, progress) ?? 52;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF4F7F3A),
            Color(0xFF83AA6E),
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: const Radius.circular(26),
          bottomRight: const Radius.circular(26),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
    );
  }
}

