import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A simple cart item tying a [Sandwich] to a quantity.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});
}

/// A lightweight shopping cart for sandwiches.
///
/// Use [add] to add sandwiches and [calculatePrice] to compute the
/// total using the provided [PricingRepository] (or the default one).
class Cart {
  final List<CartItem> _items = [];

  Cart();

  /// Adds [quantity] of [sandwich] to the cart. If an identical sandwich
  /// already exists in the cart, its quantity will be incremented.
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final idx = _items.indexWhere(
      (it) => _isSameSandwich(it.sandwich, sandwich),
    );
    if (idx != -1) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes up to [quantity] of [sandwich] from the cart. If the
  /// remaining quantity is zero or less, the item is removed entirely.
  void remove(Sandwich sandwich, {int quantity = 1}) {
    final idx = _items.indexWhere(
      (it) => _isSameSandwich(it.sandwich, sandwich),
    );
    if (idx == -1) return;

    final existing = _items[idx];
    existing.quantity -= quantity;
    if (existing.quantity <= 0) {
      _items.removeAt(idx);
    }
  }

  /// Clears the cart.
  void clear() => _items.clear();

  /// Returns an unmodifiable view of items in the cart.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of sandwiches in the cart.
  int get totalQuantity => _items.fold(0, (p, e) => p + e.quantity);

  /// Calculates total price using [pricingRepository]. If none is provided,
  /// a default [PricingRepository] is created.
  double calculatePrice({PricingRepository? pricingRepository}) {
    final repo = pricingRepository ?? PricingRepository();
    double total = 0.0;
    for (final it in _items) {
      total += repo.computeTotal(
        quantity: it.quantity,
        isFootlong: it.sandwich.isFootlong,
      );
    }
    return total;
  }

  bool _isSameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type &&
        a.isFootlong == b.isFootlong &&
        a.breadType == b.breadType;
  }
}
