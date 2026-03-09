import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../theme/app_theme.dart';

// ── Palette ───────────────────────────────────────────────────────────────────

class _PaletteColor {
  final String name;
  final Color color;
  const _PaletteColor(this.name, this.color);
}

const _palette = [
  _PaletteColor('Azzurro',   Color(0xFF4ECDC4)),
  _PaletteColor('Verde',     Color(0xFF2ECC71)),
  _PaletteColor('Giallo',    Color(0xFFFFD93D)),
  _PaletteColor('Marrone',   Color(0xFF8B5E3C)),
  _PaletteColor('Rosa',      Color(0xFFFF6B9D)),
  _PaletteColor('Rosso',     Color(0xFFFF6B6B)),
  _PaletteColor('Arancione', Color(0xFFFF9F43)),
  _PaletteColor('Viola',     Color(0xFFA29BFE)),
  _PaletteColor('Grigio',    Color(0xFF95A5A6)),
  _PaletteColor('Nero',      Color(0xFF2D3436)),
];

// ── Region ────────────────────────────────────────────────────────────────────

class _Region {
  final String id;
  final String italianTarget;
  final Color targetColor;
  String? filledName;
  Color? filledColor;

  _Region({required this.id, required this.italianTarget, required this.targetColor});

  bool get isCorrect => filledName == italianTarget;
  bool get isFilled  => filledName != null;
}

// ── Scene config ──────────────────────────────────────────────────────────────

class _SceneConfig {
  final String id;
  final String name;
  final String emoji;
  final List<_Region> Function() freshRegions;
  final Path Function(String id, Size size) pathBuilder;
  final List<String> drawOrder; // back → front
  final List<String> hitOrder;  // front → back

  _SceneConfig({
    required this.id,
    required this.name,
    required this.emoji,
    required this.freshRegions,
    required this.pathBuilder,
    required this.drawOrder,
    required this.hitOrder,
  });
}

// ── Path builders ─────────────────────────────────────────────────────────────

// 1. Natura 🌿
Path _naturaPath(String id, Size s) {
  final w = s.width; final h = s.height;
  switch (id) {
    case 'sky':        return Path()..addRect(Rect.fromLTWH(0, 0, w, h * 0.52));
    case 'grass':      return Path()..addRect(Rect.fromLTWH(0, h * 0.52, w, h * 0.48));
    case 'sun':        return Path()..addOval(Rect.fromCircle(center: Offset(w * 0.78, h * 0.2), radius: w * 0.11));
    case 'treeLeaves': {
      // Rounded crown / dome shape — much more tree-like than a plain circle
      final cx = w * 0.28; final cy = h * 0.35;
      final r = w * 0.16;
      final path = Path();
      path.moveTo(cx - r * 0.75, cy + r * 0.55);
      path.quadraticBezierTo(cx - r * 1.15, cy - r * 0.2, cx, cy - r);
      path.quadraticBezierTo(cx + r * 1.15, cy - r * 0.2, cx + r * 0.75, cy + r * 0.55);
      path.lineTo(cx + r * 0.55, cy + r * 0.75);
      path.lineTo(cx - r * 0.55, cy + r * 0.75);
      path.close();
      return path;
    }
    case 'treeTrunk':  return Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.245, h * 0.49, w * 0.08, h * 0.10), const Radius.circular(4)));
    case 'flower': {
      // Pointed petal shape using bezier curves — each petal tapers at the tip
      final cx = w * 0.63; final cy = h * 0.51;
      final pLen = w * 0.10; final pW = w * 0.038;
      final path = Path();
      for (int i = 0; i < 5; i++) {
        final a = (i * 72 - 90) * pi / 180;
        final perp = a + pi / 2;
        final tipX = cx + pLen * 2 * cos(a);
        final tipY = cy + pLen * 2 * sin(a);
        final c1x = cx + pLen * cos(a) + pW * cos(perp);
        final c1y = cy + pLen * sin(a) + pW * sin(perp);
        final c2x = cx + pLen * cos(a) - pW * cos(perp);
        final c2y = cy + pLen * sin(a) - pW * sin(perp);
        path.moveTo(cx, cy);
        path.quadraticBezierTo(c1x, c1y, tipX, tipY);
        path.quadraticBezierTo(c2x, c2y, cx, cy);
      }
      path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: pW * 1.3));
      return path;
    }
    default: return Path();
  }
}

// 2. Macchina 🚗
Path _macchinaPath(String id, Size s) {
  final w = s.width; final h = s.height;
  switch (id) {
    case 'sky':  return Path()..addRect(Rect.fromLTWH(0, 0, w, h * 0.44));
    case 'road': return Path()..addRect(Rect.fromLTWH(0, h * 0.74, w, h * 0.26));
    case 'carBody': {
      // Real car silhouette: hexagonal shape with slanted windshields
      final path = Path();
      path.moveTo(w * 0.06, h * 0.71);                                           // front bottom-left
      path.lineTo(w * 0.94, h * 0.71);                                           // rear bottom-right
      path.quadraticBezierTo(w * 0.97, h * 0.71, w * 0.97, h * 0.65);          // rear bottom corner
      path.lineTo(w * 0.97, h * 0.58);                                           // rear vertical
      path.quadraticBezierTo(w * 0.95, h * 0.51, w * 0.88, h * 0.49);          // trunk slope
      path.lineTo(w * 0.72, h * 0.40);                                           // rear windshield bottom
      path.lineTo(w * 0.30, h * 0.40);                                           // front windshield bottom
      path.lineTo(w * 0.16, h * 0.49);                                           // front windshield slope
      path.quadraticBezierTo(w * 0.07, h * 0.51, w * 0.04, h * 0.58);          // hood curve
      path.lineTo(w * 0.04, h * 0.65);                                           // front vertical
      path.quadraticBezierTo(w * 0.04, h * 0.71, w * 0.06, h * 0.71);          // front bottom corner
      path.close();
      return path;
    }
    case 'carRoof': {
      // Cabin / glass area — trapezoidal roof sitting above the body
      final path = Path();
      path.moveTo(w * 0.30, h * 0.40);                                           // front base
      path.lineTo(w * 0.72, h * 0.40);                                           // rear base
      path.quadraticBezierTo(w * 0.74, h * 0.26, w * 0.67, h * 0.25);          // rear curve
      path.lineTo(w * 0.36, h * 0.25);                                           // top
      path.quadraticBezierTo(w * 0.29, h * 0.26, w * 0.30, h * 0.40);          // front curve
      path.close();
      return path;
    }
    case 'wheel1': return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.26, h * 0.78), radius: h * 0.085));
    case 'wheel2': return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.74, h * 0.78), radius: h * 0.085));
    default: return Path();
  }
}

// 3. Pizza 🍕
Path _pizzaPath(String id, Size s) {
  final w = s.width; final h = s.height;
  final cx = w / 2; final cy = h * 0.48;
  final m = w < h ? w : h;
  switch (id) {
    case 'tablecloth': return Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    case 'crust':      return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: m * 0.40));
    case 'sauce':      return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: m * 0.32));
    case 'cheese':     return Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: m * 0.24));
    case 'basil':      return Path()..addOval(Rect.fromLTWH(
        cx + m * 0.05, cy - m * 0.20, m * 0.11, m * 0.17));
    case 'olive':      return Path()..addOval(Rect.fromCircle(
        center: Offset(cx - m * 0.14, cy + m * 0.09), radius: m * 0.065));
    default: return Path();
  }
}

// 4. Spiaggia 🏖️ (sunset beach)
Path _spiaggiaPath(String id, Size s) {
  final w = s.width; final h = s.height;
  switch (id) {
    case 'sky':   return Path()..addRect(Rect.fromLTWH(0, 0, w, h * 0.50));
    case 'sea':   return Path()..addRect(Rect.fromLTWH(0, h * 0.50, w, h * 0.20));
    case 'sand':  return Path()..addRect(Rect.fromLTWH(0, h * 0.70, w, h * 0.30));
    case 'sun':   return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.50, h * 0.32), radius: w * 0.11));
    case 'fish': {
      // Teardrop body (fatter on left/head, tapering right) + V-tail on right
      final path = Path();
      final cx = w * 0.62; final cy = h * 0.58;
      final bw = w * 0.14; final bh = h * 0.055;
      // Body: fat head (left) tapering to tail junction (right)
      path.moveTo(cx - bw, cy);                              // nose (left)
      path.cubicTo(cx - bw, cy - bh * 2.2,
                   cx + bw * 0.6, cy - bh * 2.0,
                   cx + bw, cy);                             // top curve
      path.cubicTo(cx + bw * 0.6, cy + bh * 2.0,
                   cx - bw, cy + bh * 2.2,
                   cx - bw, cy);                             // bottom curve
      // Tail fin: V-shape to the right of the body
      path.moveTo(cx + bw, cy);
      path.lineTo(cx + bw * 1.9, cy - bh * 2.2);
      path.lineTo(cx + bw * 1.4, cy);
      path.lineTo(cx + bw * 1.9, cy + bh * 2.2);
      path.close();
      return path;
    }
    case 'shell': {
      // Scallop shell: fan of arcs from a base point
      final sx = w * 0.25; final sy = h * 0.80;
      final sr = w * 0.08;
      final path = Path();
      path.moveTo(sx - sr, sy);
      path.arcTo(Rect.fromCircle(center: Offset(sx, sy), radius: sr),
          pi, pi, false);
      path.close();
      return path;
    }
    default: return Path();
  }
}

// 5. Giocattoli 🎈 (toys)
Path _giocattoliPath(String id, Size s) {
  final w = s.width; final h = s.height;
  final m = w < h ? w : h;
  switch (id) {
    case 'background': return Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    case 'bigBall':    return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.28, h * 0.60), radius: m * 0.17));
    case 'littleBall': return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.72, h * 0.68), radius: m * 0.095));
    case 'balloon':    return Path()..addOval(
        Rect.fromLTWH(w * 0.62, h * 0.09, w * 0.22, h * 0.30));
    case 'block':      return Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.11, h * 0.65, w * 0.25, h * 0.22), const Radius.circular(8)));
    case 'star': {
      final cx = w * 0.3; final cy = h * 0.27;
      final outer = m * 0.13; final inner = outer * 0.42;
      final path = Path();
      for (int i = 0; i < 10; i++) {
        final angle = (i * 36 - 90) * pi / 180;
        final r = i.isEven ? outer : inner;
        final x = cx + r * cos(angle); final y = cy + r * sin(angle);
        if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
      }
      path.close();
      return path;
    }
    default: return Path();
  }
}

// 6. Cibo 🍎 (food still-life)
Path _ciboPath(String id, Size s) {
  final w = s.width; final h = s.height;
  final m = w < h ? w : h;
  switch (id) {
    case 'background': return Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    case 'table':      return Path()..addRect(Rect.fromLTWH(0, h * 0.60, w, h * 0.40));
    case 'apple': {
      // Classic apple silhouette: two lobes with a top indent and round bottom
      final cx = w * 0.30; final cy = h * 0.51;
      final r = m * 0.17;
      final path = Path();
      path.moveTo(cx, cy - r * 0.15);              // top-center indent
      path.cubicTo(cx - r * 0.35, cy - r * 1.05,
                   cx - r * 1.15, cy - r * 0.65,
                   cx - r, cy);                      // left lobe
      path.cubicTo(cx - r, cy + r,
                   cx - r * 0.15, cy + r * 1.2,
                   cx, cy + r * 1.1);               // left-bottom
      path.cubicTo(cx + r * 0.15, cy + r * 1.2,
                   cx + r, cy + r,
                   cx + r, cy);                      // right-bottom
      path.cubicTo(cx + r * 1.15, cy - r * 0.65,
                   cx + r * 0.35, cy - r * 1.05,
                   cx, cy - r * 0.15);               // right lobe back to top
      path.close();
      return path;
    }
    case 'appleStem': {
      // Slightly curved stem
      final cx = w * 0.30; final baseY = h * 0.34;
      final path = Path();
      path.moveTo(cx - w * 0.01, baseY + h * 0.04);
      path.quadraticBezierTo(cx + w * 0.025, baseY + h * 0.01, cx + w * 0.012, baseY);
      path.quadraticBezierTo(cx + w * 0.00, baseY - h * 0.005, cx - w * 0.015, baseY + h * 0.01);
      path.close();
      return path;
    }
    case 'leaf': {
      // Pointed leaf shape beside the stem
      final lx = w * 0.34; final ly = h * 0.36;
      final path = Path();
      path.moveTo(lx, ly + h * 0.03);              // base
      path.quadraticBezierTo(lx + w * 0.08, ly - h * 0.01, lx + w * 0.07, ly + h * 0.03);
      path.quadraticBezierTo(lx + w * 0.04, ly + h * 0.06, lx, ly + h * 0.03);
      path.close();
      return path;
    }
    case 'iceCream': {
      // Cone only (Giallo) — no scoop, that's a separate region
      final cx = w * 0.70;
      final r = m * 0.13;
      final coneTopY = h * 0.38 + r * 0.65;
      final path = Path();
      path.moveTo(cx - r * 0.92, coneTopY);
      path.quadraticBezierTo(cx, coneTopY - r * 0.08, cx + r * 0.92, coneTopY);
      path.lineTo(cx, h * 0.38 + r * 2.6);
      path.close();
      return path;
    }
    case 'iceCreamScoop': return Path()..addOval(Rect.fromCircle(
        center: Offset(w * 0.70, h * 0.38), radius: m * 0.13));
    default: return Path();
  }
}

// ── Scene list ────────────────────────────────────────────────────────────────

final _scenes = [
  _SceneConfig(
    id: 'natura', name: 'Natura', emoji: '🌿',
    freshRegions: () => [
      _Region(id: 'sky',        italianTarget: 'Azzurro', targetColor: const Color(0xFF4ECDC4)),
      _Region(id: 'grass',      italianTarget: 'Verde',   targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'sun',        italianTarget: 'Giallo',  targetColor: const Color(0xFFFFD93D)),
      _Region(id: 'treeLeaves', italianTarget: 'Verde',   targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'treeTrunk',  italianTarget: 'Marrone', targetColor: const Color(0xFF8B5E3C)),
      _Region(id: 'flower',     italianTarget: 'Rosa',    targetColor: const Color(0xFFFF6B9D)),
    ],
    pathBuilder: _naturaPath,
    drawOrder: ['sky', 'grass', 'treeTrunk', 'treeLeaves', 'sun', 'flower'],
    hitOrder:  ['flower', 'sun', 'treeLeaves', 'treeTrunk', 'grass', 'sky'],
  ),
  _SceneConfig(
    id: 'macchina', name: 'Macchina', emoji: '🚗',
    freshRegions: () => [
      _Region(id: 'sky',     italianTarget: 'Azzurro', targetColor: const Color(0xFF4ECDC4)),
      _Region(id: 'road',    italianTarget: 'Grigio',  targetColor: const Color(0xFF95A5A6)),
      _Region(id: 'carBody', italianTarget: 'Rosso',   targetColor: const Color(0xFFFF6B6B)),
      _Region(id: 'carRoof', italianTarget: 'Giallo',  targetColor: const Color(0xFFFFD93D)),
      _Region(id: 'wheel1',  italianTarget: 'Nero',    targetColor: const Color(0xFF2D3436)),
      _Region(id: 'wheel2',  italianTarget: 'Nero',    targetColor: const Color(0xFF2D3436)),
    ],
    pathBuilder: _macchinaPath,
    drawOrder: ['sky', 'road', 'carBody', 'carRoof', 'wheel1', 'wheel2'],
    hitOrder:  ['wheel2', 'wheel1', 'carRoof', 'carBody', 'road', 'sky'],
  ),
  _SceneConfig(
    id: 'pizza', name: 'Pizza', emoji: '🍕',
    freshRegions: () => [
      _Region(id: 'tablecloth', italianTarget: 'Giallo',    targetColor: const Color(0xFFFFD93D)),
      _Region(id: 'crust',      italianTarget: 'Marrone',   targetColor: const Color(0xFF8B5E3C)),
      _Region(id: 'sauce',      italianTarget: 'Rosso',     targetColor: const Color(0xFFFF6B6B)),
      _Region(id: 'cheese',     italianTarget: 'Arancione', targetColor: const Color(0xFFFF9F43)),
      _Region(id: 'basil',      italianTarget: 'Verde',     targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'olive',      italianTarget: 'Nero',      targetColor: const Color(0xFF2D3436)),
    ],
    pathBuilder: _pizzaPath,
    drawOrder: ['tablecloth', 'crust', 'sauce', 'cheese', 'basil', 'olive'],
    hitOrder:  ['olive', 'basil', 'cheese', 'sauce', 'crust', 'tablecloth'],
  ),
  _SceneConfig(
    id: 'spiaggia', name: 'Spiaggia', emoji: '🏖️',
    freshRegions: () => [
      _Region(id: 'sky',   italianTarget: 'Arancione', targetColor: const Color(0xFFFF9F43)),
      _Region(id: 'sea',   italianTarget: 'Azzurro',   targetColor: const Color(0xFF4ECDC4)),
      _Region(id: 'sand',  italianTarget: 'Giallo',    targetColor: const Color(0xFFFFD93D)),
      _Region(id: 'sun',   italianTarget: 'Rosso',     targetColor: const Color(0xFFFF6B6B)),
      _Region(id: 'fish',  italianTarget: 'Verde',     targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'shell', italianTarget: 'Rosa',      targetColor: const Color(0xFFFF6B9D)),
    ],
    pathBuilder: _spiaggiaPath,
    drawOrder: ['sky', 'sea', 'sand', 'sun', 'fish', 'shell'],
    hitOrder:  ['shell', 'fish', 'sun', 'sand', 'sea', 'sky'],
  ),
  _SceneConfig(
    id: 'giocattoli', name: 'Giocattoli', emoji: '🎈',
    freshRegions: () => [
      _Region(id: 'background', italianTarget: 'Viola',     targetColor: const Color(0xFFA29BFE)),
      _Region(id: 'bigBall',    italianTarget: 'Rosso',     targetColor: const Color(0xFFFF6B6B)),
      _Region(id: 'littleBall', italianTarget: 'Giallo',    targetColor: const Color(0xFFFFD93D)),
      _Region(id: 'balloon',    italianTarget: 'Rosa',      targetColor: const Color(0xFFFF6B9D)),
      _Region(id: 'block',      italianTarget: 'Verde',     targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'star',       italianTarget: 'Arancione', targetColor: const Color(0xFFFF9F43)),
    ],
    pathBuilder: _giocattoliPath,
    drawOrder: ['background', 'block', 'bigBall', 'littleBall', 'star', 'balloon'],
    hitOrder:  ['balloon', 'star', 'littleBall', 'bigBall', 'block', 'background'],
  ),
  _SceneConfig(
    id: 'cibo', name: 'Cibo', emoji: '🍎',
    freshRegions: () => [
      _Region(id: 'background',   italianTarget: 'Azzurro',  targetColor: const Color(0xFF4ECDC4)),
      _Region(id: 'table',        italianTarget: 'Marrone',  targetColor: const Color(0xFF8B5E3C)),
      _Region(id: 'apple',        italianTarget: 'Rosso',    targetColor: const Color(0xFFFF6B6B)),
      _Region(id: 'appleStem',    italianTarget: 'Marrone',  targetColor: const Color(0xFF8B5E3C)),
      _Region(id: 'leaf',         italianTarget: 'Verde',    targetColor: const Color(0xFF2ECC71)),
      _Region(id: 'iceCreamScoop',italianTarget: 'Rosa',     targetColor: const Color(0xFFFF6B9D)),
      _Region(id: 'iceCream',     italianTarget: 'Giallo',   targetColor: const Color(0xFFFFD93D)),
    ],
    pathBuilder: _ciboPath,
    drawOrder: ['background', 'table', 'iceCream', 'iceCreamScoop', 'apple', 'appleStem', 'leaf'],
    hitOrder:  ['leaf', 'appleStem', 'iceCreamScoop', 'apple', 'iceCream', 'table', 'background'],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ColoringGameScreen extends StatefulWidget {
  const ColoringGameScreen({super.key});

  @override
  State<ColoringGameScreen> createState() => _ColoringGameScreenState();
}

class _ColoringGameScreenState extends State<ColoringGameScreen> {
  int _sceneIndex = 0;
  late List<_Region> _regions;
  _PaletteColor? _selected;
  late ConfettiController _confetti;
  bool _won = false;

  _SceneConfig get _scene => _scenes[_sceneIndex];

  @override
  void initState() {
    super.initState();
    _regions = _scenes[0].freshRegions();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _switchScene(int index) {
    if (index == _sceneIndex) return;
    setState(() {
      _sceneIndex = index;
      _regions = _scenes[index].freshRegions();
      _selected = null;
      _won = false;
    });
  }

  void _onCanvasTap(Offset pos, Size size) {
    if (_selected == null || _won) return;
    for (final id in _scene.hitOrder) {
      final region = _regions.firstWhere((r) => r.id == id);
      if (_scene.pathBuilder(id, size).contains(pos)) {
        setState(() {
          region.filledName  = _selected!.name;
          region.filledColor = _selected!.color;
        });
        if (_regions.every((r) => r.isCorrect)) {
          setState(() => _won = true);
          _confetti.play();
        }
        return;
      }
    }
  }

  void _reset() {
    setState(() {
      _regions = _scene.freshRegions();
      _selected = null;
      _won = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textPrimary, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text('Color & Create!',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const Spacer(),
                      // Progress dots
                      Row(
                        children: List.generate(_regions.length, (i) {
                          final r = _regions[i];
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: r.isCorrect
                                    ? AppColors.green
                                    : r.isFilled
                                        ? AppColors.orange
                                        : Colors.grey.shade300,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // ── Scene selector ────────────────────────────────────
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: _scenes.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final scene = _scenes[i];
                      final active = i == _sceneIndex;
                      return GestureDetector(
                        onTap: () => _switchScene(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? AppColors.primary : Colors.grey.shade300,
                              width: 2,
                            ),
                            boxShadow: active
                                ? [BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    blurRadius: 8, offset: const Offset(0, 3))]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(scene.emoji, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(scene.name,
                                  style: TextStyle(
                                    color: active ? Colors.white : AppColors.textPrimary,
                                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Hint bar ──────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: _selected != null
                        ? _selected!.color.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selected?.color ?? Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selected != null) ...[
                        Container(
                          width: 20, height: 20,
                          decoration: BoxDecoration(
                            color: _selected!.color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${_selected!.name} — tap a shape!',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: AppColors.textPrimary)),
                      ] else
                        Text('Pick a colour below, then tap a shape',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                // ── Canvas ────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, constraints.maxHeight);
                        return GestureDetector(
                          onTapDown: (d) => _onCanvasTap(d.localPosition, size),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CustomPaint(
                              size: size,
                              painter: _ScenePainter(
                                regions: _regions,
                                drawOrder: _scene.drawOrder,
                                pathBuilder: _scene.pathBuilder,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Palette ───────────────────────────────────────────
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _palette.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final item = _palette[i];
                      final isSelected = _selected?.name == item.name;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = item),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.textPrimary : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: isSelected ? 40 : 34,
                                height: isSelected ? 40 : 34,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(
                                    color: item.color.withValues(alpha: 0.5),
                                    blurRadius: 6, offset: const Offset(0, 3),
                                  )],
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(item.name,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: AppColors.textPrimary,
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          // ── Win overlay ───────────────────────────────────────────────
          if (_won)
            _WinOverlay(
              sceneName: _scene.name,
              onPlayAgain: _reset,
              onNext: _sceneIndex < _scenes.length - 1
                  ? () => _switchScene(_sceneIndex + 1)
                  : null,
              onBack: () => Navigator.pop(context),
            ).animate().fadeIn(duration: 400.ms),

          // ── Confetti ──────────────────────────────────────────────────
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary, AppColors.orange, AppColors.green,
                AppColors.pink, AppColors.yellow, AppColors.blue,
              ],
              numberOfParticles: 40,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scene Painter ─────────────────────────────────────────────────────────────

class _ScenePainter extends CustomPainter {
  final List<_Region> regions;
  final List<String> drawOrder;
  final Path Function(String id, Size size) pathBuilder;

  const _ScenePainter({
    required this.regions,
    required this.drawOrder,
    required this.pathBuilder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final id in drawOrder) {
      final region = regions.firstWhere((r) => r.id == id);
      final path = pathBuilder(id, size);

      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.fill
        ..color = region.filledColor ?? Colors.grey.shade100);

      canvas.drawPath(path, Paint()
        ..style = PaintingStyle.stroke
        ..color = region.isCorrect
            ? AppColors.green.withValues(alpha: 0.8)
            : Colors.grey.shade400
        ..strokeWidth = region.isCorrect ? 2.5 : 1.8);

      if (region.isCorrect) {
        _drawCheck(canvas, path.getBounds().center, size.width * 0.04);
      } else {
        _drawLabel(canvas, region.italianTarget, path.getBounds().center, size);
      }
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset center, Size size) {
    final tp = TextPainter(
      text: TextSpan(text: text,
          style: TextStyle(color: Colors.black54, fontSize: size.width * 0.038,
              fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: center, width: tp.width + 12, height: tp.height + 6),
          const Radius.circular(8)),
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  void _drawCheck(Canvas canvas, Offset center, double sz) {
    canvas.drawCircle(center, sz * 1.2, Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill);
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - sz * 0.6, center.dy)
        ..lineTo(center.dx - sz * 0.1, center.dy + sz * 0.5)
        ..lineTo(center.dx + sz * 0.7, center.dy - sz * 0.5),
      Paint()
        ..color = Colors.white
        ..strokeWidth = sz * 0.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ScenePainter old) => old.regions != regions || old.drawOrder != drawOrder;
}

// ── Win Overlay ───────────────────────────────────────────────────────────────

class _WinOverlay extends StatelessWidget {
  final String sceneName;
  final VoidCallback onPlayAgain;
  final VoidCallback? onNext;
  final VoidCallback onBack;

  const _WinOverlay({
    required this.sceneName,
    required this.onPlayAgain,
    this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 30, offset: const Offset(0, 10),
            )],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎨', style: TextStyle(fontSize: 64))
                  .animate().scale(curve: Curves.elasticOut, duration: 700.ms,
                      begin: const Offset(0, 0)),
              const SizedBox(height: 12),
              Text('Bravissimo!',
                  style: Theme.of(context).textTheme.displayMedium
                      ?.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text('$sceneName is complete! 🌟',
                  style: Theme.of(context).textTheme.headlineMedium
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              if (onNext != null)
                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton.icon(
                    onPressed: onNext,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Next scene'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  ),
                ),
              if (onNext != null) const SizedBox(height: 10),
              SizedBox(
                width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  onPressed: onPlayAgain,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Paint again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onBack,
                child: Text('Back to home',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
