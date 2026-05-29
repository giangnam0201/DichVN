import 'package:flutter/material.dart';

class SpeakButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onPressed;

  const SpeakButton({
    super.key,
    required this.isListening,
    required this.onPressed,
  });

  @override
  State<SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends State<SpeakButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(SpeakButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    } else if (!widget.isListening && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        final scale = widget.isListening ? _scaleAnimation.value : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.isListening
                  ? [
                      colorScheme.error,
                      colorScheme.error.withOpacity(0.7),
                    ]
                  : [
                      colorScheme.primary,
                      colorScheme.tertiary,
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: (widget.isListening
                        ? colorScheme.error
                        : colorScheme.primary)
                    .withOpacity(0.4),
                blurRadius: widget.isListening ? 30 : 20,
                spreadRadius: widget.isListening ? 5 : 2,
              ),
            ],
          ),
          child: Icon(
            widget.isListening ? Icons.stop_rounded : Icons.mic_rounded,
            size: 64,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
