import 'package:flutter/material.dart';
import '../../game/game_engine.dart';
import '../../models/token_model.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_token_widget.dart';
import '../widgets/dice_widget.dart';
import '../widgets/ludo_board_painter.dart';
import '../widgets/player_card_widget.dart';
import '../widgets/sound_toggle_button.dart';
import '../widgets/victory_dialog.dart';
import 'player_setup_screen.dart';

class GameScreen extends StatefulWidget {
  final GameEngine engine;

  const GameScreen({super.key, required this.engine});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _hasShownVictoryDialog = false;

  @override
  void initState() {
    super.initState();
    widget.engine.addListener(_onEngineUpdate);
  }

  @override
  void dispose() {
    widget.engine.removeListener(_onEngineUpdate);
    super.dispose();
  }

  void _onEngineUpdate() {
    if (widget.engine.isGameFinished && !_hasShownVictoryDialog) {
      _hasShownVictoryDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showVictoryDialog();
      });
    }
  }

  void _showVictoryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return VictoryDialog(
          finishOrder: widget.engine.finishOrder,
          onPlayAgain: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
            );
          },
          onClose: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Exit Match?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to exit? Your progress will be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Exit to Home'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ListenableBuilder(
            listenable: widget.engine,
            builder: (context, _) {
              final engine = widget.engine;
              final currentPlayer = engine.currentPlayer;

              return Column(
                children: [
                  // Top Action Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 28, color: AppTheme.textDark),
                          onPressed: () async {
                            final shouldExit = await _confirmExit();
                            if (shouldExit && context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          tooltip: 'Exit Game',
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: currentPlayer.color.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: currentPlayer.color.color, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: currentPlayer.color.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${currentPlayer.name}'s Turn",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: currentPlayer.color.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SoundToggleButton(),
                      ],
                    ),
                  ),

                  // Player Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: engine.players.map((p) {
                        return PlayerCardWidget(
                          player: p,
                          isCurrentTurn: p.color == currentPlayer.color,
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(),

                  // Responsive 15x15 Game Board
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final availableWidth = constraints.maxWidth;
                        final availableHeight = MediaQuery.of(context).size.height * 0.52;
                        final boardSize = availableWidth < availableHeight ? availableWidth : availableHeight;
                        final tileSize = boardSize / 15.0;

                        return Center(
                          child: Container(
                            width: boardSize,
                            height: boardSize,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Vector Background Board
                                CustomPaint(
                                  size: Size(boardSize, boardSize),
                                  painter: LudoBoardPainter(),
                                ),
                                // Animated & Clustered Tokens with Z-Index Priority
                                ...() {
                                  final allTokens = engine.players.expand((p) => p.tokens).toList();

                                  // Group tokens by tile coordinates to compute offsets for multiple tokens on same tile
                                  final Map<String, List<TokenModel>> clusterMap = {};
                                  for (final token in allTokens) {
                                    final coord = (engine.isAnimatingToken &&
                                            engine.animatingToken?.id == token.id &&
                                            engine.animatingToken?.color == token.color &&
                                            engine.animatingCurrentCoord != null)
                                        ? engine.animatingCurrentCoord!
                                        : token.coordinate;

                                    final key = '${coord.x.round()}_${coord.y.round()}';
                                    clusterMap.putIfAbsent(key, () => []).add(token);
                                  }

                                  // Sort tokens for optimal Z-Ordering in Stack:
                                  // 1. Inactive tokens (bottom)
                                  // 2. Active (movable) tokens (brought to top so they can always be seen and tapped)
                                  // 3. Actively moving/animating token (very top)
                                  final sortedTokens = List<TokenModel>.from(allTokens)..sort((a, b) {
                                    final isAnimA = engine.isAnimatingToken && engine.animatingToken?.id == a.id && engine.animatingToken?.color == a.color;
                                    final isAnimB = engine.isAnimatingToken && engine.animatingToken?.id == b.id && engine.animatingToken?.color == b.color;
                                    if (isAnimA) return 1;
                                    if (isAnimB) return -1;

                                    if (a.isActive && !b.isActive) return 1;
                                    if (!a.isActive && b.isActive) return -1;

                                    return 0;
                                  });

                                  return sortedTokens.map((token) {
                                    final coord = (engine.isAnimatingToken &&
                                            engine.animatingToken?.id == token.id &&
                                            engine.animatingToken?.color == token.color &&
                                            engine.animatingCurrentCoord != null)
                                        ? engine.animatingCurrentCoord!
                                        : token.coordinate;

                                    final key = '${coord.x.round()}_${coord.y.round()}';
                                    final cluster = clusterMap[key] ?? [token];
                                    final clusterIndex = cluster.indexOf(token);
                                    final clusterTotal = cluster.length;

                                    return AnimatedTokenWidget(
                                      key: ValueKey('${token.color.name}_${token.id}'),
                                      token: token,
                                      coordinate: coord,
                                      clusterIndex: clusterIndex >= 0 ? clusterIndex : 0,
                                      clusterTotal: clusterTotal,
                                      tileSize: tileSize,
                                      onTap: () {
                                        engine.moveToken(token);
                                      },
                                    );
                                  });
                                }(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Bottom Controls (Dice & Turn Prompt)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: currentPlayer.color.color.withValues(alpha: 0.4),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: currentPlayer.color.color.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                currentPlayer.isBot
                                    ? '🤖 Bot is thinking...'
                                    : (engine.diceNumber == 0
                                        ? '🎲 Tap the dice to roll'
                                        : '✨ Tap a glowing token to move'),
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              if (currentPlayer.consecutiveSixes > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '🔥 Consecutive 6s: ${currentPlayer.consecutiveSixes}/3',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // 3D Dice
                        DiceWidget(
                          diceNumber: engine.diceNumber,
                          isRolling: engine.isRolling,
                          color: currentPlayer.color,
                          isEnabled: !currentPlayer.isBot &&
                              !engine.isRolling &&
                              !engine.isAnimatingToken &&
                              engine.diceNumber == 0,
                          onTap: () {
                            engine.rollDice();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
