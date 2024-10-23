import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CurrencyConversionState {
  final String fromCurrency;
  final String toCurrency;
  final double? convertedAmount;
  final String errormsg;

  CurrencyConversionState({
    required this.fromCurrency,
    required this.toCurrency,
    this.convertedAmount,
    this.errormsg = '',
  });

  CurrencyConversionState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? convertedAmount,
    String? errormsg,
  }) {
    return CurrencyConversionState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      errormsg: errormsg ?? this.errormsg,
    );
  }
}

class CurrencyConversionNotifier
    extends StateNotifier<CurrencyConversionState> {
  CurrencyConversionNotifier()
      : super(CurrencyConversionState(fromCurrency: 'USD', toCurrency: 'INR'));

  Future<void> convertCurrency(double amount) async {
    final String url =
        'https://api.currencylayer.com/live?access_key=${dotenv.env['accesskey']}&currencies=${state.toCurrency}&source=${state.fromCurrency}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        double exchangeRate =
            data['quotes']['${state.fromCurrency}${state.toCurrency}'];
        double convertedAmount = amount * exchangeRate;
        state = state.copyWith(convertedAmount: convertedAmount, errormsg: '');
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      state = state.copyWith(errormsg: 'Error: ${e.toString()}');
    }
  }

  void updateFromCurrency(String newFromCurrency) {
    state = state.copyWith(fromCurrency: newFromCurrency);
  }

  void updateToCurrency(String newToCurrency) {
    state = state.copyWith(toCurrency: newToCurrency);
  }
}

final currencyConversionProvider =
    StateNotifierProvider<CurrencyConversionNotifier, CurrencyConversionState>(
  (ref) => CurrencyConversionNotifier(),
);
