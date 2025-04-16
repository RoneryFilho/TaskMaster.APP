import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class ApiService {
  // Substitua pelo IP da sua máquina
  static const String baseUrl = 'https://192.168.5.29:7280/api/tasks'; //ip da maquina da api na rede

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar tarefas');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao criar tarefa');
    }
  }

  Future<void> updateTask(Task task) async {
    final url = '$baseUrl/${task.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao atualizar tarefa');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao deletar tarefa');
    }
  }
}
