// lib/implicity_example.dart
import 'package:flutter/material.dart';

void main() => runApp(const ImplicitAnimationsApp());

class ImplicitAnimationsApp extends StatelessWidget {
  const ImplicitAnimationsApp({super.key});

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
        title: const Text('Animações Implícitas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '4 Exemplos de Animações Implícitas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            _buildNavigationButton(
              context,
              'AnimatedContainer',
              'Layout e estilo animados',
              Icons.crop_square,
              Colors.red,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnimatedContainerExample(),
                ),
              ),
            ),

            _buildNavigationButton(
              context,
              'AnimatedOpacity',
              'Visibilidade animada',
              Icons.visibility,
              Colors.green,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnimatedOpacityExample(),
                ),
              ),
            ),

            _buildNavigationButton(
              context,
              'AnimatedAlign',
              'Posicionamento animado',
              Icons.my_location,
              Colors.orange,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnimatedAlignExample()),
              ),
            ),

            _buildNavigationButton(
              context,
              'AnimatedSwitcher',
              'Transição entre widgets',
              Icons.swap_horiz,
              Colors.purple,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnimatedSwitcherExample(),
                ),
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

// 1. AnimatedContainer Example
class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key});

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedContainer'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: isExpanded ? 200 : 100,
              height: isExpanded ? 200 : 100,
              decoration: BoxDecoration(
                color: isExpanded ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(isExpanded ? 50 : 10),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(isExpanded ? 'Diminuir' : 'Expandir'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Anima tamanho, cor e border radius\nautomaticamente!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. AnimatedOpacity Example
class AnimatedOpacityExample extends StatefulWidget {
  const AnimatedOpacityExample({super.key});

  @override
  State<AnimatedOpacityExample> createState() => _AnimatedOpacityExampleState();
}

class _AnimatedOpacityExampleState extends State<AnimatedOpacityExample> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedOpacity'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: isVisible ? 1.0 : 0.0,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(75),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: Text(isVisible ? 'Esconder' : 'Mostrar'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Fade in/out suave\nsem precisar de controller!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. AnimatedAlign Example
class AnimatedAlignExample extends StatefulWidget {
  const AnimatedAlignExample({super.key});

  @override
  State<AnimatedAlignExample> createState() => _AnimatedAlignExampleState();
}

class _AnimatedAlignExampleState extends State<AnimatedAlignExample> {
  Alignment currentAlignment = Alignment.center;
  int positionIndex = 0;

  final List<Alignment> positions = [
    Alignment.center,
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ];

  final List<String> positionNames = [
    'Centro',
    'Superior Esquerda',
    'Superior Direita',
    'Inferior Esquerda',
    'Inferior Direita',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedAlign'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 800),
                alignment: currentAlignment,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Posição: ${positionNames[positionIndex]}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      positionIndex = (positionIndex + 1) % positions.length;
                      currentAlignment = positions[positionIndex];
                    });
                  },
                  child: const Text('Mover Bola'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reposiciona elementos suavemente\ndentro do container!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 4. AnimatedSwitcher Example
class AnimatedSwitcherExample extends StatefulWidget {
  const AnimatedSwitcherExample({super.key});

  @override
  State<AnimatedSwitcherExample> createState() =>
      _AnimatedSwitcherExampleState();
}

class _AnimatedSwitcherExampleState extends State<AnimatedSwitcherExample> {
  int currentIndex = 0;

  final List<Widget> widgets = [
    Container(
      key: const ValueKey(0),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(60),
      ),
      child: const Icon(Icons.home, color: Colors.white, size: 50),
    ),
    Container(
      key: const ValueKey(1),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.teal,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.work, color: Colors.white, size: 50),
    ),
    Container(
      key: const ValueKey(2),
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.indigo,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.favorite, color: Colors.white, size: 50),
    ),
  ];

  final List<String> widgetNames = [
    'Casa (Círculo)',
    'Trabalho (Quadrado)',
    'Favorito (Círculo)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedSwitcher'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: widgets[currentIndex],
            ),
            const SizedBox(height: 40),
            Text(
              widgetNames[currentIndex],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = (currentIndex + 1) % widgets.length;
                });
              },
              child: const Text('Próximo Widget'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transição suave entre\nwidgets completamente diferentes!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
