import 'player_color.dart';
import 'token_model.dart';

class PlayerModel {
  final String name;
  final PlayerColor color;
  final bool isBot;
  final List<TokenModel> tokens;
  final int consecutiveSixes;
  final int finishTimeMs;

  const PlayerModel({
    required this.name,
    required this.color,
    required this.isBot,
    required this.tokens,
    this.consecutiveSixes = 0,
    this.finishTimeMs = -1,
  });

  bool get hasFinished => tokens.every((t) => t.hasReachedHome);

  int get tokensHomeCount => tokens.where((t) => t.hasReachedHome).length;

  PlayerModel copyWith({
    String? name,
    PlayerColor? color,
    bool? isBot,
    List<TokenModel>? tokens,
    int? consecutiveSixes,
    int? finishTimeMs,
  }) {
    return PlayerModel(
      name: name ?? this.name,
      color: color ?? this.color,
      isBot: isBot ?? this.isBot,
      tokens: tokens ?? this.tokens,
      consecutiveSixes: consecutiveSixes ?? this.consecutiveSixes,
      finishTimeMs: finishTimeMs ?? this.finishTimeMs,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'color': color.name,
        'isBot': isBot,
        'tokens': tokens.map((t) => t.toJson()).toList(),
        'consecutiveSixes': consecutiveSixes,
        'finishTimeMs': finishTimeMs,
      };

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      name: json['name'] as String,
      color: PlayerColor.values.firstWhere((e) => e.name == json['color']),
      isBot: json['isBot'] as bool,
      tokens: (json['tokens'] as List)
          .map((t) => TokenModel.fromJson(t as Map<String, dynamic>))
          .toList(),
      consecutiveSixes: json['consecutiveSixes'] as int? ?? 0,
      finishTimeMs: json['finishTimeMs'] as int? ?? -1,
    );
  }
}
