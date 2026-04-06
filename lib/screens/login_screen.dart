import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // ─── Login Handler ─────────────────────────────────────────────
  Future<void> _handleLogin() async {
    // Basic validation
    if (_emailController.text.trim().isEmpty ||
        _passController.text.trim().isEmpty) {
      _showSnackBar('Please enter your email and password.', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.signIn(
      email: _emailController.text,
      password: _passController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      // AuthWrapper handles navigation automatically
      // via authStateChanges() stream
    } else {
      _showSnackBar(result.error ?? 'Login failed.', isError: true);
    }
  }

  // ─── Forgot Password Handler ───────────────────────────────────
  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      _showSnackBar('Enter your email above to reset password.', isError: true);
      return;
    }

    final result = await _authService.resetPassword(_emailController.text);

    if (!mounted) return;

    if (result.success) {
      _showSnackBar('Password reset email sent!', isError: false);
    } else {
      _showSnackBar(
        result.error ?? 'Failed to send reset email.',
        isError: true,
      );
    }
  }

  // ─── Snackbar Helper ───────────────────────────────────────────
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ─── Logo / Header ────────────────────────────
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 80,
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Smart Faculty',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white54 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // ─── Title ────────────────────────────────────
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Email Field ──────────────────────────────
                _buildInputField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                // ─── Password Field ───────────────────────────
                _buildInputField(
                  controller: _passController,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  isDark: isDark,
                  isPassword: true,
                ),

                const SizedBox(height: 12),

                // ─── Forgot Password ──────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Login Button ─────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFF1A1A1A),
                      foregroundColor: isDark
                          ? const Color(0xFF1A1A1A)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: isDark
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Reusable Input Field ──────────────────────────────────────
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: isPassword
          ? TextInputType.text
          : TextInputType.emailAddress,
      style: TextStyle(
        color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                onPressed: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
