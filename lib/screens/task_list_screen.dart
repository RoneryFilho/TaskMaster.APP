import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/task_provider.dart';
import '../widgets/task_item.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _selectedDate;
  final Set<String> _selectedPriorities = {};

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).loadTasks();
  }

  void _openDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _togglePriority(String priority) {
    setState(() {
      if (_selectedPriorities.contains(priority)) {
        _selectedPriorities.remove(priority);
      } else {
        _selectedPriorities.add(priority);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    final filteredTasks = provider.tasks.where((task) {
      final searchMatch = task.description
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());

      final dateMatch = _selectedDate == null
          ? true
          : task.dateTime.year == _selectedDate!.year &&
          task.dateTime.month == _selectedDate!.month &&
          task.dateTime.day == _selectedDate!.day;

      final priorityMatch = _selectedPriorities.isEmpty
          ? true
          : _selectedPriorities.contains(task.priority);

      return searchMatch && dateMatch && priorityMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskMaster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.loadTasks(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _openDatePicker,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar por descrição...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Alta', 'Média', 'Baixa'].map((priority) {
                    final isSelected = _selectedPriorities.contains(priority);
                    return FilterChip(
                      label: Text(priority),
                      selected: isSelected,
                      onSelected: (_) => _togglePriority(priority),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: filteredTasks.isEmpty
          ? const Center(child: Text('Nenhuma tarefa encontrada.'))
          : ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (ctx, index) => TaskItem(task: filteredTasks[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
