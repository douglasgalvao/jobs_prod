import 'package:flutter/material.dart';

class VagasFavoritadas extends StatefulWidget {
  const VagasFavoritadas({super.key});

  @override
  State<VagasFavoritadas> createState() => _VagasFavoritadasState();
}

class _VagasFavoritadasState extends State<VagasFavoritadas> {
  final List<Map<String, dynamic>> vagasFavoritadas = [
    {'titulo': 'Analista de dados', 'local': 'Remoto', 'isSaved': true},
    {'titulo': 'Desenvolvedor Flutter', 'local': 'São Paulo', 'isSaved': false},
    {'titulo': 'Product Manager', 'local': 'Remoto', 'isSaved': true},
    {'titulo': 'Product Manager', 'local': 'Presencial', 'isSaved': false},
    {'titulo': 'Desenvolvedor Backend', 'local': 'Remoto', 'isSaved': true},
    {'titulo': 'Desenvolvedor Frontend', 'local': 'São Paulo', 'isSaved': false},
    {'titulo': 'Analista de Marketing', 'local': 'Remoto', 'isSaved': true},
    {'titulo': 'Designer Gráfico', 'local': 'São Paulo', 'isSaved': false},
    {'titulo': 'Gerente de Projetos', 'local': 'Remoto', 'isSaved': true},
    {'titulo': 'Analista de Suporte', 'local': 'São Paulo', 'isSaved': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vagas favoritadas'),
      ),
      body: ListView.builder(
        itemCount: vagasFavoritadas.length,
        itemBuilder: (context, index) {
          final vaga = vagasFavoritadas[index];
          return ListTile(
            leading: Container(
              width: 50.0,
              height: 50.0,
              color: Colors.grey,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(vaga['titulo']),
            subtitle: Text(vaga['local']),
            trailing: IconButton(
              icon: Icon(
                vaga['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
              ),
              onPressed: () {
                setState(() {
                  vaga['isSaved'] = !vaga['isSaved'];
                });
              },
            ),
            onTap: () {
              // ação ao clicar
            },
          );
        },
      ),
    );
  }
}