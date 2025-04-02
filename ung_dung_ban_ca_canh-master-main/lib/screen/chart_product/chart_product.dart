import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
class RevenueController extends GetxController {
  var selectedMonth = '01'.obs;
  var selectedYear = '2024'.obs;
  var selectedFishType = 'Cá Betta'.obs;

  List<String> months = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];
  
  List<String> years = ['2024', '2023', '2022'];

  List<String> fishTypes = ['Cá Betta', 'Cá Koi', 'Cá Guppy', 'Cá vàng'];

  // Fake data for revenue
  String getRevenue() {
    return "Doanh thu cho ${selectedFishType.value} tháng ${selectedMonth.value}, ${selectedYear.value}: 10.000.000 VND";
  }
}

// UI Screen
class RevenueScreen extends StatelessWidget {
  final RevenueController controller = Get.put(RevenueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống Kê Doanh Thu Cá Cảnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(),
            SizedBox(height: 20),
            _buildRevenueStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chọn tháng:', style: TextStyle(fontSize: 16)),
        Obx(() {
          return DropdownButton<String>(
            value: controller.selectedMonth.value,
            onChanged: (String? newValue) {
              controller.selectedMonth.value = newValue!;
            },
            items: controller.months.map<DropdownMenuItem<String>>((String month) {
              return DropdownMenuItem<String>(
                value: month,
                child: Text(month),
              );
            }).toList(),
          );
        }),

        SizedBox(height: 10),
        
        Text('Chọn năm:', style: TextStyle(fontSize: 16)),
        Obx(() {
          return DropdownButton<String>(
            value: controller.selectedYear.value,
            onChanged: (String? newValue) {
              controller.selectedYear.value = newValue!;
            },
            items: controller.years.map<DropdownMenuItem<String>>((String year) {
              return DropdownMenuItem<String>(
                value: year,
                child: Text(year),
              );
            }).toList(),
          );
        }),

        SizedBox(height: 10),
        
        Text('Chọn loại cá bán chạy:', style: TextStyle(fontSize: 16)),
        Obx(() {
          return DropdownButton<String>(
            value: controller.selectedFishType.value,
            onChanged: (String? newValue) {
              controller.selectedFishType.value = newValue!;
            },
            items: controller.fishTypes.map<DropdownMenuItem<String>>((String fishType) {
              return DropdownMenuItem<String>(
                value: fishType,
                child: Text(fishType),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildRevenueStats() {
    return Expanded(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                return Text(
                  controller.getRevenue(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              }),
              SizedBox(height: 10),
              // Tạo các biểu đồ hoặc bảng doanh thu tại đây nếu cần
              Text(
                'Doanh thu dự kiến: 10.000.000 VND',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
