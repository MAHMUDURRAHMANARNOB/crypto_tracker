import 'netwrork.dart';

const apiKey = 'CB15D506-E9A6-489E-AFC6-E7EA6F4EDAEE';
const coinApiURL = 'https://rest.coinapi.io/v1/exchangerate';

class CryptoModel {
  Future<dynamic> getCryptoData(String coinName, String currencyName) async {
    String url = "$coinApiURL/$coinName/$currencyName?apikey=$apiKey";
    NetworkHelper networkHelper = NetworkHelper(url);
    var cryptoData = await networkHelper.getData();
    // Return the entire cryptoData or handle null cases
    return cryptoData; // Return an empty Map if cryptoData is null
  }
}
