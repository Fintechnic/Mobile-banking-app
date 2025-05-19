import 'package:flutter/material.dart';
import 'dart:math' as math; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loans App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoansScreen(),
    );
  }
}

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> with TickerProviderStateMixin {
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _searchController;
  
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  
  bool _isSearchExpanded = false;
  final TextEditingController _searchTextController = TextEditingController();
  
  
  final List<AnimationController> _bankControllers = [];
  final List<Animation<double>> _bankScaleAnimations = [];
  
  
  final List<AnimationController> _instructionControllers = [];
  final List<Animation<double>> _instructionScaleAnimations = [];
  
  
  final List<AnimationController> _loanControllers = [];
  final List<Animation<Offset>> _loanSlideAnimations = [];
  
  
  int? _selectedBankIndex;
  
  @override
  void initState() {
    super.initState();
    
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuint,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
    
    
    
    for (int i = 0; i < 8; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (i * 50)),
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ));
      
      _bankControllers.add(controller);
      _bankScaleAnimations.add(animation);
    }
    
   
    for (int i = 0; i < 4; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400 + (i * 100)),
      );
      
      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
      
      _instructionControllers.add(controller);
      _instructionScaleAnimations.add(animation);
    }
    
    
    for (int i = 0; i < 3; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + (i * 100)),
      );
      
      final animation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
      
      _loanControllers.add(controller);
      _loanSlideAnimations.add(animation);
    }
    
    
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    
    
    Future.delayed(const Duration(milliseconds: 300), () {
      for (var controller in _bankControllers) {
        controller.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 600), () {
      for (var controller in _instructionControllers) {
        controller.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      for (var controller in _loanControllers) {
        controller.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _searchController.dispose();
    _searchTextController.dispose();
    
    for (var controller in _bankControllers) {
      controller.dispose();
    }
    
    for (var controller in _instructionControllers) {
      controller.dispose();
    }
    
    for (var controller in _loanControllers) {
      controller.dispose();
    }
    
    super.dispose();
  }
  
  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (_isSearchExpanded) {
        _searchController.forward();
      } else {
        _searchController.reverse();
        _searchTextController.clear();
      }
    });
  }
  
  void _selectBank(int index) {
    setState(() {
      if (_selectedBankIndex == index) {
        _selectedBankIndex = null;
      } else {
        _selectedBankIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF93B5E1)),
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
                      Hero(
                        tag: 'back_button',
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              
                              Navigator.of(context).pop();
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Loans',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(20 * (1 - _fadeAnimation.value), 0),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedBuilder(
                        animation: _fadeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(20 * (1 - _fadeAnimation.value), 0),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: _toggleSearch,
                  child: AnimatedBuilder(
                    animation: _searchController,
                    builder: (context, child) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _isSearchExpanded
                                  ? TextField(
                                      controller: _searchTextController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search loans or banks',
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    )
                                  : const Text(
                                      'Search',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                            if (_isSearchExpanded && _searchTextController.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchTextController.clear();
                                  });
                                },
                                child: const Icon(Icons.close, color: Colors.grey),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              Expanded(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(20.0),
                        children: [
                          const Text(
                            'Select payment partner',
                            style: TextStyle(
                              color: Color(0xFF1A3A6B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            children: List.generate(8, (index) {
                              final bankNames = ['BIDV', 'VCB', 'TCB', 'ACB', 'TPB', 'VIB', 'MSB', 'OCB'];
                              return AnimatedBuilder(
                                animation: _bankControllers[index],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _bankScaleAnimations[index].value,
                                    child: Opacity(
                                      opacity: _bankScaleAnimations[index].value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildBankItem(bankNames[index], index),
                              );
                            }),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Instruction manual',
                            style: TextStyle(
                              color: Color(0xFF5A8ED0),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AnimatedBuilder(
                                animation: _instructionControllers[0],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _instructionScaleAnimations[0].value,
                                    child: Opacity(
                                      opacity: _instructionScaleAnimations[0].value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildInstructionItem(
                                  icon: Icons.payment,
                                  label: 'Payment',
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _instructionControllers[1],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _instructionScaleAnimations[1].value,
                                    child: Opacity(
                                      opacity: _instructionScaleAnimations[1].value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildInstructionItem(
                                  icon: Icons.credit_card,
                                  label: 'Credit',
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _instructionControllers[2],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _instructionScaleAnimations[2].value,
                                    child: Opacity(
                                      opacity: _instructionScaleAnimations[2].value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildInstructionItem(
                                  icon: Icons.account_balance,
                                  label: 'Deposit',
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _instructionControllers[3],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _instructionScaleAnimations[3].value,
                                    child: Opacity(
                                      opacity: _instructionScaleAnimations[3].value,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildInstructionItem(
                                  icon: Icons.help_outline,
                                  label: 'Feedback',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          
                          const Text(
                            'Loan Products',
                            style: TextStyle(
                              color: Color(0xFF1A3A6B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SlideTransition(
                            position: _loanSlideAnimations[0],
                            child: _buildLoanProductItem(
                              title: 'Home Loan',
                              description: 'Interest rate from 7.5% per year',
                              icon: Icons.home,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SlideTransition(
                            position: _loanSlideAnimations[1],
                            child: _buildLoanProductItem(
                              title: 'Car Loan',
                              description: 'Interest rate from 8.0% per year',
                              icon: Icons.directions_car,
                            ),
                          ),
                          const SizedBox(height: 15),
                          SlideTransition(
                            position: _loanSlideAnimations[2],
                            child: _buildLoanProductItem(
                              title: 'Personal Loan',
                              description: 'Interest rate from 9.5% per year',
                              icon: Icons.person,
                            ),
                          ),
                          
                          const SizedBox(height: 50),
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

  Widget _buildBankItem(String bankName, int index) {
    final isSelected = _selectedBankIndex == index;
    
    return GestureDetector(
      onTap: () => _selectBank(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF93B5E1).withOpacity(0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF5A8ED0) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF5A8ED0).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected ? const Color(0xFF1A3A6B) : Colors.grey.shade700,
              fontWeight: FontWeight.bold,
              fontSize: isSelected ? 14 : 12,
            ),
            child: Text(bankName),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: () {
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label selected'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: 1.1),
            duration: const Duration(milliseconds: 200),
            builder: (context, value, child) {
              return MouseRegion(
                onEnter: (_) => setState(() {}),
                onExit: (_) => setState(() {}),
                child: Transform.scale(
                  scale: 1.0,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFF5A8ED0), size: 24),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.black87, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanProductItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1.0, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            
            _showLoanDetails(title, description, icon);
          },
          child: MouseRegion(
            onEnter: (_) => setState(() {}),
            onExit: (_) => setState(() {}),
            child: Transform.scale(
              scale: value,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF93B5E1).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A3A6B), size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 10.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(math.sin(value) * 3, 0), // Using math.sin instead of value.sin()
                  child: child,
                );
              },
              child: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
  
  void _showLoanDetails(String title, String description, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 400),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF93B5E1).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: const Color(0xFF1A3A6B), size: 24),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A3A6B),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(50 * (1 - value), 0),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF5A8ED0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Features',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF5A8ED0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildFeatureItem('Competitive interest rates'),
                            _buildFeatureItem('Flexible repayment options'),
                            _buildFeatureItem('Quick approval process'),
                            _buildFeatureItem('No hidden fees'),
                            const SizedBox(height: 20),
                            const Text(
                              'Requirements',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF5A8ED0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildRequirementItem('Valid ID'),
                            _buildRequirementItem('Proof of income'),
                            _buildRequirementItem('Credit history'),
                            if (title == 'Home Loan')
                              _buildRequirementItem('Property documents'),
                            if (title == 'Car Loan')
                              _buildRequirementItem('Vehicle information'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.8 + (0.2 * value),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Applied for $title'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3A6B),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Apply Now',
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
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF43A047),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF1A3A6B),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}