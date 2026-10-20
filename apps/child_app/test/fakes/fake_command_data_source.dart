import 'dart:async';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

class FakeCommandDataSource implements FirestoreCommandDataSource {
  final _controller = StreamController<CommandModel>.broadcast();

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) =>
      _controller.stream;

  @override
  Future<void> sendCommand(CommandModel command) async {}

  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {}
}
