import 'package:flutter/cupertino.dart';

import '../../../util/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;

  Future<Result<void>> login();

  Future<Result<void>> logout();

  Future<Result<void>> skipLogin();
}
