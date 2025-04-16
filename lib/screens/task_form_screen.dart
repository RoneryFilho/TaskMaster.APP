import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _description;
  late DateTime _dateTime;
  late String _priority;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _description = widget.task!.description;
      _dateTime = widget.task!.dateTime;
      _priority = widget.task!.priority;
      _isCompleted = widget.task!.isCompleted;
    } else {
      _description = '';
      _dateTime = DateTime.now();
      _priority = 'Baixa';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final task = Task(
        id: widget.task?.id ?? 0,
        description: _description,
        dateTime: _dateTime.toUtc(),
        priority: _priority,
        isCompleted: _isCompleted,
      );

      final provider = Provider.of<TaskProvider>(context, listen: false);
      if (widget.task == null) {
        provider.addTask(task);
      } else {
        provider.updateTask(task);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Obrigatório' : null,
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _priority,
                items: ['Baixa', 'Média', 'Alta']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: 'Prioridade'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Data: ${_dateTime.toLocal().toString().split('.')[0]}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
              SwitchListTile(
                title: const Text('Concluída'),
                value: _isCompleted,
                onChanged: (value) =>
                    setState(() => _isCompleted = value),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
    );
    if (time == null) return;

    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
}
