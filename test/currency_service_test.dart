import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = CurrencyService();

  test('catalog has unique currency codes', () {
    final codes = service.getAll().map((currency) => currency.code).toList();

    expect(codes.toSet(), hasLength(codes.length));
  });

  test('includes newly supported current currencies', () {
    const expectedCodes = {
      'AWG',
      'BSD',
      'CVE',
      'DJF',
      'ERN',
      'FJD',
      'FKP',
      'GIP',
      'GNF',
      'HNL',
      'IRR',
      'KMF',
      'KPW',
      'LSL',
      'LYD',
      'MOP',
      'MRU',
      'PAB',
      'SBD',
      'SDG',
      'SHP',
      'SLE',
      'SSP',
      'STN',
      'SVC',
      'SZL',
      'TJS',
      'TMT',
      'UZS',
      'VES',
      'VUV',
      'WST',
      'XCG',
      'XPF',
      'ZWG',
    };

    final actualCodes = service.getActive().map((currency) => currency.code);
    expect(actualCodes, containsAll(expectedCodes));
  });

  test('retains obsolete currencies without offering them for selection', () {
    final activeCodes = service.getActive().map((currency) => currency.code);

    expect(activeCodes, isNot(contains(anyOf('BGN', 'VEF', 'ZWL'))));
    expect(service.findByCode('BGN'), isNotNull);
    expect(service.findByCode('VEF'), isNotNull);
    expect(service.findByCode('ZWL'), isNotNull);
    expect(
      service.findActiveCurrenciesByCode(['USD', 'BGN', 'VEF', 'ZWL']).map(
        (currency) => currency.code,
      ),
      ['USD'],
    );
  });

  test('searches Uzbekistan currency by code, country, and aliases', () {
    for (final query in ['UZS', 'Uzbekistan', 'sum', 'som']) {
      expect(
        service.search(query).map((currency) => currency.code),
        contains('UZS'),
      );
    }
  });

  test('searches shared currencies by territory', () {
    expect(
      service.search('Saint Lucia').map((currency) => currency.code),
      contains('XCD'),
    );
    expect(
      service.search('Sint Maarten').map((currency) => currency.code),
      contains('XCG'),
    );
  });
}
