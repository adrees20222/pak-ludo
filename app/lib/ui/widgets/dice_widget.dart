import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/player_color.dart';

class DiceWidget extends StatefulWidget {
  final int diceNumber;
  final bool isRolling;
  final PlayerColor color;
  final bool isEnabled;
  final VoidCallback onTap;

  const DiceWidget({
    super.key,
    required this.diceNumber,
    required this.isRolling,
    required this.color,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<DiceWidget> createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget> with SingleTickerProviderStateMixin {
  late AnimationController _rollAnimController;

  @override
  void initState() {
    super.initState();
    _rollAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void didUpdateWidget(DiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _rollAnimController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _rollAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEnabled ? widget.onTap : null,
      child: AnimatedBuilder(
        animation: _rollAnimController,
        builder: (context, child) {
          final angle = _rollAnimController.value * 4 * pi;
          final scale = widget.isRolling ? 1.0 + sin(_rollAnimController.value * pi) * 0.2 : 1.0;

          return Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: widget.isRolling ? angle : 0.0,
              child: child,
            ),
          );
        },
        child: _buildDiceFace(widget.diceNumber),
      ),
    );
  }

  Widget _buildDiceFace(int number) {
    final displayNum = widget.isRolling ? Random().nextInt(6) + 1 : (number == 0 ? 1 : number);

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.color.color,
          width: 3.0,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.color.color.withValues(alpha: widget.isEnabled ? 0.5 : 0.2),
            blurRadius: widget.isEnabled ? 12 : 4,
            spreadRadius: widget.isEnabled ? 2 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: _buildPips(displayNum),
      ),
    );
  }

  Widget _buildPips(int number) {
    final pipColor = widget.color.color;

    Widget pip() => Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: pipColor,
          ),
        );

    Widget empty() => const SizedBox(width: 9, height: 9);

    switch (number) {
      case 1:
        return Center(child: pip());
      case 2:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [pip(), const Spacer(), empty()]),
            Row(children: [empty(), const Spacer(), pip()]),
          ],
        );
      case 3:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [pip(), const Spacer(), empty()]),
            Center(child: pip()),
            Row(children: [empty(), const Spacer(), pip()]),
          ],
        );
      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
          ],
        );
      case 5:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
            Center(child: pip()),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
          ],
        );
      case 6:
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [pip(), pip()]),
          ],
        );
    }
  }
}
