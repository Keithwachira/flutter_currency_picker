import 'package:collection/collection.dart';

import 'currencies.dart';
import 'currency.dart';

class CurrencyService {
  final List<Currency> _currencies;

  CurrencyService()
      : _currencies = currencies
            .map((currency) => Currency.from(json: currency))
            .toList();

  ///Return list with all currencies
  List<Currency> getAll() {
    return _currencies;
  }

  ///Returns currencies that can be selected for new records.
  List<Currency> getActive() {
    return _currencies.where((currency) => currency.isActive).toList();
  }

  ///Searches by currency code, name, country, or alternate spelling.
  List<Currency> search(String query, {List<Currency>? currencies}) {
    final normalized = query.toLowerCase().trim();
    final source = currencies ?? getActive();
    if (normalized.isEmpty) return List<Currency>.from(source);

    return source.where((currency) {
      return currency.code.toLowerCase().contains(normalized) ||
          currency.name.toLowerCase().contains(normalized) ||
          currency.searchTerms.any(
            (term) => term.toLowerCase().contains(normalized),
          );
    }).toList();
  }

  ///Returns the first currency that mach the given code.
  Currency? findByCode(String? code) {
    final uppercaseCode = code?.toUpperCase();
    return _currencies.firstWhereOrNull(
      (currency) => currency.code == uppercaseCode,
    );
  }

  ///Returns the first currency that mach the given name.
  Currency? findByName(String? name) {
    return _currencies.firstWhereOrNull((currency) => currency.name == name);
  }

  ///Returns the first currency that mach the given number.
  Currency? findByNumber(int? number) {
    return _currencies.firstWhereOrNull(
      (currency) => currency.number == number,
    );
  }

  ///Returns a list with all the currencies that mach the given codes list.
  List<Currency> findCurrenciesByCode(List<String> codes) {
    final List<String> _codes =
        codes.map((code) => code.toUpperCase()).toList();
    final List<Currency> currencies = [];
    for (final code in _codes) {
      final Currency? currency = findByCode(code);
      if (currency != null) {
        currencies.add(currency);
      }
    }
    return currencies;
  }

  ///Returns active currencies matching the given codes.
  List<Currency> findActiveCurrenciesByCode(List<String> codes) {
    return findCurrenciesByCode(
      codes,
    ).where((currency) => currency.isActive).toList();
  }
}
