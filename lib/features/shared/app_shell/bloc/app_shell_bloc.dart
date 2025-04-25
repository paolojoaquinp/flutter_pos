import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_shell_event.dart';
import 'app_shell_state.dart';

class AppShellBloc extends Bloc<AppShellEvent, AppShellState> {
  AppShellBloc() : super(const AppShellState()) {
    on<AppShellPageChangedEvent>(_onPageChanged);
  }

  void _onPageChanged(
    AppShellPageChangedEvent event,
    Emitter<AppShellState> emit,
  ) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }
} 