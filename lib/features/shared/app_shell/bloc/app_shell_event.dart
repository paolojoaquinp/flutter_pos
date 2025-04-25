part of 'app_shell_bloc.dart';

sealed class AppShellEvent extends Equatable {
  const AppShellEvent();
}

class AppShellPageChangedEvent extends AppShellEvent {
  final int pageIndex;

  const AppShellPageChangedEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
} 