/// Network manager responsible for fetching data from the internet as well as
/// sending HTTP requests.
/// @author: Yizhou Zhao
/// @date: 2020-10-16 13:19
/// @lastUpdate: 2020-10-26 20:15

// Importing in-package components
import 'httpClient.dart';
import 'networkBuffer.dart';
import 'websocketClient.dart';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class HttpResponse extends http.Response{
  HttpResponse(String body, int statusCode) : super(body, statusCode);

}


class NetworkManager{
  /// attributes
  HttpClient _client;
  NetworkBuffer _buffer;
  List<WebSocketClient> _webSocketClients;

  /// constructor
  NetworkManager(String ipAddr, {bool nursingHome: true, String apiLogout:'/api/logout/'}){
    // initialize httpClient
    _client = new HttpClient(ipAddr, nursingHome: nursingHome, apiLogout:apiLogout);
    _buffer = new NetworkBuffer(capacity: 5);
  }


  /// ====== Methods ======
  /// Abstract the HttpClient.post() method
  /// Arguments:
  ///   - apiUri: String. Started and ended with '/'
  ///   - body: Dynamic. Can be String in JSON format, or Map<String, dynamic>.
  ///           Note that Map<String, dynamic> will be converted to JSON format.
  /// Return:
  ///   - Future<http.Response>
  Future<http.Response> post(String apiUri, dynamic body) async{
    print("This method is deprecated:\n\tPlease use NetworkManager.request() instead.");
    return _client.post(apiUri, body);
  }


  /// Abstract the HttpClient.get() method
  /// Arguments:
  ///   - apiUri: String. Started and ended with '/'
  /// Return:
  ///   - Future<http.Response>
  Future<http.Response> get(String apiUri) async {
    print("This method is deprecated:\n\tPlease use NetworkManager.request() instead.");
    return _client.get(apiUri);
  }

  /// Abstract the HttpClient.ping() method
  /// Arguments:
  ///   - void
  /// Return:
  ///   - Future<bool>: true if the server is available.
  Future<bool> ping() async{
    return _client.ping();
  }

  /// Close the http.Client
  void closeClient(){
    this._client.closeClient();
  }

  /// The interface for sending requests
  /// Arguments:
  ///   - method: String. The HTTP request methods.
  ///       - Currently support: GET, POST
  ///       - Non-supported methods will throw FormatException
  ///   - apiUri: String. The endpoint of the api
  ///   - body: dynamic. Request payload
  ///       - For GET requests, this argument will be ignored
  /// Return:
  ///   - http.Response: if the request is successfully delivered
  ///   - null: if the request failed to deliver. In this case, POST payload will be cached.
  Future<http.Response> request(String method, String apiUri, {dynamic body}) async{
    method = method.toUpperCase();
    http.Response response;

    // Send request based on given method.
    // Unsuccessful request will be stored in buffer.
    try{
      switch (method){
        // GET method
        case "GET": {
          response = await _client.get(apiUri);
        }break;

        // POST method
        case "POST": {
          response = await _client.post(apiUri, body);
        }break;

      // PUT method
        case "PUT": {
          response = await _client.put(apiUri, body);
        }break;

        // Non-support method will throw FormatException.
        default:{
          throw FormatException("Non-supported HTTP method: $method.\nOnly support: GET, POST");
        }break;
      }
    }on SocketException{
      // Store into the buffer
      _buffer.add(method, apiUri, body);

      // Create fake response if the server is unavailable.
      response = new http.Response("", 408);
    }

    // if server is available, send all request in the cache
    if(!_buffer.empty && response.statusCode == 200 && method != 'GET'){
      // get cache from the buffer
      List<dynamic> cache = await _buffer.cache;

      // clear cache
      _buffer.flush();

      // send request sequentially.
      for(var req in cache){
        this.request(req['method'], req['endpoint'], body:req['body']);
      }
    }

    return response;
  }

}

Future<void> main() async{
  NetworkManager manager = new NetworkManager("yizhouzhao.dev");
  print("Initing");
  var response = await manager.request("PUT", "/api/allapi/");
  assert(response.statusCode == 200, "Incorrect status code, expect 200, get ${response.statusCode}");

  print("Pass!");
}

NetworkManager networkManager;

