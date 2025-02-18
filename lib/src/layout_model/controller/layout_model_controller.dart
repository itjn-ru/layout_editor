import '../layout_model.dart';
import 'event_bus.dart';
import 'project.dart';

class LayoutModelController {
  LayoutModel layoutModel;
  final eventBus = LayoutModelEventBus();

  late final LayoutModelEditorProject project;
  LayoutModelController({
    required this.layoutModel,
    Future<bool> Function(Map map)? projectSaver,
    Future<String?> Function(bool isSaved)? projectLoader,
    Future<bool> Function(bool isSaved)? projectCreator,
  }){
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
  void clear(){}
}