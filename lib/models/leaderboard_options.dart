import 'package:equatable/equatable.dart';

enum LeaderboardType { world, friends }

enum LeaderboardTimeRange { all, week, month }

extension EnumExtension on LeaderboardTimeRange {
  String getOrderColumn() {
    switch (this) {
      case LeaderboardTimeRange.month:
        return "xp_this_month";
      case LeaderboardTimeRange.week:
        return "xp_this_week";
      default:
        return "xp";
    }
  }
}

class LeaderboardOptions extends Equatable {
  final LeaderboardType type;
  final LeaderboardTimeRange timeRange;

  const LeaderboardOptions(this.type, this.timeRange);

  LeaderboardOptions copyWith({LeaderboardType? type, LeaderboardTimeRange? timeRange}) {
    return LeaderboardOptions(type ?? this.type, timeRange ?? this.timeRange);
  }

  @override
  List<Object> get props => [type, timeRange];
}
