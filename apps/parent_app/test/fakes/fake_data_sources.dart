import 'dart:async';
import 'package:sg_data/sg_data.dart';
import 'package:sg_domain/sg_domain.dart';

class FakeAuthDataSource implements FirebaseAuthDataSource {
  final _controller = StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  UserModel? getCurrentUser() => UserModel(
        id: 'mock_parent_1',
        email: 'parent@example.com',
        displayName: 'ولي الأمر',
        createdAt: DateTime(2026, 1, 1),
      );

  @override
  Future<UserModel> registerWithEmailAndPassword(
          String email, String password, String displayName) async =>
      getCurrentUser()!;

  @override
  Future<UserModel> signInWithEmailAndPassword(
          String email, String password) async =>
      getCurrentUser()!;

  @override
  Future<void> signOut() async => _controller.add(null);
}

class FakeChildDataSource implements FirestoreChildDataSource {
  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) async {}

  @override
  Future<ChildModel?> getChildById(String childId) async => null;

  @override
  Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return Stream.value([
      ChildModel(
        id: 'child_1',
        parentId: parentId,
        name: 'أحمد',
        age: 10,
        dailyScreenTimeLimitMinutes: 120,
        usedScreenTimeTodayMinutes: 45,
        isLocked: false,
        lastActiveAt: DateTime(2026, 1, 1),
      )
    ]);
  }

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) async {}

  @override
  Future<void> updateDailyLimit(String childId, int limitMinutes) async {}
}

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
