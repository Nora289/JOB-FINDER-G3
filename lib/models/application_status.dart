enum ApplicationStatusType {
  applied,
  reviewing,
  interview,
  rejected,
  accepted,
}

class ApplicationStatus {
  final String jobId;
  final ApplicationStatusType status;
  final DateTime appliedDate;
  final DateTime? lastUpdated;
  final String? notes;
  final List<StatusUpdate> timeline;

  ApplicationStatus({
    required this.jobId,
    required this.status,
    required this.appliedDate,
    this.lastUpdated,
    this.notes,
    List<StatusUpdate>? timeline,
  }) : timeline = timeline ?? [
    StatusUpdate(
      status: ApplicationStatusType.applied,
      date: appliedDate,
      message: 'Application submitted successfully',
    ),
  ];

  ApplicationStatus copyWith({
    ApplicationStatusType? status,
    DateTime? lastUpdated,
    String? notes,
    List<StatusUpdate>? timeline,
  }) {
    return ApplicationStatus(
      jobId: jobId,
      status: status ?? this.status,
      appliedDate: appliedDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      notes: notes ?? this.notes,
      timeline: timeline ?? this.timeline,
    );
  }

  String get statusText {
    switch (status) {
      case ApplicationStatusType.applied:
        return 'Applied';
      case ApplicationStatusType.reviewing:
        return 'Under Review';
      case ApplicationStatusType.interview:
        return 'Interview Scheduled';
      case ApplicationStatusType.rejected:
        return 'Not Selected';
      case ApplicationStatusType.accepted:
        return 'Offer Received';
    }
  }

  String get statusDescription {
    switch (status) {
      case ApplicationStatusType.applied:
        return 'Your application has been submitted';
      case ApplicationStatusType.reviewing:
        return 'Employer is reviewing your application';
      case ApplicationStatusType.interview:
        return 'Interview has been scheduled';
      case ApplicationStatusType.rejected:
        return 'Application was not successful';
      case ApplicationStatusType.accepted:
        return 'Congratulations! You received an offer';
    }
  }
}

class StatusUpdate {
  final ApplicationStatusType status;
  final DateTime date;
  final String message;

  StatusUpdate({
    required this.status,
    required this.date,
    required this.message,
  });
}
