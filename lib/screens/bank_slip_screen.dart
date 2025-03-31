import 'package:flutter/material.dart';


class TransactionSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "abc",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "100\$",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text("No commission", style: TextStyle(color: Colors.grey)),
                  Text(
                    "Completed, 12 September 16:00",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.receipt_long,
                        label: "Open receipt",
                      ),
                      _ActionButton(
                        icon: Icons.star_border,
                        label: "Create sample",
                      ),
                      _ActionButton(
                        icon: Icons.refresh,
                        label: "Repeat payment",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _TransactionDetails(),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.blue,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TransactionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                "Operation details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text("Withdrawal account", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                " **** **** **** 3040",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Image.asset(
                "assets/visa_logo.png",
                height: 16,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.credit_card, color: Colors.blue, size: 16);
                },
              ),
              SizedBox(width: 5),
              Text(". 3040", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 15),
          Text("Name of the recipient", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text("abc", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                "To Main",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
