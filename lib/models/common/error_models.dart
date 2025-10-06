class KiteErrorMessage {
  final String status;
  final String message;
  final dynamic data;
  final String errorType;

  KiteErrorMessage({
    required this.status,
    required this.message,
    this.data,
    required this.errorType,
  });

  factory KiteErrorMessage.fromJson(Map<String, dynamic> json) =>
      KiteErrorMessage(
        errorType: json['error_type'],
        status: json['status'],
        message: json['message'],
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
    'error_type': errorType,
    'status': status,
    'message': message,
    if (data != null) 'data': data,
  };
}

sealed class KiteError implements Exception {}

class KiteHttpError implements KiteError {
  final KiteErrorMessage kiteErrorMessage;

  KiteHttpError(this.kiteErrorMessage);

  @override
  String toString() => 'KiteHttpError: ${kiteErrorMessage.toJson()}';
}
