import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sg_core/sg_core.dart';
import 'package:sg_domain/sg_domain.dart';
import 'package:sg_ui/sg_ui.dart';
import '../cubit/command_cubit.dart';
import '../cubit/command_state.dart';

/// ============================================================================
/// 📌 واجهة التحكم الفوري عن بعد (Remote Control Sheet) - Smart Guardian
/// ----------------------------------------------------------------------------
/// تتيح لولي الأمر إرسال أوامر القفل، التمديد، وحظر التطبيقات، وتحديث الموقع لحظياً.
/// ============================================================================

class RemoteControlSheet extends StatefulWidget {
  final ChildEntity child;
  final String deviceId;

  const RemoteControlSheet({
    super.key,
    required this.child,
    this.deviceId = 'device_demo_1',
  });

  @override
  State<RemoteControlSheet> createState() => _RemoteControlSheetState();
}

class _RemoteControlSheetState extends State<RemoteControlSheet> {
  final TextEditingController _packageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommandCubit>().listenToRecentCommands(widget.child.id);
  }

  @override
  void dispose() {
    _packageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: BlocConsumer<CommandCubit, CommandState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
              context.read<CommandCubit>().clearMessages();
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: AppColors.danger,
                ),
              );
              context.read<CommandCubit>().clearMessages();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // شريط السحب العلوي
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // عنوان النافذة
                  Row(
                    children: [
                      const Icon(Icons.settings_remote,
                          color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التحكم الفوري: ${widget.child.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'تنفيذ مباشر عبر Firebase Cloud Messaging',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // 1. أزرار القفل وفك القفل
                  Row(
                    children: [
                      Expanded(
                        child: SgButton(
                          label: 'قفل الجهاز',
                          type: SgButtonType.danger,
                          icon: Icons.lock,
                          isLoading: state.isSending,
                          onPressed: () {
                            context.read<CommandCubit>().lockDevice(
                                  childId: widget.child.id,
                                  deviceId: widget.deviceId,
                                );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SgButton(
                          label: 'إلغاء القفل',
                          type: SgButtonType.secondary,
                          icon: Icons.lock_open,
                          isLoading: state.isSending,
                          onPressed: () {
                            context.read<CommandCubit>().unlockDevice(
                                  childId: widget.child.id,
                                  deviceId: widget.deviceId,
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 2. تمديد وقت الشاشة السريع
                  const Text(
                    'تمديد وقت الشاشة المسموح اليوم:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildExtendTimeButton(context, 15, state.isSending),
                      const SizedBox(width: 8),
                      _buildExtendTimeButton(context, 30, state.isSending),
                      const SizedBox(width: 8),
                      _buildExtendTimeButton(context, 60, state.isSending),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 3. قسم تقييد وحظر التطبيقات
                  const Text(
                    'حظر تطبيق محدد (اسم الحزمة):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _packageController,
                          decoration: InputDecoration(
                            hintText: 'مثال: com.zhiliaoapp.musically',
                            hintStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'حظر التطبيق',
                        icon: const Icon(Icons.block, color: AppColors.danger),
                        onPressed: () {
                          context.read<CommandCubit>().blockApp(
                                childId: widget.child.id,
                                deviceId: widget.deviceId,
                                packageName: _packageController.text,
                              );
                        },
                      ),
                      IconButton(
                        tooltip: 'إلغاء حظر التطبيق',
                        icon: const Icon(Icons.check_circle_outline,
                            color: AppColors.success),
                        onPressed: () {
                          context.read<CommandCubit>().unblockApp(
                                childId: widget.child.id,
                                deviceId: widget.deviceId,
                                packageName: _packageController.text,
                              );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4. طلب الموقع الجغرافي الفوري
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.my_location, color: AppColors.primary),
                    label: const Text('طلب الموقع الجغرافي الفوري (GPS)'),
                    onPressed: state.isSending
                        ? null
                        : () {
                            context.read<CommandCubit>().requestLocation(
                                  childId: widget.child.id,
                                  deviceId: widget.deviceId,
                                );
                          },
                  ),
                  const SizedBox(height: 20),

                  // 5. سجل الأوامر الأخيرة وحالة تنفيذها
                  if (state.recentCommands.isNotEmpty) ...[
                    const Text(
                      'سجل الأوامر الحديثة وحالة تنفيذها:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    ...state.recentCommands.take(3).map((cmd) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _buildCommandStatusIcon(cmd.status),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _formatActionName(cmd.action),
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              _formatStatusName(cmd.status),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(cmd.status),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildExtendTimeButton(
      BuildContext context, int minutes, bool isSending) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isSending
            ? null
            : () {
                context.read<CommandCubit>().extendScreenTime(
                      childId: widget.child.id,
                      deviceId: widget.deviceId,
                      additionalMinutes: minutes,
                    );
              },
        child: Text('+$minutes د'),
      ),
    );
  }

  Widget _buildCommandStatusIcon(CommandStatus status) {
    switch (status) {
      case CommandStatus.executed:
        return const Icon(Icons.check_circle, color: AppColors.success, size: 18);
      case CommandStatus.delivered:
        return const Icon(Icons.done_all, color: AppColors.primary, size: 18);
      case CommandStatus.failed:
        return const Icon(Icons.cancel, color: AppColors.danger, size: 18);
      case CommandStatus.pending:
        return const Icon(Icons.access_time, color: AppColors.warning, size: 18);
    }
  }

  String _formatActionName(String action) {
    switch (action) {
      case AppConstants.commandLockDevice:
        return 'قفل الجهاز فوراً';
      case AppConstants.commandUnlockDevice:
        return 'إلغاء قفل الجهاز';
      case AppConstants.commandExtendScreenTime:
        return 'تمديد وقت الشاشة';
      case AppConstants.commandBlockApp:
        return 'حظر تطبيق محدد';
      case AppConstants.commandUnblockApp:
        return 'إلغاء حظر تطبيق';
      case AppConstants.commandRequestLocation:
        return 'طلب الموقع الجغرافي';
      default:
        return action;
    }
  }

  String _formatStatusName(CommandStatus status) {
    switch (status) {
      case CommandStatus.executed:
        return 'تم التنفيذ ✅';
      case CommandStatus.delivered:
        return 'تم الاستلام 📲';
      case CommandStatus.failed:
        return 'فشل التنفيذ ❌';
      case CommandStatus.pending:
        return 'قيد الإرسال ⏳';
    }
  }

  Color _getStatusColor(CommandStatus status) {
    switch (status) {
      case CommandStatus.executed:
        return AppColors.success;
      case CommandStatus.delivered:
        return AppColors.primary;
      case CommandStatus.failed:
        return AppColors.danger;
      case CommandStatus.pending:
        return AppColors.warning;
    }
  }
}
