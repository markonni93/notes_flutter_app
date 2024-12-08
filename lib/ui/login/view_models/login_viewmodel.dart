import 'package:logger/logger.dart';

import '../../../data/repositories/auth/auth_repository.dart';
import '../../../util/command.dart';
import '../../../util/result.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    login = Command0<void>(_login);
  }

  final AuthRepository _authRepository;

  late Command0 login;

  final _log = Logger();

  Future<Result<void>> _login() async {
    final result = await _authRepository.login();

    if (result is Error<void>) {
      _log.e("Error log", error: "$result");
    }
    return result;
  }
}
