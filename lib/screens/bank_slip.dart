import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Confirmation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const PaymentConfirmationScreen(),
    );
  }
}

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _successIconAnimation;
  late Animation<double> _nameAnimation;
  late Animation<double> _amountAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonsAnimation;
  late Animation<double> _detailsAnimation;

  int? _tappedButtonIndex;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _successIconAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    );

    _nameAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.5, curve: Curves.easeOut),
    );

    _amountAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.6, curve: Curves.easeOut),
    );

    _textAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 0.7, curve: Curves.easeOut),
    );

    _buttonsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.8, curve: Curves.easeOut),
    );

    _detailsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 0.9, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
  }) {
    final double delay = index * 0.1;
    final Animation<double> buttonAnimation = CurvedAnimation(
      parent: _buttonsAnimation,
      curve: Interval(delay, 1.0, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: buttonAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: buttonAnimation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - buttonAnimation.value)),
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  _tappedButtonIndex = index;
                });

                HapticFeedback.lightImpact();
              },
              onTapUp: (_) {
                Future.delayed(const Duration(milliseconds: 200), () {
                  if (mounted) {
                    setState(() {
                      _tappedButtonIndex = null;
                    });
                  }
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label tapped'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              onTapCancel: () {
                setState(() {
                  _tappedButtonIndex = null;
                });
              },
              child: Column(
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 1.0,
                      end: _tappedButtonIndex == index ? 0.9 : 1.0,
                    ),
                    duration: const Duration(milliseconds: 100),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: _tappedButtonIndex == index
                                ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(icon, color: color, size: 28),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _tappedButtonIndex == index
                          ? FontWeight.bold
                          : FontWeight.normal,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A3A6B)),
          onPressed: () {
            _animationController.reverse().then((_) {
              Navigator.pop(context);
            });
          },
        ),
        title: const Text(
          'Payment Confirmation',
          style: TextStyle(
            color: Color(0xFF1A3A6B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Transform.translate(
                  offset: Offset(0, 50 * (1 - _successIconAnimation.value)),
                  child: Card(
                    elevation: 2,
                    shadowColor: Colors.black.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Transform.scale(
                            scale: _successIconAnimation.value,
                            child: Transform.rotate(
                              angle: 2 * math.pi * _successIconAnimation.value,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6AC259),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6AC259)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 15,
                                      spreadRadius:
                                          5 * _successIconAnimation.value,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Opacity(
                            opacity: _nameAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 20 * (1 - _nameAnimation.value)),
                              child: const Text(
                                'Nguyen Van A',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Opacity(
                            opacity: _amountAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 20 * (1 - _amountAnimation.value)),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: 100),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeOut,
                                builder: (context, value, child) {
                                  return Text(
                                    '\$${value.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: _textAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 10 * (1 - _textAnimation.value)),
                              child: Text(
                                'No commission',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: _textAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 10 * (1 - _textAnimation.value)),
                              child: Text(
                                'Completed, 12 September 16:00',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.receipt,
                                label: 'Open\nreceipt',
                                color: const Color(0xFF4C7CF6),
                                index: 0,
                              ),
                              _buildActionButton(
                                icon: Icons.star,
                                label: 'Create\nsample',
                                color: const Color(0xFF4C7CF6),
                                index: 1,
                              ),
                              _buildActionButton(
                                icon: Icons.refresh,
                                label: 'Repeat\npayment',
                                color: const Color(0xFF4C7CF6),
                                index: 2,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Opacity(
                            opacity: _detailsAnimation.value,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  _detailsAnimation.value,
                              child: const Divider(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Opacity(
                            opacity: _detailsAnimation.value,
                            child: Transform.translate(
                              offset:
                                  Offset(0, 10 * (1 - _detailsAnimation.value)),
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                            begin: 1.0,
                                            end: _isExpanded ? 1.2 : 1.0),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        builder: (context, scale, child) {
                                          return Transform.scale(
                                            scale: scale,
                                            child: const Icon(
                                              Icons.info_outline,
                                              color: Color(0xFF5A8ED0),
                                              size: 20,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Operation details',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const Spacer(),
                                      TweenAnimationBuilder<double>(
                                        tween: Tween<double>(
                                            begin: 0, end: _isExpanded ? 1 : 0),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        builder: (context, value, child) {
                                          return Transform.rotate(
                                            angle: value * math.pi,
                                            child: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: SizedBox(
                              height: _isExpanded ? null : 0,
                              child: _isExpanded
                                  ? Column(
                                      children: [
                                        const SizedBox(height: 24),
                                        TweenAnimationBuilder<double>(
                                          tween:
                                              Tween<double>(begin: 0, end: 1),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          builder: (context, value, child) {
                                            return Opacity(
                                              opacity: value,
                                              child: Transform.translate(
                                                offset:
                                                    Offset(20 * (1 - value), 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Withdrawal account',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          'Salary card',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                            vertical: 2,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade200,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withValues(
                                                                        alpha:
                                                                            0.05),
                                                                blurRadius: 5,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                'VISA',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF5A8ED0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                '· 3040',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade700,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 16),
                                        TweenAnimationBuilder<double>(
                                          tween:
                                              Tween<double>(begin: 0, end: 1),
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: const Interval(0.1, 1.0),
                                          builder: (context, value, child) {
                                            return Opacity(
                                              opacity: value,
                                              child: Transform.translate(
                                                offset:
                                                    Offset(20 * (1 - value), 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Name of the recipient',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    const Text(
                                                      'Nguyen Van A',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 500),
                      curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0.95, end: 1.05),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                            builder: (context, pulseValue, child) {
                              return Transform.scale(
                                scale: pulseValue,
                                child: ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Payment shared successfully!'),
                                        duration: Duration(seconds: 2),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1A3A6B),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 4,
                                    shadowColor: const Color(0xFF1A3A6B)
                                        .withValues(alpha: 0.3),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.share),
                                      SizedBox(width: 8),
                                      Text(
                                        'Share Payment Details',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
