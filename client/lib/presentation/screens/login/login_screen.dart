import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_jobs/infrastructure/providers/auth_provider.dart';
import 'package:my_jobs/infrastructure/providers/user_provider.dart';
import 'package:my_jobs/presentation/constants/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authProvider);
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final user = await ref.read(authProvider).signInWithGoogle();
      if (user != null) {
        await ref.read(userProvider.notifier).setUser(user);
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/chat');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha no login com Google: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGithub() async {
    // A ser implementado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF50E3C2), Color(0xFF007AFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.work_outline,
                        size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    const Text(
                      'StudentJobs',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'faça login agora mesmo',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _emailController,
                              hint: 'Nome',
                              icon: Icons.person,
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'Senha',
                              icon: Icons.lock,
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.text,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.backgroundButtonLogin,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Entrar',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.textButtonLogin)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('ou faça login com',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialIcon(FontAwesomeIcons.google, Colors.red,
                            _signInWithGoogle),
                        const SizedBox(width: 20),
                        _socialIcon(
                            FontAwesomeIcons.facebookF, Colors.blue, () {}),
                        const SizedBox(width: 20),
                        _socialIcon(FontAwesomeIcons.github, Colors.black,
                            _signInWithGithub),
                      ],
                    ),
                    const SizedBox(height: 32),
                    RichText(
                      text: TextSpan(
                        text: 'Ainda não possui uma conta? ',
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: 'Registrar',
                            style: const TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (hint == 'Senha' && value.length < 6) {
          return 'Senha deve ter pelo menos 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _socialIcon(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        icon: FaIcon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}
