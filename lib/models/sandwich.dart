enum BreadType { white, wheat, wholemeal }

enum SandwichType { veggieDelight, chickenTeriyaki, tunaMelt, meatballMarinara }

class Sandwich {
  /// Identifier for this sandwich type (useful when loading from JSON).
  final String id;

  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;

  /// Optional display name (overrides the default name derived from [type]).
  final String? displayName;

  /// Short description loaded from JSON/catalog.
  final String description;

  /// Whether this sandwich is currently available.
  final bool available;

  /// Optional explicit image path. If not provided the class will construct
  /// a default path based on type and size.
  final String? imagePath;

  Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
    String? id,
    this.displayName,
    this.description = '',
    this.available = true,
    this.imagePath,
  }) : id = id ?? type.name;

  /// Create a Sandwich from JSON. Supported keys:
  /// - `id` (string)
  /// - `type` (string matching a SandwichType name)
  /// - `isFootlong` (bool)
  /// - `breadType` (string matching a BreadType name)
  /// - `name` (display name)
  /// - `description` (string)
  /// - `available` (bool)
  /// - `image` (string path)
  factory Sandwich.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] ?? '').toString();
    SandwichType type = SandwichType.values.firstWhere(
      (e) => e.name == typeStr,
      orElse: () => SandwichType.veggieDelight,
    );

    final breadStr = json['breadType']?.toString();
    BreadType bread = BreadType.white;
    if (breadStr != null && breadStr.isNotEmpty) {
      bread = BreadType.values.firstWhere(
        (e) => e.name == breadStr,
        orElse: () => BreadType.white,
      );
    }

    final isFootlong = json['isFootlong'] is bool
        ? json['isFootlong'] as bool
        : (json['isFootlong']?.toString().toLowerCase() == 'true');

    final id = json['id']?.toString() ?? type.name;
    final name = json['name']?.toString();
    final description = json['description']?.toString() ?? '';
    final available = json['available'] is bool
        ? json['available'] as bool
        : (json['available']?.toString().toLowerCase() == 'true');
    final image = json['image']?.toString();

    return Sandwich(
      type: type,
      isFootlong: isFootlong,
      breadType: bread,
      id: id,
      displayName: name,
      description: description,
      available: available,
      imagePath: image,
    );
  }

  String get name {
    if (displayName != null && displayName!.isNotEmpty) return displayName!;
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    if (imagePath != null && imagePath!.isNotEmpty) return imagePath!;
    String typeString = type.name;
    String sizeString = '';
    if (isFootlong) {
      sizeString = 'footlong';
    } else {
      sizeString = 'six_inch';
    }
    return 'assets/images/${typeString}_$sizeString.png';
  }
}
