import 'package:flutter/material.dart';


class TransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Transfer',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown('Choose account / card'),
            SizedBox(height: 16),
            _buildBeneficiarySelection(context),
            SizedBox(height: 16),
            _buildInputField('Bank'),
            _buildInputField('Card number'),
            _buildInputField('Name'),
            _buildInputField('Amount', keyboardType: TextInputType.number),
            _buildInputField('Content'),
            _buildCheckbox(),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey.shade700),
        ],
      ),
    );
  }

  Widget _buildBeneficiarySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose beneficiary',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Find beneficiary',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBeneficiaryAvatar(Icons.add, '', Colors.grey.shade300),
            _buildBeneficiaryAvatar(null, 'John', Colors.blue.shade100),
            _buildBeneficiaryAvatar(null, 'Emma', Colors.green.shade100),
            _buildBeneficiaryAvatar(null, 'David', Colors.orange.shade100),
          ],
        ),
      ],
    );
  }

  Widget _buildBeneficiaryAvatar(IconData? icon, String name, Color bgColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: bgColor,
          child:
              icon != null
                  ? Icon(icon, color: Colors.grey.shade700, size: 30)
                  : Icon(Icons.person, color: Colors.white, size: 30),
        ),
        SizedBox(height: 8),
        Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildInputField(
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Row(
      children: [
        Checkbox(value: false, onChanged: (value) {}),
        Text('Save to directory of beneficiary'),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadowColor: Colors.blue.shade300,
          elevation: 6,
        ),
        child: Text(
          'CONFIRM',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
