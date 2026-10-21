import 'dart:async';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../models/child_model.dart';
import '../../models/command_model.dart';
import '../../models/device_model.dart';
import '../../models/pairing_code_model.dart';
import '../../models/usage_report_model.dart';
import '../../models/user_model.dart';
import '../remote/firebase_auth_datasource.dart';
import '../remote/firestore_child_datasource.dart';
import '../remote/firestore_command_datasource.dart';
import '../remote/firestore_pairing_datasource.dart';
import '../remote/firestore_usage_datasource.dart';

// ============================================================================
// 📌 مصادر البيانات المحلية التفاعلية (In-Memory / Demo DataSources)
// ----------------------------------------------------------------------------
// تعمل كطبقة أمان وتشغيل احتياطي (Safe Fallback) عند عدم تكوين Firebase أو
// عدم وجود ملف google-services.json، مما يتيح تشغيل وفحص التطبيق والمحاكي
// بكفاءة كاملة بنسبة 100% دون أي انهيار.
// ============================================================================

/// مصادقة محلية تجريبية
class InMemoryAuthDataSource implements FirebaseAuthDataSource {
  UserModel? _currentUser = UserModel(
    id: 'demo_parent_id',
    email: 'parent@smartguardian.com',
    displayName: 'ولي الأمر التجريبي',
    createdAt: DateTime(2026, 1, 1),
  );

  final _authController = StreamController<UserModel?>.broadcast();

  @override
  UserModel? getCurrentUser() => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authController.stream;

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    _currentUser = UserModel(
      id: 'demo_parent_id',
      email: email,
      displayName: 'ولي الأمر',
      createdAt: DateTime.now(),
    );
    _authController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    _currentUser = UserModel(
      id: 'demo_parent_id',
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
    );
    _authController.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authController.add(null);
  }
}

/// إدارة أطفال محلية تجريبية
class InMemoryChildDataSource implements FirestoreChildDataSource {
  final List<ChildModel> _children = [
    ChildModel(
      id: 'demo_child_1',
      parentId: 'demo_parent_id',
      name: 'أحمد',
      age: 10,
      dailyScreenTimeLimitMinutes: 120,
      usedScreenTimeTodayMinutes: 45,
      isLocked: false,
      lastActiveAt: DateTime.now(),
    ),
    ChildModel(
      id: 'demo_child_2',
      parentId: 'demo_parent_id',
      name: 'سارة',
      age: 7,
      dailyScreenTimeLimitMinutes: 90,
      usedScreenTimeTodayMinutes: 90,
      isLocked: true,
      lastActiveAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  late final StreamController<List<ChildModel>> _childrenController;

  InMemoryChildDataSource() {
    _childrenController = StreamController<List<ChildModel>>.broadcast(
      onListen: () {
        _childrenController.add(List.unmodifiable(_children));
      },
    );
  }

  @override
  Stream<List<ChildModel>> getChildrenStream(String parentId) {
    return _childrenController.stream;
  }

  @override
  Future<ChildModel> addChild(ChildModel child) async {
    final newChild = ChildModel(
      id: 'child_${DateTime.now().millisecondsSinceEpoch}',
      parentId: child.parentId,
      name: child.name,
      age: child.age,
      avatarUrl: child.avatarUrl,
      dailyScreenTimeLimitMinutes: child.dailyScreenTimeLimitMinutes,
      usedScreenTimeTodayMinutes: 0,
      isLocked: false,
      lastActiveAt: DateTime.now(),
    );
    _children.add(newChild);
    _childrenController.add(List.unmodifiable(_children));
    return newChild;
  }

  @override
  Future<ChildModel?> getChildById(String childId) async {
    try {
      return _children.firstWhere((c) => c.id == childId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateChildLockStatus(String childId, bool isLocked) async {
    final index = _children.indexWhere((c) => c.id == childId);
    if (index != -1) {
      final old = _children[index];
      _children[index] = ChildModel(
        id: old.id,
        parentId: old.parentId,
        name: old.name,
        age: old.age,
        avatarUrl: old.avatarUrl,
        dailyScreenTimeLimitMinutes: old.dailyScreenTimeLimitMinutes,
        usedScreenTimeTodayMinutes: old.usedScreenTimeTodayMinutes,
        isLocked: isLocked,
        lastActiveAt: DateTime.now(),
      );
      _childrenController.add(List.unmodifiable(_children));
    }
  }

  @override
  Future<void> updateDailyLimit(String childId, int limitMinutes) async {
    final index = _children.indexWhere((c) => c.id == childId);
    if (index != -1) {
      final old = _children[index];
      _children[index] = ChildModel(
        id: old.id,
        parentId: old.parentId,
        name: old.name,
        age: old.age,
        avatarUrl: old.avatarUrl,
        dailyScreenTimeLimitMinutes: limitMinutes,
        usedScreenTimeTodayMinutes: old.usedScreenTimeTodayMinutes,
        isLocked: old.isLocked,
        lastActiveAt: DateTime.now(),
      );
      _childrenController.add(List.unmodifiable(_children));
    }
  }

  @override
  Future<void> extendScreenTime(String childId, int additionalMinutes) async {
    final index = _children.indexWhere((c) => c.id == childId);
    if (index != -1) {
      final old = _children[index];
      _children[index] = ChildModel(
        id: old.id,
        parentId: old.parentId,
        name: old.name,
        age: old.age,
        avatarUrl: old.avatarUrl,
        dailyScreenTimeLimitMinutes:
            old.dailyScreenTimeLimitMinutes + additionalMinutes,
        usedScreenTimeTodayMinutes: old.usedScreenTimeTodayMinutes,
        isLocked: false,
        lastActiveAt: DateTime.now(),
      );
      _childrenController.add(List.unmodifiable(_children));
    }
  }
}

/// إدارة أوامر فورية محلية تجريبية
class InMemoryCommandDataSource implements FirestoreCommandDataSource {
  final _commandStreamController = StreamController<CommandModel>.broadcast();
  final List<CommandModel> _recentCommands = [];
  final StreamController<List<CommandModel>> _recentController =
      StreamController<List<CommandModel>>.broadcast();

  @override
  Future<void> sendCommand(CommandModel command) async {
    _recentCommands.insert(0, command);
    _commandStreamController.add(command);
    _recentController.add(List.unmodifiable(_recentCommands));
  }

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) {
    return _commandStreamController.stream;
  }

  @override
  Stream<List<CommandModel>> listenToRecentCommands(String childId) {
    return _recentController.stream;
  }

  @override
  Future<void> updateCommandStatus(String commandId, CommandStatus status) async {
    final index = _recentCommands.indexWhere((c) => c.id == commandId);
    if (index != -1) {
      _recentCommands[index] = CommandModel(
        id: _recentCommands[index].id,
        childId: _recentCommands[index].childId,
        deviceId: _recentCommands[index].deviceId,
        action: _recentCommands[index].action,
        payload: _recentCommands[index].payload,
        status: status,
        createdAt: _recentCommands[index].createdAt,
      );
      _recentController.add(List.unmodifiable(_recentCommands));
    }
  }
}

/// إدارة ربط واقتران الأجهزة محلياً
class InMemoryPairingDataSource implements FirestorePairingDataSource {
  String _activeCode = '842915';

  @override
  Future<PairingCodeModel> generatePairingCode(
      String parentId, String childId) async {
    _activeCode = '842915';
    return PairingCodeModel(
      id: 'pairing_demo_code',
      code: _activeCode,
      parentId: parentId,
      childId: childId,
      expiresAt: DateTime.now().add(const Duration(minutes: 15)),
      isUsed: false,
    );
  }

  @override
  Future<PairingCodeModel?> verifyPairingCode(String code) async {
    // يقبل الكود الافتراضي أو أي كود مكون من 6 أرقام لتسهيل فحص وتجربة المحاكي
    if (code.length == AppConstants.pairingCodeLength) {
      return PairingCodeModel(
        id: 'pairing_verified_${DateTime.now().millisecondsSinceEpoch}',
        code: code,
        parentId: 'demo_parent_id',
        childId: 'demo_child_1',
        expiresAt: DateTime.now().add(const Duration(minutes: 15)),
        isUsed: false,
      );
    }
    return null;
  }

  @override
  Future<void> markCodeAsUsed(String codeId, String deviceId) async {}

  @override
  Future<void> registerDevice(DeviceModel device) async {}
}

/// إدارة تقارير الاستخدام محلياً
class InMemoryUsageDataSource implements FirestoreUsageDataSource {
  final Map<String, UsageReportModel> _reports = {};
  final StreamController<UsageReportModel?> _usageController =
      StreamController<UsageReportModel?>.broadcast();

  @override
  Future<void> saveUsageReport(UsageReportModel report) async {
    _reports[report.id] = report;
    _usageController.add(report);
  }

  @override
  Future<UsageReportModel?> getUsageReport(String childId, String date) async {
    return _reports['${childId}_$date'];
  }

  @override
  Stream<UsageReportModel?> listenUsageReport(String childId, String date) {
    return _usageController.stream;
  }
}
