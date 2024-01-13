import 'dart:convert';
import 'dart:io';

import 'package:astroverse/utils/resource.dart';
import 'package:http/http.dart' as http;

typedef Json = Map<String, dynamic>;
typedef Header = Map<String, String>;

class RazorPayUtils {
  static const _receiverName = "Astroverse";

  static Json createOrderBody(int amount , String currency , ) {
    final order = {
      "amount": amount*100,
      "currency": currency,
      "receipt": "rcptid_1",
    };
    return order;
  }

  static Header createOrderAuthorizationHeader(String key, String secret) {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';
    return {"Content-Type": "application/json", "authorization": basicAuth};
  }

  Future<Resource<Json>> createOrder(Header header, Json order) async {
    try {
      final res = await http.post(Uri.https("api.razorpay.com", "v1/orders"),
          headers: header, body: jsonEncode(order));

      if (res.statusCode == 200) {
        return Success<Json>(jsonDecode(res.body));
      } else {
        return Failure<Json>(jsonDecode(res.body)["description"]);
      }
    } on HttpException catch (e) {
      return Failure<Json>(e.message);
    } catch (e) {
      return Failure<Json>(e.toString());
    }
  }

  static Json createOptions(String key, String orderId, int amount,
      String description, String phNo, String email) {
    final Json options = {
      'key': key,
      'amount': amount * 100,
      'order_id': orderId,
      'currency': 'INR',
      'name': _receiverName,
      'description': description,
      'prefill': {'contact': phNo, 'email': email}
    };

    return options;
  }
}
