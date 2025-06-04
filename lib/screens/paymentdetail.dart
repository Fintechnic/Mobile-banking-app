import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFDCEAF9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDCEAF9),
          elevation: 0,
        ),
      ),
      home: const PaymentDetailsScreen(),
    );
  }
}

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _successCardAnimation;
  late Animation<double> _transactionDetailsAnimation;
  late Animation<double> _userDetailsAnimation;
  late Animation<double> _noteAnimation;
  late Animation<double> _thankYouAnimation;

  late Animation<double> _checkIconAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _successCardAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );

    _transactionDetailsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
    );

    _userDetailsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );

    _noteAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
    );

    _thankYouAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );

    _checkIconAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDCEAF9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Payment details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedBuilder(
                animation: _successCardAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _successCardAnimation.value,
                    child: Opacity(
                      opacity: _successCardAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Success payment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 100000),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Text(
                            '${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _transactionDetailsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        0, 50 * (1 - _transactionDetailsAnimation.value)),
                    child: Opacity(
                      opacity: _transactionDetailsAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        'Status',
                        _buildAnimatedStatusBadge(),
                      ),
                      const Divider(),
                      _buildDetailRow('Time', const Text('12:00 - 15/6/2025')),
                      const Divider(),
                      _buildDetailRow(
                        'Transaction ID',
                        const Text('02315465498'),
                      ),
                      const Divider(),
                      _buildDetailRow('Account', const Text('Vietcombank')),
                      const Divider(),
                      _buildDetailRow(
                        'Total Charges',
                        const Text('Free of charge'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _userDetailsAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - _userDetailsAnimation.value)),
                    child: Opacity(
                      opacity: _userDetailsAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8E8E8),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withAlpha(13),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                          'User\'s name', const Text('Nguyen Van A')),
                      const Divider(),
                      _buildDetailRow('Nickname', const Text('MessAI')),
                      const Divider(),
                      _buildDetailRow('Phone number', const Text('1234567890')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _noteAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _noteAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _noteAnimation.value)),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Note',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text('ABCDXYZ@#'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _thankYouAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _thankYouAnimation.value,
                    child: Opacity(
                      opacity: _thankYouAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withAlpha(51),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank You For',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Transferring Money',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Text(
                            'Through Us.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: _checkIconAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _checkIconAnimation.value,
                            child: child,
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  const delay = 0.8;
                  final value =
                      (_animationController.value - delay) / (1 - delay);
                  final opacity = value.clamp(0.0, 1.0);

                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - opacity)),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sharing payment details...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Downloading receipt...'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
      floatingActionButton: _buildPulsingFAB(),
    );
  }

  Widget _buildPulsingFAB() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        const delay = 0.9;
        final value = (_animationController.value - delay) / (1 - delay);
        final scale = value.clamp(0.0, 1.0);

        return Transform.scale(
          scale: scale,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 1.1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return AnimatedScale(
                scale: value,
                duration: const Duration(milliseconds: 400),
                child: child,
              );
            },
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Starting new transaction...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedStatusBadge() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Success',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          value,
        ],
      ),
    );
  }
}
