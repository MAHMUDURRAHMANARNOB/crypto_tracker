// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import '../utils/coin_data.dart';
import '../services/cryptos.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double? btcRate;
  double? ethRate;
  double? ltcRate;
  String currencySelected = "USD";
  String? cryptoCoin;

  DropdownButton androidDropdown() {
    List<DropdownMenuItem> dropdownMenuItems = [];

    for (/* int i = 0; i < currenciesList.length; i++*/
        String currency in currenciesList) {
      /*String currency = currenciesList[i];*/
      dropdownMenuItems.add(
        DropdownMenuItem(
          value: currency,
          child: Text(currency),
        ),
      );
    }
    /*return dropdownMenuItems;*/
    return DropdownButton(
      value: currencySelected,
      items: dropdownMenuItems,
      onChanged: (value) {
        setState(() {
          currencySelected = value!;
          for (String crypto in cryptoList) {
            cryptoCoin = crypto;
            print("crypto $cryptoCoin");
            fetchCoinData(cryptoCoin!, currencySelected);
          }
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];

    for (/*int i = 0; i < currenciesList.length; i++*/
        String currency in currenciesList) {
      /*String currency = currenciesList[i];*/
      pickerItems.add(
        Text(currency),
      );
    }
    return CupertinoPicker(
      itemExtent: 32, //height of the item
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          currencySelected = currenciesList[selectedIndex];
          print(currencySelected);
          for (String crypto in cryptoList) {
            cryptoCoin = crypto;
            print("crypto $cryptoCoin");
            fetchCoinData(cryptoCoin!, currencySelected);
          }
        });
      },
      children: pickerItems,
    );
  }

  void fetchCoinData(String coin, String currency) async {
    try {
      var coinData = await CryptoModel().getCryptoData(coin, currency);
      setState(() {
        if (coin == "BTC") {
          double btcRatee = coinData['rate'];
          btcRate = btcRatee.floorToDouble();
        } else if (coin == "ETH") {
          double ethRatee = coinData['rate'];
          ethRate = ethRatee.floorToDouble();
        } else if (coin == "LTC") {
          double ltcRatee = coinData['rate'];
          ltcRate = ltcRatee.floorToDouble();
        }
      });
    } catch (e) {
      print("Error fetching coin data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Card buildCryptoCard(String crypto, double? rate) {
      return Card(
        color: Colors.deepOrangeAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${rate ?? "?"} $currencySelected',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: buildCryptoCard(cryptoCoin = "BTC", btcRate),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: buildCryptoCard(cryptoCoin = "ETH", ethRate),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: buildCryptoCard(cryptoCoin = "LTC", ltcRate),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black87,
            child: Platform.isAndroid ? androidDropdown() : iosPicker(),
          ),
        ],
      ),
    );
  }
}
