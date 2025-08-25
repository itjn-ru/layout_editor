import 'package:rxdart/rxdart.dart';

abstract class ExpandableController {
  bool get isExpanded;
  double? get expandedHeight;
  void toggle();
  void expand();
  void collapse();
  Stream<bool> get stateChanges;
  Stream<double?> get heightChanges;
  void updateHeight(double height);
  void dispose();
}

class ExpandableControllerImpl implements ExpandableController {
  final _isExpanded = BehaviorSubject<bool>.seeded(false);
  final _expandedHeight = BehaviorSubject<double?>();

  @override
  bool get isExpanded => _isExpanded.value;

  @override
  double? get expandedHeight => _expandedHeight.value;

  @override
  void toggle() => _isExpanded.add(!_isExpanded.value);

  @override
  void expand() => _isExpanded.add(true);

  @override
  void collapse() => _isExpanded.add(false);

  @override
  Stream<bool> get stateChanges => _isExpanded.stream;

  @override
  Stream<double?> get heightChanges => _expandedHeight.stream;

  @override
  void updateHeight(double height) => _expandedHeight.add(height);

  @override
  void dispose() {
    _isExpanded.close();
    _expandedHeight.close();
  }
}
