class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
  //here we signing a contract that this function will override the 'toString()' . It's the instance of HTTP exception thing.
}
