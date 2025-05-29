// lib/explicity_example.dart
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ExplicitAnimationsApp());

class ExplicitAnimationsApp extends StatelessWidget {
  const ExplicitAnimationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animações Explícitas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '4 Exemplos de Animações Explícitas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            _buildNavigationButton(
              context,
              'AnimatedBuilder',
              'Transformações visuais customizadas',
              Icons.rotate_right,
              Colors.deepOrange,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnimatedBuilderExample(),
                ),
              ),
            ),

            _buildNavigationButton(
              context,
              'AnimatedIcon',
              'Ícones animados nativos',
              Icons.play_arrow,
              Colors.cyan,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnimatedIconExample()),
              ),
            ),

            _buildNavigationButton(
              context,
              'SlideTransition',
              'Entrada e saída de elementos',
              Icons.slideshow,
              Colors.pink,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SlideTransitionExample(),
                ),
              ),
            ),

            _buildNavigationButton(
              context,
              'AnimatedList',
              'Animação em listas dinâmicas',
              Icons.list,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnimatedListExample()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(subtitle, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

// 1. AnimatedBuilder Example
class AnimatedBuilderExample extends StatefulWidget {
  const AnimatedBuilderExample({super.key});

  @override
  State<AnimatedBuilderExample> createState() => _AnimatedBuilderExampleState();
}

class _AnimatedBuilderExampleState extends State<AnimatedBuilderExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedBuilder'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Transform.scale(
                    scale: 1.0 + (_controller.value * 0.5),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Colors.deepOrange,
                          Colors.purple,
                          _controller.value,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.isAnimating) {
                      _controller.stop();
                    } else {
                      _controller.repeat();
                    }
                    setState(() {
                      isAnimating = !isAnimating;
                    });
                  },
                  child: Text(isAnimating ? 'Parar' : 'Iniciar'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller.reset();
                    setState(() {
                      isAnimating = false;
                    });
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Controle total da animação!\nRotação + Escala + Cor',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. AnimatedIcon Example
class AnimatedIconExample extends StatefulWidget {
  const AnimatedIconExample({super.key});

  @override
  State<AnimatedIconExample> createState() => _AnimatedIconExampleState();
}

class _AnimatedIconExampleState extends State<AnimatedIconExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedIcon'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.cyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(75),
                border: Border.all(color: Colors.cyan, width: 3),
              ),
              child: Center(
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: _controller,
                  size: 60,
                  color: Colors.cyan,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isPlaying = !isPlaying;
                  if (isPlaying) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(isPlaying ? 'Pausar' : 'Play'),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildIconDemo(AnimatedIcons.menu_close, 'Menu ↔ Close'),
                  _buildIconDemo(AnimatedIcons.add_event, 'Add ↔ Event'),
                  _buildIconDemo(
                    AnimatedIcons.search_ellipsis,
                    'Search ↔ More',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ícones nativos com transições\nsuaves entre estados!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconDemo(AnimatedIconData iconData, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          AnimatedIcon(
            icon: iconData,
            progress: _controller,
            size: 24,
            color: Colors.cyan,
          ),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// 3. SlideTransition Example
class SlideTransitionExample extends StatefulWidget {
  const SlideTransitionExample({super.key});

  @override
  State<SlideTransitionExample> createState() => _SlideTransitionExampleState();
}

class _SlideTransitionExampleState extends State<SlideTransitionExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Vem da direita
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SlideTransition'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.pink.withOpacity(0.1),
                            child: const Center(
                              child: Text(
                                'Área de Animação',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pink, Colors.purple],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.celebration,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Olá! 👋',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVisible = true;
                          });
                          _controller.forward();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isVisible = false;
                          });
                          _controller.reverse();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Sair'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Elementos deslizam suavemente\npara dentro e fora da tela!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. AnimatedList Example
class AnimatedListExample extends StatefulWidget {
  const AnimatedListExample({super.key});

  @override
  State<AnimatedListExample> createState() => _AnimatedListExampleState();
}

class _AnimatedListExampleState extends State<AnimatedListExample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _counter = 1;

  void _addItem() {
    final index = _items.length;
    _items.add('Item $_counter');
    _listKey.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 500),
    );
    setState(() {
      _counter++;
    });
  }

  void _removeItem(int index) {
    if (index < 0 || index >= _items.length) return; // Safety check
    final removedItem = _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildItem(removedItem, animation, isRemoving: true),
      duration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildItem(
    String item,
    Animation<double> animation, {
    bool isRemoving = false,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: SizeTransition(
        sizeFactor: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          color: isRemoving ? Colors.red.withOpacity(0.3) : null,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.teal,
              child: Text(
                item.split(' ')[1],
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(item),
            subtitle: const Text('Adicionado com animação'),
            trailing: isRemoving
                ? null
                : IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(_items.indexOf(item)),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _items.isNotEmpty
                      ? () => _removeItem(_items.length - 1)
                      : null,
                  icon: const Icon(Icons.remove),
                  label: const Text('Remover'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Lista vazia\nClique em "Adicionar" para começar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : AnimatedList(
                    key: _listKey,
                    initialItemCount:
                        _items.length, // Ensure initial count is set
                    itemBuilder: (context, index, animation) {
                      if (index >= _items.length) {
                        return const SizedBox.shrink();
                      }
                      return _buildItem(_items[index], animation);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Itens aparecem e somem com\nanimações suaves na lista!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
