import 'package:quick_notes/data/repositories/auth/auth_repository.dart';
import 'package:quick_notes/util/command.dart';

import '../../../util/result.dart';

class HomeDrawerViewModel {
  HomeDrawerViewModel({required AuthRepository authRepository})
      : _repository = authRepository {
    logout = Command0<void>(_logout);
  }

  late Command0 logout;
  final AuthRepository _repository;

  Future<Result<void>> _logout() async {
    return await _repository.logout();
  }
}
