import 'package:equatable/equatable.dart';

// ============================================================================
// 📌 حالات لوحة المشرف العامة (Admin Dashboard State)
// ----------------------------------------------------------------------------
// تمثل الإحصائيات الشاملة، قوائم العوائل، وسجل دعم الطوارئ.
// ============================================================================

class AdminFamilyItem extends Equatable {
  final String id;
  final String parentName;
  final String email;
  final String plan; // Free, Pro, Enterprise
  final int childrenCount;
  final bool isActive;
  final DateTime registeredAt;

  const AdminFamilyItem({
    required this.id,
    required this.parentName,
    required this.email,
    required this.plan,
    required this.childrenCount,
    required this.isActive,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [id, parentName, email, plan, childrenCount, isActive, registeredAt];
}

class AdminDashboardState extends Equatable {
  final int totalFamilies;
  final int totalChildren;
  final int onlineDevices;
  final int activeBlocks;
  final int firebaseQuotaPercent;
  final int selectedTab;
  final String searchQuery;
  final List<AdminFamilyItem> families;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const AdminDashboardState({
    this.totalFamilies = 1420,
    this.totalChildren = 2850,
    this.onlineDevices = 2130,
    this.activeBlocks = 345,
    this.firebaseQuotaPercent = 14,
    this.selectedTab = 0,
    this.searchQuery = '',
    this.families = const [],
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  List<AdminFamilyItem> get filteredFamilies {
    if (searchQuery.trim().isEmpty) return families;
    final q = searchQuery.toLowerCase();
    return families.where((f) =>
      f.parentName.toLowerCase().contains(q) ||
      f.email.toLowerCase().contains(q) ||
      f.id.toLowerCase().contains(q)
    ).toList();
  }

  AdminDashboardState copyWith({
    int? totalFamilies,
    int? totalChildren,
    int? onlineDevices,
    int? activeBlocks,
    int? firebaseQuotaPercent,
    int? selectedTab,
    String? searchQuery,
    List<AdminFamilyItem>? families,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      totalFamilies: totalFamilies ?? this.totalFamilies,
      totalChildren: totalChildren ?? this.totalChildren,
      onlineDevices: onlineDevices ?? this.onlineDevices,
      activeBlocks: activeBlocks ?? this.activeBlocks,
      firebaseQuotaPercent: firebaseQuotaPercent ?? this.firebaseQuotaPercent,
      selectedTab: selectedTab ?? this.selectedTab,
      searchQuery: searchQuery ?? this.searchQuery,
      families: families ?? this.families,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    totalFamilies,
    totalChildren,
    onlineDevices,
    activeBlocks,
    firebaseQuotaPercent,
    selectedTab,
    searchQuery,
    families,
    isLoading,
    successMessage,
    errorMessage,
  ];
}
