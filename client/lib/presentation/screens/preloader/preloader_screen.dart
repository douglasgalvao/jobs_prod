import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({Key? key}) : super(key: key);

  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends State<PreloaderScreen>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _rotateAnim;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnim;

  int _phase = 0; 

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );
    _rotateAnim = Tween(begin: 0.0, end: 3 * pi / 4).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeOutBack),
    );

    _iconController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(milliseconds: 100));
        await _iconController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _phase = 1);
        _fadeController.forward();
      }
    });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/lottie');
      }
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _iconController.forward();
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final iconSize = w * 0.12;  // 12% da largura
    final logoSize = w * 0.25;  // 25% da largura

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_phase == 0)
            Center(
              child: AnimatedBuilder(
                animation: _iconController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateAnim.value,
                    child: Transform.scale(
                      scale: _scaleAnim.value,
                      child: child,
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/images/mala_logo.svg',
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),

          if (_phase == 1)
            FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF53E0C2), Color(0xFF6900FD)],
                    stops: [0.36, 1.0],
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
