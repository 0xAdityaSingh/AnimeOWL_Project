import 'package:animetv/exceptions/NoInternetException.dart';
import 'package:http/http.dart';

class NetworkInfoProvider {
  Future throwIfNoNetwork() async {
    try {
      await get('https://www.google.com');
    } catch (e) {
      throw NoInternetException;
    }
  }
}
