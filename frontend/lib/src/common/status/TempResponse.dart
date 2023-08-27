class TempResponse {
  final int statusCode;
  final Object? data;
  final String? message;
  TempResponse(this.data, this.message, {required this.statusCode});

  TempResponse.fromJson(Map<String, dynamic> json)
      : statusCode = json['statusCode'],
        data = json['data'],
        message = json['message'];

  Map<String, dynamic> toJson() =>
      {'statusCode': statusCode, 'data': data, 'message': message};
}
