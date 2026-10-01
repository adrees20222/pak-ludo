import 'package:flutter/material.dart';
import '../../game/board_constants.dart';
import '../../game/game_engine.dart';
import '../../models/player_color.dart';
import '../../models/player_model.dart';
import '../../models/token_model.dart';
import '../theme/app_theme.dart';
import 'game_screen.dart';

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  int _playerCount = 2;
  bool _hasSavedMatch = false;

  final Map<PlayerColor, TextEditingController> _nameControllers = {
    PlayerColor.red: TextEditingController(text: 'Player 1'),
    PlayerColor.green: TextEditingController(text: 'Player 2'),
    PlayerColor.yellow: TextEditingController(text: 'Player 3'),
    PlayerColor.blue: TextEditingController(text: 'Player 4'),
  };

  final Map<PlayerColor, bool> _botStatus = {
    PlayerColor.red: false,
    PlayerColor.green: true,
    PlayerColor.yellow: true,
    PlayerColor.blue: true,
  };

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final hasSave = await GameEngine.hasSavedGame();
    if (mounted) {
      setState(() {
        _hasSavedMatch = hasSave;
      });
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<PlayerColor> get _activeColors {
    switch (_playerCount) {
      case 2:
        return [PlayerColor.red, PlayerColor.yellow];
      case 3:
        return [PlayerColor.red, PlayerColor.green, PlayerColor.yellow];
      case 4:
      default:
        return [PlayerColor.red, PlayerColor.green, PlayerColor.yellow, PlayerColor.blue];
    }
  }

  void _startGame() {
    final active = _activeColors;
    final players = <PlayerModel>[];

    bool hasHuman = false;
    for (int i = 0; i < active.length; i++) {
      final color = active[i];
      final name = _nameControllers[color]!.text.trim().isEmpty
          ? 'Player ${i + 1}'
          : _nameControllers[color]!.text.trim();
      final isBot = _botStatus[color] ?? false;
      if (!isBot) hasHuman = true;

      final tokens = List.generate(4, (id) {
        final yardCoord = BoardConstants.baseYardCoords[color]![id];
        return TokenModel(
          id: id,
          color: color,
          coordinate: yardCoord,
          isLocked: true,
          stepIndex: -1,
        );
      });

      players.add(PlayerModel(
        name: name,
        color: color,
        isBot: isBot,
        tokens: tokens,
      ));
    }

    if (!hasHuman) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There must be at least one human player!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final engine = GameEngine();
    engine.startNewGame(initialPlayers: players);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(engine: engine),
      ),
    );
  }

  Future<void> _loadGame() async {
    final engine = GameEngine();
    final loaded = await engine.loadSavedGame();
    if (!mounted) return;

    if (loaded) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(engine: engine),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No saved match found or file corrupted.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Player Count Segment
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [2, 3, 4].map((count) {
                    final isSelected = _playerCount == count;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _playerCount = count),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              '$count Players',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.textDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Player Inputs
              ...active.map((color) => _buildPlayerRow(color)),

              const SizedBox(height: 28),

              // Start Match Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 6,
                    shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.4),
                  ),
                  onPressed: _startGame,
                  child: const Text(
                    'START GAME',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

              if (_hasSavedMatch) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  icon: const Icon(Icons.restore_rounded, color: AppTheme.primaryGreen),
                  label: const Text(
                    'or, resume last game',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGreen,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressed: _loadGame,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerRow(PlayerColor color) {
    final isBot = _botStatus[color] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black38, width: 1.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _nameControllers[color],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
                fontSize: 15,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Player Name',
                hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),
          ),
          IconButton(
            tooltip: isBot ? 'Switch to Human Player' : 'Switch to Bot Player',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(isBot),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isBot ? const Color(0xFFF1F5F9) : AppTheme.primaryGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isBot ? const Color(0xFFCBD5E1) : AppTheme.primaryGreen,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  isBot ? Icons.smart_toy_rounded : Icons.person_rounded,
                  color: isBot ? const Color(0xFF64748B) : AppTheme.primaryGreen,
                  size: 22,
                ),
              ),
            ),
            onPressed: () {
              setState(() {
                _botStatus[color] = !isBot;
              });
            },
          ),
        ],
      ),
    );
  }
}
