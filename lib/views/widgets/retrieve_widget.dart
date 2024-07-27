import 'package:flutter/material.dart';
import 'package:travel_app/models/retrieve_model.dart';

class ResultScreen extends StatelessWidget {
  final RetrieveResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF222222),
      appBar: AppBar(
        title: Text('Kết quả'),
        backgroundColor: Color(0xFF222222),
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBox("Địa điểm", result.diaDiem, context),
              SizedBox(height: 16),
              _buildInfoBox("Mô tả", result.moTa, context),
              SizedBox(height: 16),
              Text(
                "Keywords:",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 255, 87, 51),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                spacing: 8.0, // khoảng cách giữa các keyword
                runSpacing: 4.0, // khoảng cách giữa các dòng keyword
                children: result.keywords
                    .map((keyword) => _buildKeywordBox(keyword))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String content, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context)
          .size
          .width, // chiếm toàn bộ chiều rộng màn hình
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color.fromARGB(255, 255, 87, 51),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 87, 51),
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordBox(String keyword) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Color.fromARGB(255, 255, 87, 51),
          width: 2.0,
        ),
      ),
      child: Text(
        keyword,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
    );
  }
}
