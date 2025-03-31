import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Account & Cards',
      home: const AccountCardsScreen(),
    );
  }
}

class AccountCardsScreen extends StatefulWidget {
  const AccountCardsScreen({super.key});
  
  @override
  State<AccountCardsScreen> createState() => _AccountCardsScreenState();
}

class _AccountCardsScreenState extends State<AccountCardsScreen> {
  // Mặc định, hiển thị tab "Card" (vì giao diện trong hình đang chọn Card)
  bool isAccountTab = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account & Cards'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Thêm xử lý nếu cần
          },
        ),
      ),
      body: Column(
        children: [
          // Thanh chọn tab
          Container(
            color: Colors.blue.shade100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tab Account
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAccountTab = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isAccountTab ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        color: isAccountTab ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Tab Card
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isAccountTab = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: !isAccountTab ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Text(
                      'Card',
                      style: TextStyle(
                        color: !isAccountTab ? Colors.white : Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Nội dung hiển thị: nếu đang ở tab Account thì hiện view Account,
          // ngược lại hiển thị danh sách thẻ (cards)
          Expanded(
            child: isAccountTab ? buildAccountView() : buildCardView(),
          ),
          // Button "Add Card" chỉ xuất hiện ở tab Card
          if (!isAccountTab)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý khi nhấn button Add Card
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Card'),
              ),
            ),
        ],
      ),
    );
  }

  // Hàm hiển thị nội dung cho tab "Account"
  Widget buildAccountView() {
    return const Center(
      child: Text(
        'Account Details',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  // Hàm hiển thị danh sách thẻ cho tab "Card"
  Widget buildCardView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          CardWidget(
            name: 'Mr. A',
            cardType: 'Amazon Platinum - VISA',
            cardNumber: '4756 **** **** 9018',
            balance: '30.000.000 VND',
            // Sử dụng gradient cho thẻ đầu tiên: từ màu xanh sang màu tím
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
            ),
            cardTypeIcon: Icons.credit_card,
          ),
          const SizedBox(height: 20),
          CardWidget(
            name: 'Mr. A',
            cardType: 'Amazon Platinum - Mastercard',
            cardNumber: '4756 **** **** 9018',
            balance: '30.000.000 VND',
            // Sử dụng gradient cho thẻ thứ hai: từ màu cam sang màu vàng
            gradient: const LinearGradient(
              colors: [Colors.orange, Colors.yellow],
            ),
            cardTypeIcon: Icons.credit_card,
          ),
        ],
      ),
    );
  }
}

// Widget tùy chỉnh hiển thị thông tin của một thẻ
class CardWidget extends StatelessWidget {
  final String name;
  final String cardType;
  final String cardNumber;
  final String balance;
  final LinearGradient gradient;
  final IconData cardTypeIcon;

  const CardWidget({
    super.key,
    required this.name,
    required this.cardType,
    required this.cardNumber,
    required this.balance,
    required this.gradient,
    required this.cardTypeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon thẻ ở góc trên bên phải
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                cardTypeIcon,
                size: 28,
                color: Colors.white,
              ),
            ],
          ),
          // Thông tin thẻ ở giữa
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cardType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          // Số dư ở dưới cùng
          Text(
            balance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
