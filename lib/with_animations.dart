// VERSÃO COM ANIMAÇÕES
import 'dart:math';
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

class _TodoHomePageState extends State<TodoHomePage>
    with TickerProviderStateMixin {
  final List<TodoItem> todos = [];
  bool isAddingMode = false;
  bool showCompletedTasks = true;
  bool isRefreshing = false;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late AnimationController _refreshController;
  late AnimationController _slideController;
  late AnimationController _iconController;

  int nextId = 1;

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _slideController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  void _toggleAddMode() {
    setState(() {
      isAddingMode = !isAddingMode;
      if (!isAddingMode) {
        _controller.clear();
        _slideController.reverse();
      } else {
        _slideController.forward();
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

      _listKey.currentState?.insertItem(
        _getFilteredIndex(todos.length - 1),
        duration: const Duration(milliseconds: 300),
      );

      _slideController.reverse();
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
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    final filteredIndex = _getFilteredIndex(todoIndex);
    final removedTodo = todos[todoIndex];

    setState(() {
      todos.removeAt(todoIndex);
    });

    _listKey.currentState?.removeItem(
      filteredIndex,
      (context, animation) => _buildTodoItem(removedTodo, animation),
      duration: const Duration(milliseconds: 300),
    );
  }

  void _toggleShowCompleted() {
    setState(() {
      showCompletedTasks = !showCompletedTasks;
    });
    if (_iconController.status == AnimationStatus.completed) {
      _iconController.reverse();
    } else {
      _iconController.forward();
    }
  }

  Future<void> _refreshTodos() async {
    setState(() {
      isRefreshing = true;
    });

    _refreshController.repeat();

    await Future.delayed(const Duration(seconds: 2));

    final newTodos = [
      'Estudar Flutter',
      'Revisar apresentação',
      'Preparar demo',
      'Testar animações',
    ];

    int itemsAdded = 0;
    for (String title in newTodos) {
      if (!todos.any((todo) => todo.title == title)) {
        final newTodo = TodoItem(
          id: nextId++,
          title: title,
          isCompleted: false,
        );

        setState(() {
          todos.insert(itemsAdded, newTodo);
        });

        _listKey.currentState?.insertItem(
          itemsAdded,
          duration: const Duration(milliseconds: 400),
        );

        itemsAdded++;

        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    _refreshController.stop();
    _refreshController.reset();

    setState(() {
      isRefreshing = false;
    });
  }

  List<TodoItem> get filteredTodos {
    return showCompletedTasks
        ? todos
        : todos.where((todo) => !todo.isCompleted).toList();
  }

  int _getFilteredIndex(int originalIndex) {
    if (showCompletedTasks) return originalIndex;

    int filteredIndex = 0;
    for (int i = 0; i < originalIndex && i < todos.length; i++) {
      if (!todos[i].isCompleted) {
        filteredIndex++;
      }
    }
    return filteredIndex;
  }

  Widget _buildTodoItem(TodoItem todo, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => _toggleTodo(todo.id),
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
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: todo.isCompleted
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Icon(
                  todo.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: todo.isCompleted ? Colors.green : Colors.grey,
                  size: 20,
                ),
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
          AnimatedBuilder(
            animation: _refreshController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshController.value * 2 * pi,
                child: IconButton(
                  onPressed: isRefreshing ? null : _refreshTodos,
                  icon: const Icon(Icons.refresh),
                ),
              );
            },
          ),
          IconButton(
            onPressed: _toggleShowCompleted,
            icon: AnimatedIcon(
              icon: AnimatedIcons.view_list,
              progress: _iconController,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(16),
            height: isAddingMode ? 80 : 60,
            color: Colors.white,
            child: isAddingMode
                ? SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, -1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _slideController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: Row(
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
                    ),
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
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: const ValueKey('empty'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: filteredTodos.isEmpty ? 1.0 : 0.0,
                          child: const Icon(
                            Icons.task_alt,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhuma tarefa encontrada',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedList(
                      key: _listKey,
                      padding: const EdgeInsets.all(16),
                      initialItemCount: filteredTodos.length,
                      itemBuilder: (context, index, animation) {
                        if (index >= filteredTodos.length) return Container();
                        return _buildTodoItem(filteredTodos[index], animation);
                      },
                    ),
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
