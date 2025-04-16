import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster_app/providers/task_provider.dart';
import 'package:taskmaster_app/screens/task_list_screen.dart';
import 'package:flutter/services.dart';
import 'utils/http_overrides.dart'; // Se estiver usando SSL no backend

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Use isso apenas se estiver lidando com SSL local (ex: cert autoassinado)
  HttpOverrides.global = MyHttpOverrides();

  runApp(const TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TaskMaster',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const TaskListScreen(),
      ),
    );
  }
}
