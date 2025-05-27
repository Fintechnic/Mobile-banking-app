import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../providers/auth_provider.dart';
import 'homepage_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  late AnimationController _animationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  late Animation<double> _logoAnimation;
  late Animation<double> _usernameFieldAnimation;
  late Animation<double> _passwordFieldAnimation;
  late Animation<double> _optionsAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _registerAnimation;

  late Animation<double> _fingerprintPulseAnimation;

  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  double _errorShakeAnimation = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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

    _usernameFieldAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
    );

    _passwordFieldAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );

    _optionsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );

    _buttonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.8, curve: Curves.easeOut),
    );

    _registerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );

    _fingerprintPulseAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
    );

    _animationController.forward();

    _usernameFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _showErrorAnimation() {
    setState(() {});

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
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
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
                          _animationController.reverse().then((_) {
                            Navigator.pop(context);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Đăng nhập',
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
                      offset: Offset(0, 100 * (1 - _slideAnimation.value.dy)),
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
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(24.0),
                        children: [
                          const SizedBox(height: 30),
                          Center(
                            child: AnimatedBuilder(
                              animation: _logoAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _logoAnimation.value,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF93B5E1),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color(0xFF93B5E1).withAlpha(77),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          AnimatedBuilder(
                            animation: _usernameFieldAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                    300 * (1 - _usernameFieldAnimation.value),
                                    0),
                                child: Opacity(
                                  opacity: _usernameFieldAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(
                                _usernameFocus.hasFocus
                                    ? 0
                                    : _errorShakeAnimation,
                                0,
                                0,
                              ),
                              child: TextFormField(
                                controller: _usernameController,
                                focusNode: _usernameFocus,
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                  labelStyle: TextStyle(
                                    color: _usernameFocus.hasFocus
                                        ? const Color(0xFF5A8ED0)
                                        : Colors.grey.shade600,
                                  ),
                                  prefixIcon: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(
                                        _usernameFocus.hasFocus ? 0 : 0),
                                    child: Icon(
                                      Icons.person_outline,
                                      color: _usernameFocus.hasFocus
                                          ? const Color(0xFF5A8ED0)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5A8ED0),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: _usernameFocus.hasFocus
                                      ? Colors.blue.shade50.withAlpha(77)
                                      : Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AnimatedBuilder(
                            animation: _passwordFieldAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                    300 * (1 - _passwordFieldAnimation.value),
                                    0),
                                child: Opacity(
                                  opacity: _passwordFieldAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              transform: Matrix4.translationValues(
                                _passwordFocus.hasFocus
                                    ? 0
                                    : _errorShakeAnimation,
                                0,
                                0,
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: _passwordFocus.hasFocus
                                        ? const Color(0xFF5A8ED0)
                                        : Colors.grey.shade600,
                                  ),
                                  prefixIcon: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(
                                        _passwordFocus.hasFocus ? 0 : 0),
                                    child: Icon(
                                      Icons.lock_outline,
                                      color: _passwordFocus.hasFocus
                                          ? const Color(0xFF5A8ED0)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      transitionBuilder: (Widget child,
                                          Animation<double> animation) {
                                        return ScaleTransition(
                                            scale: animation, child: child);
                                      },
                                      child: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        key: ValueKey<bool>(_obscurePassword),
                                        color: _passwordFocus.hasFocus
                                            ? const Color(0xFF5A8ED0)
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF5A8ED0),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: _passwordFocus.hasFocus
                                      ? Colors.blue.shade50.withAlpha(77)
                                      : Colors.grey.shade50,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _optionsAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _optionsAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(
                                      0, 20 * (1 - _optionsAnimation.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: const Color(0xFF5A8ED0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Nhớ mật khẩu',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Chức năng đặt lại mật khẩu đang được phát triển'),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.blue.shade100.withAlpha(77),
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Quên mật khẩu?',
                                    style: TextStyle(
                                      color: Color(0xFF5A8ED0),
                                      fontWeight: FontWeight.w500,
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
                              return Opacity(
                                opacity: _buttonAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(
                                      0, 20 * (1 - _buttonAnimation.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            // Validate login form
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              _showErrorAnimation();
                                              return;
                                            }

                                            // Dismiss keyboard
                                            FocusScope.of(context).unfocus();

                                            setState(() {
                                              _isLoading = true;
                                            });

                                            // Attempt login
                                            bool success =
                                                await authProvider.login(
                                                    _usernameController.text
                                                        .trim(),
                                                    _passwordController.text);

                                            if (!context.mounted) return;

                                            setState(() {
                                              _isLoading = false;
                                            });

                                            if (success &&
                                                authProvider.isAuthenticated) {
                                              // No need to show SnackBar as we're navigating away
                                              if (!context.mounted) return;

                                              // Navigate to home screen
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(),
                                                ),
                                                (route) =>
                                                    false, // Remove all screens from stack
                                              );
                                            } else {
                                              _showErrorAnimation();

                                              // Show error message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(authProvider
                                                          .error ??
                                                      'Login failed. Please check your credentials.'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A3A6B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
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
                                            'ĐĂNG NHẬP',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    AnimatedBuilder(
                                      animation: _fingerprintPulseAnimation,
                                      builder: (context, child) {
                                        return Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF93B5E1)
                                                .withAlpha(51),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF1A3A6B)
                                                    .withAlpha(
                                                  (77 *
                                                          math.sin(
                                                              _fingerprintPulseAnimation
                                                                      .value *
                                                                  math.pi))
                                                      .toInt(),
                                                ),
                                                blurRadius: 10 *
                                                    _fingerprintPulseAnimation
                                                        .value,
                                                spreadRadius: 2 *
                                                    _fingerprintPulseAnimation
                                                        .value,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.fingerprint,
                                              size: 30,
                                              color: Color(0xFF1A3A6B),
                                            ),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Tính năng đăng nhập bằng sinh trắc học đang được phát triển'),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Vân tay',
                                      style: TextStyle(
                                        color: Color(0xFF1A3A6B),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          AnimatedBuilder(
                            animation: _registerAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _registerAnimation.value,
                                child: Transform.translate(
                                  offset: Offset(
                                      0, 20 * (1 - _registerAnimation.value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chưa có tài khoản? ",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _animationController.reverse();

                                    if (!context.mounted) return;

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            const RegisterScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          var begin = const Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.easeInOut;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child);
                                        },
                                      ),
                                    ).then((_) {
                                      if (mounted) {
                                        _animationController.forward();
                                      }
                                    });
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
                                      'Đăng ký',
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
                        ],
                      ),
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
}
