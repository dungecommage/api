const Map<String, String> _currencies = {
  'USD': '\$',
  'EUR': '€',
  'AUD': 'A\$',
  'GBP': '£',
  'CAD': 'CA\$',
  'CNY': 'CN¥',
  'JPY': '¥',
  'SEK': 'SEK',
  'CHF': 'CHF',
  'INR': '₹',
  'KWD': 'د.ك',
  'RON': 'RON',
};

String currencyWithPrice(dynamic priceWrap) {
  final currency = _currencies[priceWrap['currency']];
  return '${currency}${priceWrap['value'].toString()}';
}