import 'package:energy_cost_calculator/model/Customers.dart';
import 'package:energy_cost_calculator/view/result_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/Customer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController serviceNumberController = TextEditingController();
  bool isServiceNumberOk = false;
  TextEditingController meterReadingController = TextEditingController();
  bool isMeterReadingOk = false;

  final _text = '';

  @override
  void dispose() {
    serviceNumberController.dispose();
    meterReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar, body: buildFormView());
  }

  AppBar get buildAppBar => AppBar(title: Text(widget.title));

  Form buildFormView() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _serviceNumberField(),
          const SizedBox(height: 16),
          _meterReadingField(),
          const SizedBox(height: 32),
          _buildButtonSubmit()
        ],
      ),
    );
  }

  Widget _serviceNumberField () {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      child: TextFormField(
        controller: serviceNumberController,
        maxLength: 10,
        decoration: InputDecoration(
          labelText: "Service Number",
          errorText: _errorTextServiceNumber,
        ),
        onChanged: (text) => setState(() => _text),
      ),
    );
  }

  Widget _meterReadingField () {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
      child: TextFormField(
        controller: meterReadingController,
        keyboardType: TextInputType.number,
        inputFormatters:[FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
        decoration: InputDecoration(
          labelText: "Meter Reading",
          errorText: _errorTextMeterReading,
        ),
        onChanged: (text) => setState(() => _text),
      ),
    );
  }

  Widget _buildButtonSubmit() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton.icon(
        icon: const Text("Submit"),
        label: const Icon(Icons.send, size: 20),
        onPressed: isServiceNumberOk && isMeterReadingOk
            ? _submit
            : null,
      ),
    );
  }

  String? get _errorTextServiceNumber {
    final text = serviceNumberController.value.text;

    if (text.isEmpty) {
      isServiceNumberOk = false;
      return 'Can\'t be empty';
    }

    if (!text.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      isServiceNumberOk = false;
      return 'Invalid characters!';
    }

    if (text.length < 10) {
      isServiceNumberOk = false;
      return 'Mandatory to be 10 digits';
    }
    isServiceNumberOk = true;
    return null;
  }

  String? get _errorTextMeterReading {
    final text = meterReadingController.value.text;

    if (text.isEmpty) {
      isMeterReadingOk = false;
      return 'Can\'t be empty';
    }
    isMeterReadingOk = true;
    return null;
  }

  showAlertDialog(BuildContext context, String message) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => {Navigator.pop(context)},
    );
    AlertDialog alert = AlertDialog(
      title: const Text("ERROR"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _submit() {
    Customer customer = Customers.getCustomer(serviceNumberController.value.text);
    if (customer.setReadings(int.parse(meterReadingController.value.text))) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultView(customer: customer)),
      );
    } else {
      showAlertDialog(context, "New reading must not be less than last reading!");
    }
  }

}
