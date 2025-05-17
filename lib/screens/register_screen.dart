import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

 
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;
  
  
  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  
  late Animation<double> _logoAnimation;
  late Animation<double> _welcomeTextAnimation;
  late Animation<double> _formFieldsAnimation;
  late Animation<double> _passwordRequirementsAnimation;
  late Animation<double> _termsAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _loginLinkAnimation;
  
 
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  
  double _errorShakeAnimation = 0;
  bool _showErrorShake = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
    

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    
   
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));
    
  
    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    );
    
    _welcomeTextAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
    );
    
    _formFieldsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    
    _passwordRequirementsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );
    
    _termsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );
    
    _buttonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );
    
    _loginLinkAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
    );
    
    
    _animationController.forward();
  
    _fullNameFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
    _phoneFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
    _confirmPasswordFocus.addListener(_onFocusChange);
  }
  
  void _onFocusChange() {
    setState(() {
      // Just trigger a rebuild when focus changes
    });
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      
      _hasMinLength = password.length >= 8;

      
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));

     
      _hasNumber = password.contains(RegExp(r'[0-9]'));

      _hasSpecialChar = password.contains(RegExp(r'[_!@#$%^&*(),.?":{}|<->]'));

    
      _passwordsMatch = password == confirmPassword && password.isNotEmpty;
    });
  }

  bool get _isPasswordValid {
    return _hasMinLength && _hasUppercase && _hasNumber && _hasSpecialChar;
  }

  bool get _canCreateAccount {
    return _agreeToTerms &&
        _isPasswordValid &&
        _passwordsMatch &&
        _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }
  
  void _showErrorAnimation() {
    setState(() {
      _showErrorShake = true;
    });
    
   
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = -10;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = 10;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = -8;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = 8;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = -5;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = 5;
        });
      }
    });
    
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _errorShakeAnimation = 0;
          _showErrorShake = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A3A6B), Color(0xFF5A8ED0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          // Add exit animation before popping
                          _animationController.reverse().then((_) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 100 * (1 - _slideAnimation.value)),
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(24.0),
                      children: [
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _logoAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoAnimation.value,
                              child: child,
                            );
                          },
                          child: const Center(
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: FlutterLogo(size: 150),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedBuilder(
                          animation: _welcomeTextAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _welcomeTextAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _welcomeTextAnimation.value)),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Center(
                                child: Text(
                                  'Welcome to Fintechnic',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A3A6B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  'Please fill in the details to create your account',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                       
                        ..._buildAnimatedFormFields(),
                        const SizedBox(height: 20),
                      
                        AnimatedBuilder(
                          animation: _passwordRequirementsAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(300 * (1 - _passwordRequirementsAnimation.value), 0),
                              child: Opacity(
                                opacity: _passwordRequirementsAnimation.value,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Password Requirements:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A3A6B),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildAnimatedRequirement(
                                  'At least 8 characters',
                                  _hasMinLength,
                                  0.0,
                                ),
                                _buildAnimatedRequirement(
                                  'Contains uppercase letters',
                                  _hasUppercase,
                                  0.1,
                                ),
                                _buildAnimatedRequirement(
                                  'Contains numbers',
                                  _hasNumber,
                                  0.2,
                                ),
                                _buildAnimatedRequirement(
                                  'Contains special characters',
                                  _hasSpecialChar,
                                  0.3,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
         
                        AnimatedBuilder(
                          animation: _termsAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _termsAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _termsAnimation.value)),
                                child: child,
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  activeColor: const Color(0xFF5A8ED0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _agreeToTerms = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'By creating an account, you agree to our Terms of Service and Privacy Policy',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonAnimation.value,
                              child: Opacity(
                                opacity: _buttonAnimation.value,
                                child: child,
                              ),
                            );
                          },
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _canCreateAccount
                                  ? () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      
                                     
                                      await Future.delayed(const Duration(milliseconds: 1500));
                                      bool success = true;
                                      
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      if (!context.mounted) return;

                                      if (success) {
                                        _showSuccessDialog();
                                      } else {
                                        _showErrorAnimation();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Đăng ký thất bại"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A3A6B),
                                disabledBackgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'CREATE ACCOUNT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Already have an account with fade animation
                        AnimatedBuilder(
                          animation: _loginLinkAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _loginLinkAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _loginLinkAnimation.value)),
                                child: child,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  // Animate out before navigation
                                  await _animationController.reverse();
                                  
                                  if (!context.mounted) return;
                                  
                                  Navigator.push(
                                    context, 
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        var begin = const Offset(1.0, 0.0);
                                        var end = Offset.zero;
                                        var curve = Curves.easeInOut;
                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                        return SlideTransition(position: animation.drive(tween), child: child);
                                      },
                                    ),
                                  );
                                },
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween<double>(begin: 1.0, end: 1.05),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: child,
                                    );
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Color(0xFF5A8ED0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper method to build animated form fields with staggered animation
  List<Widget> _buildAnimatedFormFields() {
    final formFields = [
      _buildAnimatedTextField(
        controller: _fullNameController,
        focusNode: _fullNameFocus,
        labelText: 'Full Name',
        icon: Icons.person_outline,
        delay: 0.0,
      ),
      const SizedBox(height: 16),
      _buildAnimatedTextField(
        controller: _emailController,
        focusNode: _emailFocus,
        labelText: 'Email Address',
        icon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
        delay: 0.1,
      ),
      const SizedBox(height: 16),
      _buildAnimatedTextField(
        controller: _phoneController,
        focusNode: _phoneFocus,
        labelText: 'Phone Number',
        icon: Icons.phone_android,
        keyboardType: TextInputType.phone,
        delay: 0.2,
      ),
      const SizedBox(height: 16),
      _buildAnimatedTextField(
        controller: _passwordController,
        focusNode: _passwordFocus,
        labelText: 'Password',
        icon: Icons.lock_outline,
        isPassword: true,
        obscureText: _obscurePassword,
        onToggleObscure: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        delay: 0.3,
      ),
      const SizedBox(height: 16),
      _buildAnimatedTextField(
        controller: _confirmPasswordController,
        focusNode: _confirmPasswordFocus,
        labelText: 'Confirm Password',
        icon: Icons.lock_outline,
        isPassword: true,
        obscureText: _obscureConfirmPassword,
        onToggleObscure: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
        isError: _confirmPasswordController.text.isNotEmpty && !_passwordsMatch,
        delay: 0.4,
      ),
    ];
    
    return formFields;
  }
  
  // Helper method to build animated text field
  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    bool isError = false,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: _formFieldsAnimation,
      builder: (context, child) {
        // Calculate a staggered delay based on the provided delay parameter
        final double staggeredValue = math.max(
          0.0,
          math.min(
            1.0,
            (_formFieldsAnimation.value - delay) / (1.0 - delay),
          ),
        );
        
        return Transform.translate(
          offset: Offset(300 * (1 - staggeredValue), 0),
          child: Opacity(
            opacity: staggeredValue,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(
          focusNode.hasFocus || isError ? _errorShakeAnimation : 0,
          0,
          0,
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: isPassword ? obscureText : false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: isError
                  ? Colors.red.shade700
                  : focusNode.hasFocus
                      ? const Color(0xFF5A8ED0)
                      : Colors.grey.shade600,
            ),
            prefixIcon: Icon(
              icon,
              color: isError
                  ? Colors.red.shade700
                  : focusNode.hasFocus
                      ? const Color(0xFF5A8ED0)
                      : Colors.grey.shade400,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                        key: ValueKey<bool>(obscureText),
                        color: focusNode.hasFocus
                            ? const Color(0xFF5A8ED0)
                            : Colors.grey.shade600,
                      ),
                    ),
                    onPressed: onToggleObscure,
                  )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: isError ? Colors.red.shade700 : Colors.grey.shade300,
                width: isError ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: isError ? Colors.red.shade700 : const Color(0xFF5A8ED0),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: focusNode.hasFocus
                ? Colors.blue.shade50.withOpacity(0.3)
                : Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }
  
  // Helper method to build animated requirement item
  Widget _buildAnimatedRequirement(String text, bool isMet, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        // Apply a staggered delay
        final double staggeredValue = math.max(
          0.0,
          math.min(
            1.0,
            (value - delay) / (1.0 - delay),
          ),
        );
        
        return Opacity(
          opacity: staggeredValue,
          child: Transform.translate(
            offset: Offset(50 * (1 - staggeredValue), 0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isMet ? Icons.check_circle : Icons.circle_outlined,
                      key: ValueKey<bool>(isMet),
                      color: isMet ? const Color(0xFF43A047) : Colors.grey.shade400,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      color: isMet ? Colors.grey.shade700 : Colors.grey.shade500,
                      fontSize: 14,
                      fontWeight: isMet ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) => Container(), // Dummy container
            ),
          ]),
          builder: (context, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Account Created',
                  style: TextStyle(
                    color: Color(0xFF1A3A6B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF43A047),
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: const Text(
                        'Your account has been created successfully!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      delay: const Duration(milliseconds: 200),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'You can now login with your credentials.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                    delay: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        
                        // Animate out before navigation
                        await _animationController.reverse();
                        
                        if (!context.mounted) return;
                        
                        Navigator.pushReplacement(
                          context, 
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var begin = const Offset(1.0, 0.0);
                              var end = Offset.zero;
                              var curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              return SlideTransition(position: animation.drive(tween), child: child);
                            },
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color(0xFF1A3A6B)),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
