import 'package:equatable/equatable.dart';

abstract class AppShellEvent extends Equatable {
  const AppShellEvent();

  @override
  List<Object?> get props => [];
}

class AppShellPageChangedEvent extends AppShellEvent {
  final int pageIndex;

  const AppShellPageChangedEvent(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
} 