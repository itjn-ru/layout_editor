import 'dart:ui';

import 'package:uuid/uuid.dart';

import '../layout_model.dart';
import 'clipboard.dart';
import 'event_bus.dart';
import 'events.dart';
import 'project.dart';

class LayoutModelController {
  LayoutModel layoutModel;
  final eventBus = LayoutModelEventBus();

  late final LayoutModelClipboard clipboard;
  late final LayoutModelEditorProject project;

  LayoutModelController({
    required this.layoutModel,
    Future<bool> Function(Map map)? projectSaver,
    Future<String?> Function(bool isSaved)? projectLoader,
    Future<bool> Function(bool isSaved)? projectCreator,
  }) {
    clipboard = LayoutModelClipboard(this);
    project = LayoutModelEditorProject(
      this,
      projectSaver: projectSaver,
      projectLoader: projectLoader,
      projectCreator: projectCreator,
    );
  }

  /// This method is used to dispose of the node editor controller and all of its resources, subsystems and members.
  void dispose() {
    eventBus.close();

  }

  void clear() {}

  Offset _viewportOffset = Offset.zero;
  double _viewportZoom = 1.0;

  Offset get viewportOffset => _viewportOffset;

  double get viewportZoom => _viewportZoom;

  set viewportOffset(Offset offset) {
    _viewportOffset = offset;
    eventBus.emit(
      ViewportOffsetEvent(
        id: const Uuid().v4(),
        _viewportOffset,
        animate: false,
        isHandled: true,
      ),
    );
  }

  set viewportZoom(double zoom) {
    _viewportZoom = zoom;
    eventBus.emit(
      ViewportZoomEvent(
        id: const Uuid().v4(),
        _viewportZoom,
        animate: false,
        isHandled: true,
      ),
    );
  }
}
