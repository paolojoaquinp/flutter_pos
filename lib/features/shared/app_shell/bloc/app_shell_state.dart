part of 'app_shell_bloc.dart';

sealed class AppShellState extends Equatable {
  final int currentPageIndex;
  
  const AppShellState({
    this.currentPageIndex = 0,
  });
  
  @override
  List<Object> get props => [currentPageIndex];
  
  AppShellState copyWith({
    int? currentPageIndex,
  });
}

final class AppShellInitial extends AppShellState {
  const AppShellInitial() : super(currentPageIndex: 0);
  
  @override
  AppShellState copyWith({
    int? currentPageIndex,
  }) {
    return AppShellLoaded(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}

final class AppShellLoaded extends AppShellState {
  const AppShellLoaded({
    super.currentPageIndex,
  });
  
  @override
  AppShellState copyWith({
    int? currentPageIndex,
  }) {
    return AppShellLoaded(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
    );
  }
}