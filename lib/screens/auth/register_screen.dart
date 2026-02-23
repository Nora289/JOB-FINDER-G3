import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final fullName =
        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
    final success = await auth.register(
      fullName,
      _emailController.text.trim(),
      '',
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (success && mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Scrollable form content ──
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 70),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Text(
                        'Registration',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // ── First-name + Last-name row ──
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                  decoration: _inputDecoration(
                                    hint: 'First-name',
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                  decoration: _inputDecoration(
                                    hint: 'Last-name',
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Required'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          // ── Email or username ──
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: _inputDecoration(
                              hint: 'Email or username',
                              icon: Icons.email_outlined,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Please enter your email'
                                : null,
                          ),
                          const SizedBox(height: 18),

                          // ── Password ──
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration:
                                _inputDecoration(
                                  hint: 'Password',
                                  icon: Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (v.length < 6) {
                                return 'Min 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // ── Comfirm Password ──
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration:
                                _inputDecoration(
                                  hint: 'Comfirm Password',
                                  icon: Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.grey.shade400,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                    ),
                                  ),
                                ),
                            validator: (v) {
                              if (v != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // ── Register button ──
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Register',
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Back to Sign In ──
                          GestureDetector(
                            onTap: () => context.go('/sign-in'),
                            child: Text(
                              'Back to Sign In',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Blue wave at bottom ──
          ClipPath(
            clipper: _BottomWaveClipper(),
            child: Container(height: 120, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // ── Shared input decoration ──
  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade400),
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.grey.shade400, size: 22)
          : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      filled: false,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.55);
    path.cubicTo(
      size.width * 0.20,
      size.height * 0.10,
      size.width * 0.50,
      size.height * 0.60,
      size.width * 0.75,
      size.height * 0.20,
    );
    path.cubicTo(
      size.width * 0.88,
      size.height * 0.05,
      size.width * 0.95,
      size.height * 0.30,
      size.width,
      size.height * 0.15,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
