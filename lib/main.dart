import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrencyConverter(),
      child: const LoanCurrencyConverterApp(),
    ),
  );
}

class LoanCurrencyConverterApp extends StatelessWidget {
  const LoanCurrencyConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFE7E7EE),
      ),
      home: const LoanCurrencyConverterScreen(),
    );
  }
}

class LoanCurrencyConverterScreen extends StatefulWidget {
  const LoanCurrencyConverterScreen({super.key});

  @override
  _LoanCurrencyConverterScreenState createState() => _LoanCurrencyConverterScreenState();
}

class _LoanCurrencyConverterScreenState extends State<LoanCurrencyConverterScreen> {
  late TextEditingController _exchangeRateController;

  @override
  void initState() {
    super.initState();
    _exchangeRateController = TextEditingController(
      text: '17.65',
    );
  }

  @override
  void dispose() {
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final converter = Provider.of<CurrencyConverter>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          _buildHeader(),
          _buildConversionCard(converter),
          _buildExchangeRateInfo(converter),
        ],
      ),
    );
  }

  Widget _buildHeader() => const Positioned(
    top: 97,
    left: 83,
    child: Text(
      'Currency Converter',
      style: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Color(0xFF1F2261),
      ),
    ),
  );

  Widget _buildConversionCard(CurrencyConverter converter) {
    final country1Controller = TextEditingController(
      text: converter.amountToConvert.toStringAsFixed(2),
    );

    return Positioned(
      top: 168,
      left: 20,
      child: Container(
        width: 347,
        height: 268,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            _buildLabel('Amount', 15, 15),
            _buildCurrencyField(converter.country1, 50, 30),
            _buildTextField(
              50,
              165,
              controller: country1Controller,
              onEditingComplete: () {
                final newRate = double.tryParse(country1Controller.text) ?? converter.amountToConvert;
                converter.updateAmountToConvert(newRate);
              },
            ),
            _buildSeparatorLine(),
            _buildSwitchButton(converter),
            _buildLabel('Converted Amount', 170, 15),
            _buildCurrencyField(converter.country2, 200, 30),
            _buildTextField(
              200,
              165,
              enabled: false,
              controller: TextEditingController(
                text: converter.convertedAmount.toStringAsFixed(2),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildExchangeRateInfo(CurrencyConverter converter) => Positioned(
    top: 455,
    left: 20,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Indicative Exchange Rate',
          style: _labelTextStyle(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text('1 USD = ', style: _valueTextStyle()),
            _buildTextField(
              0,
              0,
              width: 52,
              height: 35,
              controller: _exchangeRateController,
              onEditingComplete: () {
                final newRate = double.tryParse(_exchangeRateController.text) ?? converter.exchangeRate;
                converter.updateExchangeRate(newRate);
              },
            ),
            Text(' MDL', style: _valueTextStyle()),
          ],
        ),
      ],
    ),
  );

  Widget _buildLabel(String text, double top, double left) => Positioned(
    top: top,
    left: left,
    child: Text(
      text,
      style: _labelTextStyle(),
    ),
  );

  Widget _buildCurrencyField(Country country, double top, double left) =>
      Positioned(
        top: top,
        left: left,
        child: Row(
          children: [
            Image.asset(country.flagImagePath, width: 50, height: 50),
            const SizedBox(width: 10),
            Text(
              country.currencyCode,
              style: _currencyTextStyle(),
            ),
          ],
        ),
      );

  Widget _buildTextField(
      double top,
      double left, {
        double width = 152,
        double height = 45,
        bool enabled = true,
        TextEditingController? controller,
        ValueChanged<String>? onChanged,
        VoidCallback? onEditingComplete,
      }) =>
      Positioned(
        top: top,
        left: left,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            enabled: enabled,
            controller: controller,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            style: _valueTextStyle(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      );

  Widget _buildSeparatorLine() => Positioned(
    top: 135,
    left: 15,
    child: Container(
      width: 303,
      height: 1,
      color: const Color(0xFFE7E7EE),
    ),
  );

  Widget _buildSwitchButton(CurrencyConverter converter) => Positioned(
    top: 112,
    left: 158,
    child: GestureDetector(
      onTap: converter.switchCountries,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: const Color(0xFF26278D),
        child: Image.asset('images/button.png', width: 30, height: 30),
      ),
    ),
  );

  TextStyle _labelTextStyle() => const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: Color(0xFF989898),
  );

  TextStyle _currencyTextStyle() => const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 15,
    color: Color(0xFF26278D),
  );

  TextStyle _valueTextStyle() => const TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: 15,
  );
}

class Country {
  final String flagImagePath;
  final String currencyCode;

  Country({required this.flagImagePath, required this.currencyCode});
}

class CurrencyConverter with ChangeNotifier {
  Country _country1 = Country(flagImagePath: 'images/country1_flag.png', currencyCode: 'MDL');
  Country _country2 = Country(flagImagePath: 'images/country2_flag.png', currencyCode: 'USD');

  double _exchangeRate = 17.65;
  double _amountToConvert = 0.0;
  double _convertedAmount = 0.0;

  Country get country1 => _country1;
  Country get country2 => _country2;
  double get exchangeRate => _exchangeRate;
  double get amountToConvert => _amountToConvert;
  double get convertedAmount => _convertedAmount;

  void updateExchangeRate(double newRate) {
    _exchangeRate = newRate;
    _convertCurrency();
  }

  void updateAmountToConvert(double newAmount) {
    _amountToConvert = newAmount;
    _convertCurrency();
  }

  void _convertCurrency() {
    if(country1.currencyCode == 'USD') {
      _convertedAmount = _amountToConvert * exchangeRate;
    } else {
      _convertedAmount =  _amountToConvert / _exchangeRate;
    }
    notifyListeners();
  }

  void switchCountries() {
    final temp = _country1;
    _country1 = _country2;
    _country2 = temp;
    final temp2 = _amountToConvert;
    _amountToConvert = convertedAmount;
    _convertedAmount = temp2;

    notifyListeners();
  }
}
