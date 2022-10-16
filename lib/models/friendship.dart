class Friendship {
  final String user1Id;
  final String user2Id;

  const Friendship(this.user1Id, this.user2Id);

  factory Friendship.fromData(Map<String, dynamic> data) {
    return Friendship(
      data['user1_id'] as String,
      data['user2_id'] as String,
    );
  }
}
