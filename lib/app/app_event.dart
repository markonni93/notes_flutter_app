sealed class AppEvent {
  const AppEvent();
}

final class AppUserSubscriptionRequested extends AppEvent {
  const AppUserSubscriptionRequested();
}

final class LogoutRequested extends AppEvent {
  const LogoutRequested();
}
