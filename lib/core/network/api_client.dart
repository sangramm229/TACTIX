class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = 'http://10.0.2.2:8000/api/v1'});

  // In Phase 7, this will handle HTTP communication with the FastAPI backend.
  bool get isMockMode => true;
}
