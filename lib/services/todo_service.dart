import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<bool> createTodo(Map body) async {
    const url = "http://api.nstack.in/v1/todos/";
    // print(url);
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    return response.statusCode == 201;
  }

  static Future<bool> updateTodo(String id, Map body) async {
    final url = "http://api.nstack.in/v1/todos/$id";
    // print(url);
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    // print(response.statusCode);
    // print(response.body);
    return response.statusCode == 200;
  }

  static Future<bool> deleteById(String id) async {
    final url = "http://api.nstack.in/v1/todos/$id";
    // print(url);
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    // print(response.statusCode);
    // print(response.body);
    // print(id);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    // setState(() {
    //   isLoading = true;
    // });
    const url = "http://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json["items"] as List;
      return result;
    } else {
      return null;
    }
  }
}
