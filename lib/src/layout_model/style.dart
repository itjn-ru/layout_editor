import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uuid/uuid_value.dart';
import 'component_and_source.dart';

class LayoutStyle extends LayoutComponentAndSource {
  LayoutStyle(super.type, super.name);
}

class Style {
  UuidValue id;
  String name;

  static Style basic = Style(UuidValue.nil, 'базовый стиль');

  Style(this.id, this.name);

  @override
  bool operator ==(Object other) => other is Style && id == other.id;

  @override
  int get hashCode => Object.hash(id, name);
}

class CustomBorderStyle {
  double width;
  Color color;
  CustomBorderSide side;

  static CustomBorderStyle basic =
      CustomBorderStyle(1.0, Colors.black, CustomBorderSide.solid);

  factory CustomBorderStyle.init() {
    return CustomBorderStyle(1.0, Colors.black, CustomBorderSide.none);
  }

  CustomBorderStyle(this.width, this.color, this.side);

  Map<String, dynamic> toMap() {
    return {
      'width': this.width,
      'color': this.color.value,
      'side': this.side,
    };
  }

  factory CustomBorderStyle.fromMap(Map<String, dynamic> map) {
    return CustomBorderStyle(
      double.parse(map['width']),
      Color(int.parse(map['color'])),
      CustomBorderSide.values.firstWhere((e) => e.toString() == map['side'],
          orElse: () => CustomBorderSide.none),
    );
  }
}

enum CustomBorderSide {
  none('Нет'),
  solid('Сплошная'),
  dash('Тире'),
  dot('Точка');

  final String title;

  const CustomBorderSide(this.title);

  CustomBorderSide side(String value) {
    return CustomBorderSide.values
        .firstWhere((e) => e.toString() == value.split('.').last);
  }
}
