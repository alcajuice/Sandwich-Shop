class PricingRepository {
  final double sixInchPrice;
  final double footlongPrice;

  PricingRepository({double? sixInchPrice, double? footlongPrice})
    : sixInchPrice = sixInchPrice ?? 7.0,
      footlongPrice = footlongPrice ?? 11.0;

  /// Compute total price for given quantity and sandwich size.
  double computeTotal({required int quantity, required bool isFootlong}) {
    if (quantity <= 0) return 0.0;
    final unit = isFootlong ? footlongPrice : sixInchPrice;
    return unit * quantity;
  }

  /// Convenience: price per item for selected size
  double pricePerItem({required bool isFootlong}) =>
      isFootlong ? footlongPrice : sixInchPrice;
}
