class ConnectService {
  Future<bool> connect(required : String requestId, required :String connectorId) async {
    // Simulate a network request
    await Future.delayed(Duration(seconds: 2));
    return true;
  }
}