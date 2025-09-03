/// Контроллер для управления состоянием расширяемого (expandable) виджета.
/// Позволяет отслеживать и изменять состояние (развернут/свернут), а также высоту виджета.
import 'dart:async';

/// Абстракция для контроллера расширяемого виджета.
/// Позволяет подписываться на изменения состояния и высоты, а также управлять ими.
abstract class ExpandableController {
  /// Текущее состояние: развернут ли виджет.
  bool get isExpanded;

  /// Текущая высота развернутого виджета (если задана).
  double? get expandedHeight;

  /// Переключить состояние (развернуть/свернуть).
  void toggle();

  /// Развернуть виджет.
  void expand();

  /// Свернуть виджет.
  void collapse();

  /// Поток изменений состояния (развернут/свернут).
  Stream<bool> get stateChanges;

  /// Поток изменений высоты.
  Stream<double?> get heightChanges;

  /// Обновить высоту развернутого виджета.
  void updateHeight(double height);

  /// Освободить ресурсы контроллера.
  void dispose();
}

/// Реализация контроллера для расширяемого виджета.
///
/// Позволяет:
/// - отслеживать состояние (развернут/свернут) через поток [stateChanges];
/// - отслеживать изменения высоты через поток [heightChanges];
/// - управлять состоянием с помощью методов [toggle], [expand], [collapse];
/// - обновлять высоту через [updateHeight];
/// - корректно освобождать ресурсы через [dispose].
class ExpandableControllerImpl implements ExpandableController {
  bool _isExpanded = false;
  double? _expandedHeight;

  final _stateController = StreamController<bool>.broadcast();
  final _heightController = StreamController<double?>.broadcast();

  /// Текущее состояние: развернут ли виджет.
  @override
  bool get isExpanded => _isExpanded;

  /// Текущая высота развернутого виджета (если задана).
  @override
  double? get expandedHeight => _expandedHeight;

  /// Переключить состояние (развернуть/свернуть).
  @override
  void toggle() {
    _isExpanded = !_isExpanded;
    _stateController.add(_isExpanded);
  }

  /// Развернуть виджет.
  @override
  void expand() {
    if (!_isExpanded) {
      _isExpanded = true;
      _stateController.add(_isExpanded);
    }
  }

  /// Свернуть виджет.
  @override
  void collapse() {
    if (_isExpanded) {
      _isExpanded = false;
      _stateController.add(_isExpanded);
    }
  }

  /// Поток изменений состояния (развернут/свернут).
  @override
  Stream<bool> get stateChanges => _stateController.stream;

  /// Поток изменений высоты.
  @override
  Stream<double?> get heightChanges => _heightController.stream;

  /// Обновить высоту развернутого виджета.
  @override
  void updateHeight(double height) {
    _expandedHeight = height;
    _heightController.add(_expandedHeight);
  }

  /// Освободить ресурсы контроллера.
  @override
  void dispose() {
    _stateController.close();
    _heightController.close();
  }
}
