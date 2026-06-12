enum UserRole { owner, maid }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.owner:
        return 'Owner';
      case UserRole.maid:
        return 'Buyer';
    }
  }
}
