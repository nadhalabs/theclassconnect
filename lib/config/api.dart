import 'package:dio/dio.dart';

const String baseUrl = "https://theclassconnect.onrender.com";

final Dio dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 15),
  receiveTimeout: const Duration(seconds: 15),
  headers: {"Content-Type": "application/json"},
));