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

class LeaderboardOptions {
  LeaderboardType type;
  LeaderboardTimeRange timeRange;

  LeaderboardOptions(this.type, this.timeRange);
}
