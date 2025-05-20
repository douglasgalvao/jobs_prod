import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_jobs/infrastructure/chat/pusher_service.dart';
import 'package:my_jobs/infrastructure/providers/user_provider.dart';
import 'package:my_jobs/presentation/modals/logout_confirmation_modal.dart';
import 'package:my_jobs/presentation/screens/home/vagas.dart';
import 'package:my_jobs/presentation/screens/home/buscar.dart';
import 'package:my_jobs/presentation/screens/home/perfil.dart';
import 'package:my_jobs/domain/use_cases/logout.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _pages = <Widget>[
    const HomeVagas(),
    const HomeBuscar(),
    const HomePerfil(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
    final pusherService = PusherService();
    pusherService.initPusher("1", "1");
  }
  

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: user?.photoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoUrl!),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                  ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Sidebar em desenvolvimento'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => LogoutConfirmationModal.show(
                context: context,
                onTapLogout: () => Logout.call(ref),
              ),
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Vagas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Meu perfil',
          ),
        ],
      ),
    );
  }
}
