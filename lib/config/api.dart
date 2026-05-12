import 'package:dio/dio.dart';

const String baseUrl = "https://theclassconnect.onrender.com"; // iOS simulator
// const String baseUrl = "http://localhost:8000"; // iOS simulator
// const String baseUrl = "https://your-render-url.onrender.com"; // Production

final Dio dio = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {"Content-Type": "application/json"},
));