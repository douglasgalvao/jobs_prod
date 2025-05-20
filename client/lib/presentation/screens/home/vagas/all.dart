import 'package:flutter/material.dart';

class VagasAll extends StatelessWidget {
  const VagasAll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todas as vagas'),
      ),
      body: const Center(
        child: Text('Aqui você pode ver todas as vagas!'),
      ),
    );
  }
}
