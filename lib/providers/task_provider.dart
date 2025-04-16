import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    try {
      _tasks = await _apiService.fetchTasks();
      notifyListeners();
    } catch (e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final newTask = await _apiService.createTask(task);
      _tasks.add(newTask);
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _apiService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      print('Erro ao remover tarefa: $e');
    }
  }

  void toggleCompletion(Task task) {
    final updatedTask = Task(
      id: task.id,
      description: task.description,
      dateTime: task.dateTime,
      priority: task.priority,
      isCompleted: !task.isCompleted,
    );
    updateTask(updatedTask);
  }
}
