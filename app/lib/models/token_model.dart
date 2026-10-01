import 'coordinate.dart';
import 'player_color.dart';

class TokenModel {
  final int id;
  final PlayerColor color;
  final Coordinate coordinate;
  final bool isLocked;
  final bool hasReachedHome;
  final int stepIndex; // -1 if in base yard, 0..56 on path (56 = Home)
  final bool isActive; // highlighted for move selection

  const TokenModel({
    required this.id,
    required this.color,
    required this.coordinate,
    this.isLocked = true,
    this.hasReachedHome = false,
    this.stepIndex = -1,
    this.isActive = false,
  });

  TokenModel copyWith({
    int? id,
    PlayerColor? color,
    Coordinate? coordinate,
    bool? isLocked,
    bool? hasReachedHome,
    int? stepIndex,
    bool? isActive,
  }) {
    return TokenModel(
      id: id ?? this.id,
      color: color ?? this.color,
      coordinate: coordinate ?? this.coordinate,
      isLocked: isLocked ?? this.isLocked,
      hasReachedHome: hasReachedHome ?? this.hasReachedHome,
      stepIndex: stepIndex ?? this.stepIndex,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color.name,
        'coordinate': coordinate.toJson(),
        'isLocked': isLocked,
        'hasReachedHome': hasReachedHome,
        'stepIndex': stepIndex,
      };

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'] as int,
      color: PlayerColor.values.firstWhere((e) => e.name == json['color']),
      coordinate: Coordinate.fromJson(json['coordinate'] as Map<String, dynamic>),
      isLocked: json['isLocked'] as bool,
      hasReachedHome: json['hasReachedHome'] as bool,
      stepIndex: json['stepIndex'] as int,
    );
  }
}
