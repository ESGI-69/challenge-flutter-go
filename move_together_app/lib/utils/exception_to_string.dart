String exceptionToString(dynamic e) {
  if (e is Exception) {
    return e.toString().replaceFirst('Exception: ', '');
  } else {
    return e.toString();
  }
}
