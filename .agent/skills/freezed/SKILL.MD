# Freezed Model Generation Skill

When generating Dart models using the `freezed` package, always follow the existing project convention.

This project uses the modern **classic class syntax** supported by newer Freezed versions.

Do NOT automatically convert models into `const factory` constructor style unless explicitly requested.

---

## Preferred Freezed Syntax

Use this style:

```dart
@freezed
@JsonSerializable()
class NutrientInsight with _$NutrientInsight {
  NutrientInsight({
    required this.name,
    required this.value,
    required this.status,
    required this.icon,
  });

  factory NutrientInsight.fromJson(Map<String, dynamic> json) =>
      _$NutrientInsightFromJson(json);

  Map<String, dynamic> toJson() => _$NutrientInsightToJson(this);

  final String name;
  final String value;
  final NutrientStatusEnum status;
  final NutrientIconEnum icon;

  String get statusLabel => status.label;
}
