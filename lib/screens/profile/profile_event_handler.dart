class ProfileEventHandler {
  /// list to save all listeners in
  List<Function(bool)> _listeners = [];
  List<Function(String)> _usernameListener = [];

  /// Adds a new [listener] for editChanged
  void subscribe(Function(bool) listener) {
    _listeners.add(listener);
  }

  /// Adds a new [listener] for usernameChanged
  void subscribeUsername(Function(String) listener) {
    _usernameListener.add(listener);
  }

  /// Removes a [listener] (for editChanged) if that listener exists
  bool unsubscribe(Function(bool) listener) {
    return _listeners.remove(listener);
  }

  /// Removes a [listener] (for usernameChanged) if that listener exists
  bool unsubscribeUsername(Function(String) listener) {
    return _usernameListener.remove(listener);
  }

  /// Broadcast new State to all listeners.<br>
  /// The provided value is stateless, meaning "true" may be submitted twice in a row.<br>
  /// [isEdit] the value to broadcast
  void broadcastState(bool isEdit) {
    _listeners.forEach((listener) {
      listener.call(isEdit);
    });
  }

  /// Broadcast new State to all listeners.<br>
  /// The provided value is stateless, meaning "true" may be submitted twice in a row.<br>
  /// [username] the value to broadcast
  void broadcastUsernameState(String username) {
    _usernameListener.forEach((listener) {
      listener.call(username);
    });
  }
}
