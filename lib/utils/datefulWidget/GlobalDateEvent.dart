class GlobalDateEvent {
  static List<Function(DateTime)> _listener = [];

  static registerListener(Function(DateTime) callback) =>
      _listener.add(callback);
  static unregisterListener(Function(DateTime) callback) =>
      _listener.remove(callback);

  static invokeListener(DateTime dateTime) => _listener.forEach((it) {
        it.call(dateTime);
      });
}
