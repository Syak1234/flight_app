import 'package:flutter/material.dart';

abstract class HomeService {
  Future<DateTime?> selectDate(BuildContext context, DateTime initialDate);
  Future<int?> selectPassengerCount(BuildContext context, int initialCount);
}
