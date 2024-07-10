double dynamicToDouble(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else if (value is String) {
    return double.parse(value);
  } else {
    throw Exception('Value is parsable to double');
  }
}