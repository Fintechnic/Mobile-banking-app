import 'package:flutter/material.dart';
import 'qr_page.dart'; 

class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Transfer"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account select
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: "Choose account / card",
                  items: [DropdownMenuItem(value: "Choose account / card", child: Text("Choose account / card"))],
                  onChanged: (value) {},
                ),
              ),
            ),
            SizedBox(height: 20),

            // Choose beneficiary and Scan QR button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Choose beneficiary", style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QRScannerScreen()),
                    );
                    if (result != null) {
                      // Handle QR scan result
                    }
                  },
                  child: Text("Scan QR", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
            SizedBox(height: 10),

      
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,A
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.2), radius: 30, child: Icon(Icons.add, color: Colors.blue)),
                  SizedBox(width: 10),
                  ...List.generate(3, (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        CircleAvatar(backgroundImage: AssetImage('assets/avatar.png'), radius: 30),
                        SizedBox(height: 5),
                        Text("Amanda", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Transfer form
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildTextField("Bank"),
                  buildTextField("Card number"),
                  buildTextField("Name"),
                  buildTextField("Amount"),
                  buildTextField("Content"),


                  Row(
                    children: [
                      Checkbox(value: false, onChanged: (value) {}),
                      Text("Save to directory of beneficiary"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("CONFIRM", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}