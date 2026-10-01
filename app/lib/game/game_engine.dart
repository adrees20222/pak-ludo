import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/coordinate.dart';
import '../models/player_model.dart';
import '../models/token_model.dart';
import 'board_constants.dart';
import 'bot_ai.dart';
import 'path_data.dart';
import 'sound_service.dart';

class GameEngine extends ChangeNotifier {
  List<PlayerModel> _players = [];
  int _currentPlayerIndex = 0;
  int _diceNumber = 0;
  bool _isRolling = false;
  bool _isAnimatingToken = false;
  bool _isGameFinished = false;
  final List<PlayerModel> _finishOrder = [];
  DateTime? _matchStartTime;
  TokenModel? _animatingToken;
  Coordinate? _animatingCurrentCoord;

  // Getters
  List<PlayerModel> get players => _players;
  int get currentPlayerIndex => _currentPlayerIndex;
  PlayerModel get currentPlayer => _players[_currentPlayerIndex];
  int get diceNumber => _diceNumber;
  bool get isRolling => _isRolling;
  bool get isAnimatingToken => _isAnimatingToken;
  bool get isGameFinished => _isGameFinished;
  List<PlayerModel> get finishOrder => _finishOrder;
  DateTime? get matchStartTime => _matchStartTime;
  TokenModel? get animatingToken => _animatingToken;
  Coordinate? get animatingCurrentCoord => _animatingCurrentCoord;

  // Initialize a new game
  void startNewGame({required List<PlayerModel> initialPlayers}) {
    _players = initialPlayers;
    _currentPlayerIndex = 0;
    _diceNumber = 0;
    _isRolling = false;
    _isAnimatingToken = false;
    _isGameFinished = false;
    _finishOrder.clear();
    _matchStartTime = DateTime.now();
    _animatingToken = null;
    _animatingCurrentCoord = null;

    _saveGameState();
    notifyListeners();

    // If first player is bot, trigger bot roll after slight delay
    if (currentPlayer.isBot) {
      triggerBotTurn();
    }
  }

  // Roll dice
  Future<void> rollDice() async {
    if (_isRolling || _isAnimatingToken || _isGameFinished || _diceNumber > 0) {
      return;
    }

    _isRolling = true;
    SoundService.instance.playDiceRoll();
    notifyListeners();

    // Dice roll animation delay
    await Future.delayed(const Duration(milliseconds: 650));

    final random = Random();
    final rolled = random.nextInt(6) + 1;
    _diceNumber = rolled;
    _isRolling = false;

    // Check consecutive sixes
    int sixCount = currentPlayer.consecutiveSixes;
    if (rolled == 6) {
      sixCount++;
    } else {
      sixCount = 0;
    }

    _players[_currentPlayerIndex] = currentPlayer.copyWith(consecutiveSixes: sixCount);

    if (sixCount >= 3) {
      // Penalty: lose turn on 3 consecutive sixes
      _players[_currentPlayerIndex] = currentPlayer.copyWith(consecutiveSixes: 0);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 600));
      _nextTurn();
      return;
    }

    // Determine movable tokens
    final movable = _getMovableTokens(currentPlayer, rolled);

    if (movable.isEmpty) {
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 700));
      _nextTurn();
      return;
    }

    // Mark movable tokens active
    _highlightMovableTokens(movable);
    notifyListeners();

    // Bot decision or Auto-move if only 1 token is movable
    if (currentPlayer.isBot) {
      await Future.delayed(const Duration(milliseconds: 400));
      final best = BotAI.selectBestToken(
        botPlayer: currentPlayer,
        allPlayers: _players,
        diceNumber: rolled,
      );
      if (best != null) {
        await moveToken(best);
      } else {
        _nextTurn();
      }
    } else if (movable.length == 1 && movable.first.isLocked && rolled == 6) {
      // Auto-unlock human token if only one is in base
      await Future.delayed(const Duration(milliseconds: 300));
      await moveToken(movable.first);
    }
  }

  List<TokenModel> _getMovableTokens(PlayerModel player, int roll) {
    final list = <TokenModel>[];
    for (final token in player.tokens) {
      if (token.hasReachedHome) continue;
      if (token.isLocked) {
        if (roll == 6) list.add(token);
      } else {
        if (token.stepIndex + roll <= 56) {
          list.add(token);
        }
      }
    }
    return list;
  }

  void _highlightMovableTokens(List<TokenModel> movable) {
    final updatedTokens = currentPlayer.tokens.map((t) {
      final isMov = movable.any((m) => m.id == t.id);
      return t.copyWith(isActive: isMov);
    }).toList();
    _players[_currentPlayerIndex] = currentPlayer.copyWith(tokens: updatedTokens);
  }

  void _clearActiveTokens() {
    final updatedTokens = currentPlayer.tokens.map((t) => t.copyWith(isActive: false)).toList();
    _players[_currentPlayerIndex] = currentPlayer.copyWith(tokens: updatedTokens);
  }

  // Move token
  Future<void> moveToken(TokenModel token) async {
    if (_isAnimatingToken || _isGameFinished || _diceNumber == 0) return;

    _clearActiveTokens();
    _isAnimatingToken = true;
    _animatingToken = token;
    notifyListeners();

    final roll = _diceNumber;
    _diceNumber = 0; // Reset dice

    bool grantedExtraTurn = (roll == 6);
    bool capturedOpponent = false;
    bool tokenReachedHome = false;

    if (token.isLocked && roll == 6) {
      // Unlock token to start square
      final startCoord = PathData.getCoordinate(token.color, 0);
      SoundService.instance.playSafeSpot();
      _animatingCurrentCoord = startCoord;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 250));

      _updateTokenState(token.copyWith(
        isLocked: false,
        stepIndex: 0,
        coordinate: startCoord,
        isActive: false,
      ));
    } else if (!token.isLocked) {
      // Move token forward step-by-step
      final startStep = token.stepIndex;
      final targetStep = startStep + roll;

      for (int step = startStep + 1; step <= targetStep; step++) {
        final coord = PathData.getCoordinate(token.color, step);
        _animatingCurrentCoord = coord;
        SoundService.instance.playTokenStep();
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 140));
      }

      final finalCoord = PathData.getCoordinate(token.color, targetStep);
      final reachedHome = (targetStep == 56);
      tokenReachedHome = reachedHome;

      if (reachedHome) {
        SoundService.instance.playSafeSpot();
        grantedExtraTurn = true;
      } else if (BoardConstants.isSafeCoordinate(finalCoord)) {
        SoundService.instance.playSafeSpot();
      }

      _updateTokenState(token.copyWith(
        stepIndex: targetStep,
        coordinate: finalCoord,
        hasReachedHome: reachedHome,
        isActive: false,
      ));

      // Capture logic
      if (!reachedHome &&
          !PathData.isHomeColumn(token.color, targetStep) &&
          !BoardConstants.isSafeCoordinate(finalCoord)) {
        for (int pIdx = 0; pIdx < _players.length; pIdx++) {
          if (_players[pIdx].color == token.color) continue;
          final oppPlayer = _players[pIdx];
          final List<TokenModel> oppTokens = [];
          bool didCapture = false;

          for (final oppToken in oppPlayer.tokens) {
            if (!oppToken.isLocked &&
                !oppToken.hasReachedHome &&
                oppToken.coordinate == finalCoord) {
              // Send back to base yard
              final yardCoord = BoardConstants.baseYardCoords[oppToken.color]![oppToken.id];
              oppTokens.add(oppToken.copyWith(
                isLocked: true,
                stepIndex: -1,
                coordinate: yardCoord,
              ));
              didCapture = true;
            } else {
              oppTokens.add(oppToken);
            }
          }

          if (didCapture) {
            capturedOpponent = true;
            grantedExtraTurn = true;
            SoundService.instance.playCapture();
            _players[pIdx] = oppPlayer.copyWith(tokens: oppTokens);
          }
        }
      }
    }

    _isAnimatingToken = false;
    _animatingToken = null;
    _animatingCurrentCoord = null;

    // Check if current player has finished
    if (currentPlayer.hasFinished && !_finishOrder.any((p) => p.color == currentPlayer.color)) {
      final elapsed = _matchStartTime != null
          ? DateTime.now().difference(_matchStartTime!).inMilliseconds
          : 0;
      _players[_currentPlayerIndex] = currentPlayer.copyWith(finishTimeMs: elapsed);
      _finishOrder.add(_players[_currentPlayerIndex]);
      SoundService.instance.playVictory();
    }

    // Check if game is completely finished (all or all but one player finished)
    final remainingActive = _players.where((p) => !p.hasFinished).toList();
    if (remainingActive.length <= 1) {
      if (remainingActive.isNotEmpty &&
          !_finishOrder.any((p) => p.color == remainingActive.first.color)) {
        _finishOrder.add(remainingActive.first);
      }
      _isGameFinished = true;
      _clearSaveGame();
      SoundService.instance.playVictory();
      notifyListeners();
      return;
    }

    _saveGameState();
    notifyListeners();

    if (grantedExtraTurn || capturedOpponent || tokenReachedHome) {
      // Same player rolls again
      if (currentPlayer.isBot) {
        triggerBotTurn();
      }
    } else {
      _nextTurn();
    }
  }

  void _updateTokenState(TokenModel updated) {
    final playerTokens = currentPlayer.tokens.map((t) {
      return t.id == updated.id ? updated : t;
    }).toList();
    _players[_currentPlayerIndex] = currentPlayer.copyWith(tokens: playerTokens);
  }

  void _nextTurn() {
    _clearActiveTokens();
    _diceNumber = 0;

    int nextIdx = (_currentPlayerIndex + 1) % _players.length;
    while (_players[nextIdx].hasFinished && !_isGameFinished) {
      nextIdx = (nextIdx + 1) % _players.length;
    }

    _currentPlayerIndex = nextIdx;
    _saveGameState();
    notifyListeners();

    if (currentPlayer.isBot && !_isGameFinished) {
      triggerBotTurn();
    }
  }

  Future<void> triggerBotTurn() async {
    if (_isGameFinished) return;
    await Future.delayed(const Duration(milliseconds: 600));
    if (_diceNumber == 0 && !_isRolling && !_isAnimatingToken) {
      await rollDice();
    }
  }

  // Persistence
  static const _saveKey = 'pak_ludo_active_save';

  Future<void> _saveGameState() async {
    if (_isGameFinished) {
      _clearSaveGame();
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final map = {
        'players': _players.map((p) => p.toJson()).toList(),
        'currentPlayerIndex': _currentPlayerIndex,
        'finishOrder': _finishOrder.map((p) => p.toJson()).toList(),
        'startTime': _matchStartTime?.millisecondsSinceEpoch,
      };
      await prefs.setString(_saveKey, jsonEncode(map));
    } catch (_) {}
  }

  Future<void> _clearSaveGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_saveKey);
    } catch (_) {}
  }

  static Future<bool> hasSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_saveKey);
  }

  Future<bool> loadSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_saveKey);
      if (raw == null) return false;

      final map = jsonDecode(raw) as Map<String, dynamic>;
      _players = (map['players'] as List)
          .map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
          .toList();
      _currentPlayerIndex = map['currentPlayerIndex'] as int? ?? 0;
      _finishOrder.clear();
      if (map['finishOrder'] != null) {
        _finishOrder.addAll((map['finishOrder'] as List)
            .map((p) => PlayerModel.fromJson(p as Map<String, dynamic>)));
      }
      final st = map['startTime'] as int?;
      _matchStartTime = st != null ? DateTime.fromMillisecondsSinceEpoch(st) : DateTime.now();
      _diceNumber = 0;
      _isRolling = false;
      _isAnimatingToken = false;
      _isGameFinished = false;

      notifyListeners();

      if (currentPlayer.isBot) {
        triggerBotTurn();
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
