import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('zero quantity total is 0', () {
      final repo = PricingRepository();
      expect(repo.computeTotal(quantity: 0, isFootlong: true), 0.0);
    });

    test('six-inch price multiplies by quantity', () {
      final repo = PricingRepository(sixInchPrice: 7.0, footlongPrice: 11.0);
      expect(repo.computeTotal(quantity: 1, isFootlong: false), 7.0);
      expect(repo.computeTotal(quantity: 3, isFootlong: false), 21.0);
    });

    test('footlong price multiplies by quantity', () {
      final repo = PricingRepository();
      expect(repo.computeTotal(quantity: 1, isFootlong: true), 11.0);
      expect(repo.computeTotal(quantity: 2, isFootlong: true), 22.0);
    });

    test('custom prices work', () {
      final repo = PricingRepository(sixInchPrice: 5.5, footlongPrice: 9.25);
      expect(repo.computeTotal(quantity: 2, isFootlong: false), 11.0);
      expect(repo.computeTotal(quantity: 3, isFootlong: true), 27.75);
    });
  });
}
