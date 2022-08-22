import 'dart:math';

import 'package:energy_cost_calculator/view/home_view.dart';
import 'package:flutter/material.dart';

import '../model/Customer.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key, required this.customer}) : super(key: key);

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar, body: buildResultView(context));
  }

  AppBar get buildAppBar => AppBar(title: const Text("Result View"));

  Widget buildResultView (BuildContext context) {

    var showList = customer.readings.sublist(max(0, customer.readings.length-4), customer.readings.length-1);

    return Column (
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text('Service Number: ${customer.serviceNumber}', style: const TextStyle(fontSize: 20))),
        const SizedBox(height: 16),
        _buildNewReading(),
        const SizedBox(height: 30),
        customer.readings.length == 1
            ? const Center() : _buildLastReadings(showList),
        const SizedBox(height: 30),
        _buildSaveButton(context)
      ],
    );
  }

  Widget _buildLastReadings(var showList) {
    return Padding(
      padding: const EdgeInsets.only(left: 36.0, right: 36.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          children: [
            const Center(child: Text("Last Readings:", style: TextStyle(fontSize: 24))),
            const SizedBox(height: 16),
            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: showList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Center(child: Text('Reading: ${showList[index]}', style: const TextStyle(fontSize: 16)));
                }
            ),
          ],
        )
      ),
    );

  }

  Widget _buildNewReading() {
    return Text('Consumption Cost: ${customer.cost.toString()}', style: const TextStyle(fontSize: 20));
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton.icon(
        icon: const Text("Save"),
        label: const Icon(Icons.save, size: 20),
        onPressed: () => {_navigateToScreen(context)}
      ),
    );
  }

  void _navigateToScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Case Project')),(Route<dynamic> route) => false);
  }
}
