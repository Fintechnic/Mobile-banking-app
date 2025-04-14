import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoanScreen(),
    );
  }
}

class LoanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background color
            Container(
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Color(0xFF8FC5FF),
              ),
              padding: const EdgeInsets.only(left: 10.0, right: 16.0, top: 5.0, bottom: 8.0),
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: [
                      // Back button
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      // Title
                      Text(
                        'Loans',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      // Document icon
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.description_outlined, color: Colors.white, size: 16),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Phone icon
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(Icons.phone, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Search bar - positioned over the blue background
            Transform.translate(
              offset: Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                      SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'PTF, SHB, JACCS, ACS...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 14,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Main content title
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
              child: Text(
                'Select payment partner',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2F80ED),
                ),
              ),
            ),
            SizedBox(height: 16),
            
            // Partners grid - custom layout with controlled spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // First row of partners
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => _buildPartnerItem()),
                  ),
                  SizedBox(height: 25), // Specific spacing between rows
                  // Second row of partners
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) => _buildPartnerItem()),
                  ),
                ],
              ),
            ),
            
            // Instruction section - with proper spacing
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instruction manual',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F80ED),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Balanced instruction items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInstructionItem(
                          icon: Icons.menu_book_outlined,
                          title: 'Financial\nliteracy',
                          color: Color(0xFF2F80ED),
                        ),
                        _buildInstructionItem(
                          icon: Icons.attach_money,
                          title: 'Payment\nguide',
                          color: Color(0xFF2F80ED),
                        ),
                        _buildInstructionItem(
                          icon: Icons.question_answer_outlined,
                          title: 'FAQ',
                          color: Color(0xFF2F80ED),
                        ),
                        _buildInstructionItem(
                          icon: Icons.message_outlined,
                          title: 'Feedback',
                          color: Color(0xFF2F80ED),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'NAME',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
