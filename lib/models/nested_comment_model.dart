class NestedComment {
  final String commentId;
  final String parentId;
  final String postId;
  final String username;
  final String text;
  final DateTime createdAt;
  final String userId;
  final String profilePic;
  NestedComment({
    required this.commentId,
    required this.parentId,
    required this.postId,
    required this.username,
    required this.text,
    required this.createdAt,
    required this.userId,
    required this.profilePic,
  });

  NestedComment copyWith({
    String? commentId,
    String? parentId,
    String? postId,
    String? username,
    String? text,
    DateTime? createdAt,
    String? userId,
    String? profilePic,
  }) {
    return NestedComment(
      commentId: commentId ?? this.commentId,
      parentId: parentId ?? this.parentId,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'commentId': commentId});
    result.addAll({'parentId': parentId});
    result.addAll({'postId': postId});
    result.addAll({'username': username});
    result.addAll({'text': text});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'userId': userId});
    result.addAll({'profilePic': profilePic});

    return result;
  }

  factory NestedComment.fromMap(Map<String, dynamic> map) {
    return NestedComment(
      commentId: map['commentId'] ?? '',
      parentId: map['parentId'] ?? '',
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      userId: map['userId'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  @override
  String toString() {
    return 'NestedComment(commentId: $commentId, parentId: $parentId, postId: $postId, username: $username, text: $text, createdAt: $createdAt, userId: $userId, profilePic: $profilePic)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NestedComment &&
        other.commentId == commentId &&
        other.parentId == parentId &&
        other.postId == postId &&
        other.username == username &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        parentId.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        profilePic.hashCode;
  }
}
