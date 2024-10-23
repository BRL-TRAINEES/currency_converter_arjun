import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_practice/notifier.dart';

class homescreen extends ConsumerWidget {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversionState = ref.watch(currencyConversionProvider);
    final conversionNotifier = ref.read(currencyConversionProvider.notifier);

    List<String> currencies = [
      'USD',
      'INR',
      'EUR',
      'JPY',
      'AED',
      'AFN',
      'CAD',
      'CNY',
      'KRW',
      'MXN',
      'PKR',
      'RUB',
      'SGD',
      'THB',
      'ZAR',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter amount',
                labelStyle: TextStyle(fontSize: 18, color: Colors.teal),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: conversionState.fromCurrency,
                    onChanged: (newValue) {
                      conversionNotifier.updateFromCurrency(newValue!);
                    },
                    items: currencies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'From',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.teal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('to', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: conversionState.toCurrency,
                    onChanged: (newValue) {
                      conversionNotifier.updateToCurrency(newValue!);
                    },
                    items: currencies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: 'To',
                      labelStyle: TextStyle(fontSize: 16, color: Colors.teal),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  double amount = double.parse(amountController.text);
                  await conversionNotifier.convertCurrency(amount);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Convert',
                  style: TextStyle(color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (conversionState.convertedAmount != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 14, 182, 211)
                            .withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Converted Amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${conversionState.convertedAmount} ${conversionState.toCurrency}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (conversionState.errormsg.isNotEmpty)
              Text(
                conversionState.errormsg,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
