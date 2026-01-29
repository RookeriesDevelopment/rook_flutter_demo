extension DoubleExtensions on double {
  double to2Decimals() {
    String roundedValue = toStringAsFixed(2);

    return double.parse(roundedValue);
  }
}
