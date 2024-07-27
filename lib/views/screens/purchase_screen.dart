import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PointPurchaseScreen extends StatefulWidget {
  const PointPurchaseScreen({super.key});

  @override
  _PointPurchaseScreenState createState() => _PointPurchaseScreenState();
}

class _PointPurchaseScreenState extends State<PointPurchaseScreen> {
  String _selectedAmount = '100000 VND';
  bool _showQRCode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nạp điểm',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Thông tin thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Số điểm:${int.parse(_selectedAmount.split(' ')[0]) / 10}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Chọn mệnh giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _buildAmountButton('500000 VND'),
                _buildAmountButton('300000 VND'),
                _buildAmountButton('200000 VND'),
                _buildAmountButton('100000 VND'),
                _buildAmountButton('50000 VND'),
                _buildAmountButton('30000 VND'),
                _buildAmountButton('20000 VND'),
                _buildAmountButton('10000 VND'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQRCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Nạp điểm',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    bool isSelected = _selectedAmount == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmount = amount;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepOrange, width: 2),
        ),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _generateQRCode() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code'),
          content: QrImageView(
            data: 'Nạp điểm: $_selectedAmount',
            version: QrVersions.auto,
            size: 200.0,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
