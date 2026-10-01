import '../models/player_model.dart';
import '../models/token_model.dart';
import 'board_constants.dart';
import 'path_data.dart';

class BotAI {
  static TokenModel? selectBestToken({
    required PlayerModel botPlayer,
    required List<PlayerModel> allPlayers,
    required int diceNumber,
  }) {
    final movableTokens = <TokenModel>[];

    for (final token in botPlayer.tokens) {
      if (token.hasReachedHome) continue;

      if (token.isLocked) {
        if (diceNumber == 6) {
          movableTokens.add(token);
        }
      } else {
        final targetStep = token.stepIndex + diceNumber;
        if (targetStep <= 56) {
          movableTokens.add(token);
        }
      }
    }

    if (movableTokens.isEmpty) return null;
    if (movableTokens.length == 1) return movableTokens.first;

    TokenModel? bestToken;
    double bestScore = -999999;

    for (final token in movableTokens) {
      double score = 0;

      // 1. Unlocking from base on rolling a 6
      if (token.isLocked) {
        score += 600;
        final startCoord = PathData.getCoordinate(token.color, 0);
        // Check if our own token is sitting at the start tile
        final hasOwnTokenAtStart = botPlayer.tokens.any(
            (t) => !t.isLocked && !t.hasReachedHome && t.coordinate == startCoord);
        if (hasOwnTokenAtStart) {
          score -= 100;
        }
      } else {
        final targetStep = token.stepIndex + diceNumber;
        final targetCoord = PathData.getCoordinate(token.color, targetStep);

        // 2. Reaching Home
        if (targetStep == 56) {
          score += 1000;
        }

        // 3. Capturing opponent
        if (!PathData.isHomeColumn(token.color, targetStep) &&
            !BoardConstants.isSafeCoordinate(targetCoord)) {
          bool canCapture = false;
          for (final opponent in allPlayers) {
            if (opponent.color == token.color) continue;
            for (final oppToken in opponent.tokens) {
              if (!oppToken.isLocked &&
                  !oppToken.hasReachedHome &&
                  oppToken.coordinate == targetCoord) {
                canCapture = true;
                break;
              }
            }
            if (canCapture) break;
          }
          if (canCapture) {
            score += 1200; // Highest priority: capture!
          }
        }

        // 4. Landing on a Safe Star Spot
        if (BoardConstants.isSafeCoordinate(targetCoord)) {
          score += 450;
        }

        // 5. Entering Home Run Safe Column
        if (targetStep >= 51 && token.stepIndex < 51) {
          score += 500;
        }

        // 6. Escape from behind threat
        if (!BoardConstants.isSafeCoordinate(token.coordinate) &&
            token.stepIndex < 51) {
          bool isThreatened = false;
          for (final opponent in allPlayers) {
            if (opponent.color == token.color) continue;
            for (final oppToken in opponent.tokens) {
              if (!oppToken.isLocked &&
                  !oppToken.hasReachedHome &&
                  !PathData.isHomeColumn(oppToken.color, oppToken.stepIndex)) {
                final dist = _calculateDistance(oppToken, token);
                if (dist >= 1 && dist <= 6) {
                  isThreatened = true;
                  break;
                }
              }
            }
            if (isThreatened) break;
          }
          if (isThreatened) {
            score += 350;
          }
        }

        // 7. General advancement bonus based on step progress
        score += token.stepIndex * 5.0;
      }

      if (score > bestScore) {
        bestScore = score;
        bestToken = token;
      }
    }

    return bestToken ?? movableTokens.first;
  }

  static int _calculateDistance(TokenModel chaser, TokenModel target) {
    if (chaser.isLocked || target.isLocked) return -1;
    final chaserCoord = chaser.coordinate;
    final targetCoord = target.coordinate;

    final chaserCircuitIdx = PathData.mainCircuit.indexOf(chaserCoord);
    final targetCircuitIdx = PathData.mainCircuit.indexOf(targetCoord);

    if (chaserCircuitIdx == -1 || targetCircuitIdx == -1) return -1;

    return (targetCircuitIdx - chaserCircuitIdx + 52) % 52;
  }
}
