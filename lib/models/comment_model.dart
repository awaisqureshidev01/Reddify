class Comment {
  final String id;
  final String text;
  final String postId;
  final String username;
  final String profilePic;
  final String userId;
  final DateTime createdAt;
  Comment({
    required this.id,
    required this.text,
    required this.postId,
    required this.username,
    required this.profilePic,
    required this.userId,
    required this.createdAt,
  });

  Comment copyWith({
    String? id,
    String? text,
    String? postId,
    String? username,
    String? profilePic,
    String? userId,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'text': text});
    result.addAll({'postId': postId});
    result.addAll({'username': username});
    result.addAll({'profilePic': profilePic});
    result.addAll({'userId': userId});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
      userId: map['userId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, postId: $postId, username: $username, profilePic: $profilePic, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic &&
        other.userId == userId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode ^
        userId.hashCode ^
        createdAt.hashCode;
  }
}
