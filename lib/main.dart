// VERSÃO SEM ANIMAÇÕES
import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<TodoItem> todos = [];
  bool isAddingMode = false;
  bool showCompletedTasks = true;
  bool isRefreshing = false;
  final TextEditingController _controller = TextEditingController();

  int nextId = 1;

  void _toggleAddMode() {
    setState(() {
      isAddingMode = !isAddingMode;
      if (!isAddingMode) {
        _controller.clear();
      }
    });
  }

  void _addTodo() {
    if (_controller.text.trim().isNotEmpty) {
      final newTodo = TodoItem(
        id: nextId++,
        title: _controller.text.trim(),
        isCompleted: false,
      );

      setState(() {
        todos.add(newTodo);
        _controller.clear();
        isAddingMode = false;
      });
    }
  }

  void _toggleTodo(int id) {
    setState(() {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index] = todos[index].copyWith(
          isCompleted: !todos[index].isCompleted,
        );
      }
    });
  }

  void _deleteTodo(int id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
  }

  void _toggleShowCompleted() {
    setState(() {
      showCompletedTasks = !showCompletedTasks;
    });
  }

  Future<void> _refreshTodos() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final newTodos = [
      'Estudar Flutter',
      'Revisar apresentação',
      'Preparar demo',
      'Testar animações',
    ];

    setState(() {
      for (String title in newTodos) {
        if (!todos.any((todo) => todo.title == title)) {
          todos.insert(
            0,
            TodoItem(id: nextId++, title: title, isCompleted: false),
          );
        }
      }
      isRefreshing = false;
    });
  }

  List<TodoItem> get filteredTodos {
    return showCompletedTasks
        ? todos
        : todos.where((todo) => !todo.isCompleted).toList();
  }

  Widget _buildTodoItem(TodoItem todo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _toggleTodo(todo.id),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              border: Border.all(
                color: todo.isCompleted ? Colors.purple : Colors.grey,
                width: 2,
              ),
              color: todo.isCompleted ? Colors.purple : Colors.transparent,
            ),
            child: todo.isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              todo.isCompleted
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: todo.isCompleted ? Colors.green : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _deleteTodo(todo.id),
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: isRefreshing ? null : _refreshTodos,
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _toggleShowCompleted,
            icon: Icon(
              showCompletedTasks ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: isAddingMode ? 80 : 60,
            color: Colors.white,
            child: isAddingMode
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua tarefa...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (_) => _addTodo(),
                          autofocus: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addTodo,
                        icon: const Icon(Icons.check),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: _toggleAddMode,
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ],
                  )
                : Center(
                    child: ElevatedButton.icon(
                      onPressed: _toggleAddMode,
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Tarefa'),
                    ),
                  ),
          ),

          Expanded(
            child: filteredTodos.isEmpty
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma tarefa encontrada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      return _buildTodoItem(filteredTodos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  final int id;
  final String title;
  final bool isCompleted;

  const TodoItem({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  TodoItem copyWith({int? id, String? title, bool? isCompleted}) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
