import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final NumberFormat formatter = NumberFormat.currency(
    locale: 'vi_VN', // Định dạng theo ngôn ngữ Việt Nam
    symbol: 'VNĐ', // Thêm ký hiệu tiền tệ
    decimalDigits: 0, // Không hiển thị phần thập phân
  );
  return formatter.format(amount);
}

String convertDate(String inputDate) {
  try {
    // Parse chuỗi input thành đối tượng DateTime
    DateTime parsedDate = DateTime.parse(inputDate);

    // Định dạng lại chuỗi theo yêu cầu
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Trường hợp lỗi, trả về thông báo lỗi hoặc chuỗi rỗng
    return 'no data';
  }
}
