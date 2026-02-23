import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/config/theme.dart';
import 'package:job_finder/providers/auth_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final auth = context.read<AuthProvider>();
    final success = await auth.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);
    if (success && mounted) {
      context.go('/onboarding');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Blue wave header ──
            SizedBox(
              height: 240,
              child: Stack(
                children: [
                  // Back layer (darker)
                  ClipPath(
                    clipper: _WaveClipperBack(),
                    child: Container(height: 240, color: AppColors.primary),
                  ),
                  // Front layer (lighter, offset)
                  ClipPath(
                    clipper: _WaveClipperFront(),
                    child: Container(
                      height: 220,
                      color: AppColors.primary.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),

            // ── Form content ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Title
                    Text(
                      'Account Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: _inputDecoration(
                        hint: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter your email'
                          : null,
                    ),
                    const SizedBox(height: 18),

                    // Password
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
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (v.length < 6) {
                          return 'Min 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 36),

                    // Sign In button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
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
                                'Sign in',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ── Or continue with ──
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Social icons ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Apple
                        _socialIcon(
                          child: Image.asset(
                            'assets/images/Apple.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Google
                        _socialIcon(
                          child: Image.asset(
                            'assets/images/Goolge.png',
                            width: 26,
                            height: 26,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Facebook
                        _socialIcon(
                          child: Image.asset(
                            'assets/images/facebook.png',
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Have an account? Login ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account? ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared input decoration ──
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade400),
      prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 22),
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

  // ── Social circle button ──
  Widget _socialIcon({required Widget child}) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}

// ── Wave clippers ──
class _WaveClipperBack extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.72);
    path.cubicTo(
      size.width * 0.20,
      size.height * 1.05,
      size.width * 0.45,
      size.height * 0.60,
      size.width * 0.70,
      size.height * 0.80,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.92,
      size.width * 0.95,
      size.height * 0.70,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _WaveClipperFront extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.60);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.95,
      size.width * 0.50,
      size.height * 0.50,
      size.width * 0.75,
      size.height * 0.70,
    );
    path.cubicTo(
      size.width * 0.88,
      size.height * 0.80,
      size.width * 0.95,
      size.height * 0.55,
      size.width,
      size.height * 0.60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
