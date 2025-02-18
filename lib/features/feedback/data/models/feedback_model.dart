
class FeedbackModel {
  final String id;
  final String userId;
  final String organizationId;
  final String description;
  final List<String> attachments;
  final String? voiceRecording;
  final bool isPrivate;
  final DateTime createdAt;
  final String status;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.organizationId,
    required this.description,
    this.attachments = const [],
    this.voiceRecording,
    this.isPrivate = false,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'organizationId': organizationId,
      'description': description,
      'attachments': attachments,
      'voiceRecording': voiceRecording,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['userId'],
      organizationId: json['organizationId'],
      description: json['description'],
      attachments: List<String>.from(json['attachments']),
      voiceRecording: json['voiceRecording'],
      isPrivate: json['isPrivate'],
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }
}