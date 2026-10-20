import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import '../../models/command_model.dart';

// ============================================================================
// 📌 مصدر بيانات الأوامر من Firestore (Firestore Command DataSource)
// ----------------------------------------------------------------------------
// يدير حفظ أوامر الأب والاستماع المباشر لها من قبل جهاز الطفل.
// ============================================================================

abstract class FirestoreCommandDataSource {
  Future<void> sendCommand(CommandModel command);
  Stream<CommandModel> listenToCommands(String childId, String deviceId);
  Future<void> updateCommandStatus(String commandId, CommandStatus status);
}

class FirestoreCommandDataSourceImpl implements FirestoreCommandDataSource {
  final FirebaseFirestore _firestore;

  FirestoreCommandDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _commandsCollection =>
      _firestore.collection(AppConstants.commandsCollection);

  @override
  Future<void> sendCommand(CommandModel command) async {
    try {
      await _commandsCollection.doc(command.id).set(command.toMap());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<CommandModel> listenToCommands(String childId, String deviceId) {
    return _commandsCollection
        .where('childId', isEqualTo: childId)
        .where('deviceId', isEqualTo: deviceId)
        .where('status', isEqualTo: CommandStatus.pending.name)
        .snapshots()
        .expand((snapshot) => snapshot.docChanges)
        .where((change) => change.type == DocumentChangeType.added)
        .map((change) => CommandModel.fromMap(
            change.doc.data()!, change.doc.id));
  }

  @override
  Future<void> updateCommandStatus(
      String commandId, CommandStatus status) async {
    try {
      await _commandsCollection.doc(commandId).update({
        'status': status.name,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
