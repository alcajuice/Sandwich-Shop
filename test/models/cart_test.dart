import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart', () {
    test('add merges identical sandwiches and updates totalQuantity', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      cart.add(s, quantity: 2);
      expect(cart.totalQuantity, 2);
      expect(cart.items.length, 1);

      // adding same sandwich type/size/bread should increase quantity on same item
      cart.add(s, quantity: 3);
      expect(cart.totalQuantity, 5);
      expect(cart.items.length, 1);
      expect(cart.items.first.quantity, 5);
    });

    test(
      'remove decreases quantity and removes item when quantity reaches zero',
      () {
        final cart = Cart();
        final s = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        );

        cart.add(s, quantity: 3);
        expect(cart.totalQuantity, 3);

        cart.remove(s, quantity: 1);
        expect(cart.totalQuantity, 2);

        cart.remove(s, quantity: 2);
        expect(cart.totalQuantity, 0);
        expect(cart.items.length, 0);
      },
    );

    test(
      'calculatePrice uses provided PricingRepository and sums per-item totals',
      () {
        final repo = PricingRepository(sixInchPrice: 5.0, footlongPrice: 9.0);
        final cart = Cart();

        final s1 = Sandwich(
          type: SandwichType.veggieDelight,
          isFootlong: true,
          breadType: BreadType.white,
        );
        final s2 = Sandwich(
          type: SandwichType.tunaMelt,
          isFootlong: false,
          breadType: BreadType.wheat,
        );

        cart.add(s1, quantity: 2); // 2 * 9.0 = 18.0
        cart.add(s2, quantity: 3); // 3 * 5.0 = 15.0

        final total = cart.calculatePrice(pricingRepository: repo);
        expect(total, 33.0);
      },
    );

    test('items returns unmodifiable view', () {
      final cart = Cart();
      final s = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(s, quantity: 1);

      // attempting to modify the returned items list should throw
      expect(
        () => cart.items.add(CartItem(sandwich: s, quantity: 1)),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
