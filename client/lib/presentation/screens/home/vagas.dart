import 'package:flutter/material.dart';

class HomeVagas extends StatefulWidget {
  const HomeVagas({Key? key}) : super(key: key);

  @override
  _HomeVagasState createState() => _HomeVagasState();
}

class _HomeVagasState extends State<HomeVagas> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  final List<Map<String, dynamic>> _vagas = [
    {
      'titulo': 'UX Designer',
      'empresa': 'Booking',
      'local': 'Jacarta, Indonésia',
      'tipo': 'Tempo Integral',
      'salario': 'R\$1200/mês',
      'candidatos': '30 candidatos',
      'dias': '5 dias restantes',
      'descricao': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'icone': Icons.design_services,
      'corIcone': Colors.blue,
    },
    {
      'titulo': 'Analista de Dados',
      'empresa': 'Gojek',
      'local': 'Jacarta, Indonésia',
      'tipo': 'Tempo Integral',
      'salario': 'R\$2000/mês',
      'candidatos': '45 candidatos',
      'dias': '3 dias restantes',
      'descricao': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'icone': Icons.bar_chart,
      'corIcone': Colors.green,
    },
    {
      'titulo': 'Designer Visual',
      'empresa': 'Shopee',
      'local': 'Bandung, Indonésia',
      'tipo': 'Tempo Integral',
      'salario': 'R\$4000/mês',
      'candidatos': '25 candidatos',
      'dias': '7 dias restantes',
      'descricao': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'icone': Icons.palette,
      'corIcone': Colors.purple,
    },
  ];

  List<Map<String, dynamic>> get _vagasFiltradas {
    if (_searchTerm.isEmpty) return _vagas;
    return _vagas.where((vaga) {
      return vaga['titulo']
          .toString()
          .toLowerCase()
          .contains(_searchTerm.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
    final vagas = _vagasFiltradas;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Vagas Sugeridas',
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllVagasPage(vagas: _vagas),
                  ),
                ),
              ),
              _buildHorizontalList(vagas),
              const SizedBox(height: 24),
              _buildSectionHeader(
                'Vagas Recentes',
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllVagasPage(vagas: _vagas),
                  ),
                ),
              ),
              _buildVerticalList(vagas),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() => Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar vaga',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildSectionHeader(String title, {required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'Ver Todos',
              style: TextStyle(color: Color(0xFF3B82F6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, dynamic>> vagas) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vagas.length,
        itemBuilder: (context, index) {
          final vaga = vagas[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VagaDetalhePage(vaga: vaga)),
            ),
            child: Container(
              width: 260,
              margin: const EdgeInsets.only(right: 16),
              child: _buildJobCard(vaga: vaga, isHorizontal: true),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalList(List<Map<String, dynamic>> vagas) {
    return Column(
      children: vagas.map((vaga) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => VagaDetalhePage(vaga: vaga)),
          ),
          child: _buildRecentJobItem(vaga: vaga),
        );
      }).toList(),
    );
  }

  Widget _buildJobCard({required Map<String, dynamic> vaga, bool isHorizontal = false}) {
    return Card(
      color: isHorizontal ? vaga['corIcone'].withOpacity(0.1) : Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: vaga['corIcone'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(vaga['icone'], color: vaga['corIcone'], size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaga['titulo'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vaga['empresa']} • ${vaga['local']}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              vaga['descricao'],
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                _buildInfoChip(vaga['tipo'], Colors.blue),
                _buildInfoChip(vaga['salario'], Colors.grey[600]!),
              ],
            ),
            if (!isHorizontal) ...[
              const SizedBox(height: 16),
              const Divider(color: Colors.grey),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vaga['candidatos'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    vaga['dias'],
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: const Color(0xFF3B82F6),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Candidatar-se',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRecentJobItem({required Map<String, dynamic> vaga}) {
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
            Text(
              vaga['salario'],
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            vaga['tipo'],
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class AllVagasPage extends StatelessWidget {
  final List<Map<String, dynamic>> vagas;
  const AllVagasPage({Key? key, required this.vagas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todas as Vagas',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vagas.length,
        itemBuilder: (context, index) {
          final vaga = vagas[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: Icon(vaga['icone'], color: vaga['corIcone']),
            title: Text(
              vaga['titulo'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${vaga['empresa']} • ${vaga['local']}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VagaDetalhePage(vaga: vaga)),
            ),
          );
        },
      ),
    );
  }
}

class VagaDetalhePage extends StatelessWidget {
  final Map<String, dynamic> vaga;
  const VagaDetalhePage({Key? key, required this.vaga}) : super(key: key);

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