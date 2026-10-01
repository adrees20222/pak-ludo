import 'package:flutter/material.dart';
import '../../models/coordinate.dart';
import '../../models/token_model.dart';

class AnimatedTokenWidget extends StatefulWidget {
  final TokenModel token;
  final Coordinate coordinate;
  final double tileSize;
  final int clusterIndex;
  final int clusterTotal;
  final VoidCallback? onTap;

  const AnimatedTokenWidget({
    super.key,
    required this.token,
    required this.coordinate,
    required this.tileSize,
    this.clusterIndex = 0,
    this.clusterTotal = 1,
    this.onTap,
  });

  @override
  State<AnimatedTokenWidget> createState() => _AnimatedTokenWidgetState();
}

class _AnimatedTokenWidgetState extends State<AnimatedTokenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sizeRatio;
    double offsetDx = 0.0;
    double offsetDy = 0.0;

    if (widget.clusterTotal <= 1) {
      sizeRatio = 0.82;
      offsetDx = 0.0;
      offsetDy = 0.0;
    } else if (widget.clusterTotal == 2) {
      sizeRatio = 0.60;
      final shift = widget.tileSize * 0.18;
      if (widget.clusterIndex == 0) {
        offsetDx = -shift;
        offsetDy = -shift;
      } else {
        offsetDx = shift;
        offsetDy = shift;
      }
    } else if (widget.clusterTotal == 3) {
      sizeRatio = 0.52;
      final shift = widget.tileSize * 0.20;
      if (widget.clusterIndex == 0) {
        offsetDx = 0.0;
        offsetDy = -shift;
      } else if (widget.clusterIndex == 1) {
        offsetDx = -shift;
        offsetDy = shift * 0.85;
      } else {
        offsetDx = shift;
        offsetDy = shift * 0.85;
      }
    } else {
      // 4 or more tokens
      sizeRatio = 0.46;
      final shift = widget.tileSize * 0.22;
      switch (widget.clusterIndex % 4) {
        case 0:
          offsetDx = -shift;
          offsetDy = -shift;
          break;
        case 1:
          offsetDx = shift;
          offsetDy = -shift;
          break;
        case 2:
          offsetDx = -shift;
          offsetDy = shift;
          break;
        case 3:
        default:
          offsetDx = shift;
          offsetDy = shift;
          break;
      }
    }

    final tokenSize = widget.tileSize * sizeRatio;
    final centerX = (widget.coordinate.x + 0.5) * widget.tileSize + offsetDx;
    final centerY = (widget.coordinate.y + 0.5) * widget.tileSize + offsetDy;

    // Expand touch target for active tokens to make tapping effortless
    final touchSize = widget.token.isActive
        ? (tokenSize * 1.35).clamp(widget.tileSize * 0.75, widget.tileSize * 1.2)
        : tokenSize;
    final touchLeft = centerX - touchSize / 2;
    final touchTop = centerY - touchSize / 2;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutQuad,
      left: touchLeft,
      top: touchTop,
      width: touchSize,
      height: touchSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.token.isActive ? widget.onTap : null,
        child: Center(
          child: SizedBox(
            width: tokenSize,
            height: tokenSize,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = widget.token.isActive ? _scaleAnimation.value : 1.0;
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: _buildTokenVisual(tokenSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTokenVisual(double size) {
    final color = widget.token.color.color;
    final darkColor = widget.token.color.darkColor;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white.withValues(alpha: 0.9),
            color,
            darkColor,
          ],
          center: const Alignment(-0.3, -0.3),
          radius: 0.85,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
          if (widget.token.isActive)
            BoxShadow(
              color: color.withValues(alpha: 0.95),
              blurRadius: 12,
              spreadRadius: 3,
            ),
        ],
        border: Border.all(
          color: widget.token.isActive ? Colors.yellowAccent : Colors.white,
          width: widget.token.isActive ? 2.5 : 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: size * 0.38,
          height: size * 0.38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

