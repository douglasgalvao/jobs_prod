import 'package:flutter/material.dart';
import 'package:my_jobs/domain/use_cases/logout.dart';
import 'package:my_jobs/infrastructure/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_jobs/presentation/modals/logout_confirmation_modal.dart';

class HomePerfil extends ConsumerWidget {
  const HomePerfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final userName = user?.displayName ?? 'Usuário';
    final userEmail = user?.email ?? 'email@example.com';
    final userProfilePicture = user?.photoUrl;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userProfilePicture != null
                      ? NetworkImage(userProfilePicture)
                      : null,
                  child: userProfilePicture == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userEmail,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Lista de opções com ícones
            Expanded(
              child: ListView.separated(
                itemCount: _menuItems.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (context, index) {
                  final item = _menuItems[index];
                  return ListTile(
                    leading: Icon(item.icon, color: Colors.grey[600]),
                    title: Text(item.title),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _navigateTo(context, item.route),
                  );
                },
              ),
            ),

            // Botão de saída com ícone
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => LogoutConfirmationModal.show(
                context: context,
                onTapLogout: () => Logout.call(ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    if (route == '/vagas-salvas') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VagasSalvasPage()),
      );
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  static const List<MenuItem> _menuItems = [
    MenuItem(Icons.favorite, 'Favoritos', '/favoritos'),
    MenuItem(Icons.bookmark, 'Vagas Salvas', '/vagas-salvas'),
    MenuItem(Icons.language, 'Idiomas', '/idiomas'),
    MenuItem(Icons.location_on, 'Localização', '/localizacao'),
    MenuItem(Icons.palette, 'Aparência', '/aparencia'),
    MenuItem(Icons.history, 'Histórico', '/historico'),
  ];
}

class VagasSalvasPage extends StatelessWidget {
  final List<Map<String, dynamic>> _vagasSalvas = [
    {
      'titulo': 'UX Designer',
      'empresa': 'Booking',
      'local': 'Jacarta, Indonésia',
      'tipo': 'Tempo Integral',
      'salario': 'R\$1200/mês',
      'descricao': 'Descrição detalhada da vaga...',
      'candidatos': '30 candidatos',
      'dias': '5 dias restantes',
      'icone': Icons.design_services,
      'corIcone': Colors.blue,
      'isSaved': true,
    },
    {
      'titulo': 'Analista de Dados',
      'empresa': 'Gojek',
      'local': 'Jacarta, Indonésia',
      'tipo': 'Tempo Integral',
      'salario': 'R\$2000/mês',
      'descricao': 'Descrição detalhada da vaga...',
      'candidatos': '45 candidatos',
      'dias': '3 dias restantes',
      'icone': Icons.bar_chart,
      'corIcone': Colors.green,
      'isSaved': true,
    },
  ];

  VagasSalvasPage({super.key});

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vagas Salvas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _vagasSalvas.length,
        itemBuilder: (context, index) {
          final vaga = _vagasSalvas[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: vaga['corIcone'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(vaga['icone'], color: vaga['corIcone'], size: 28),
              ),
              title: Text(
                vaga['titulo'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${vaga['empresa']} • ${vaga['local']}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildInfoChip(vaga['tipo'], Colors.blue),
                      _buildInfoChip(vaga['salario'], Colors.grey[600]!),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                Icons.bookmark,
                color: vaga['isSaved'] ? Colors.blue : Colors.grey,
                size: 28,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VagaDetalhePage(vaga: vaga),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VagaDetalhePage extends StatelessWidget {
  final Map<String, dynamic> vaga;
  const VagaDetalhePage({super.key, required this.vaga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vaga['titulo'],
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: vaga['corIcone'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(vaga['icone'], color: vaga['corIcone'], size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaga['empresa'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vaga['local'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              vaga['descricao'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalhes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tipo: ${vaga['tipo']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Salário: ${vaga['salario']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Candidatos: ${vaga['candidatos']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Prazo: ${vaga['dias']}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String route;

  const MenuItem(this.icon, this.title, this.route);
}
