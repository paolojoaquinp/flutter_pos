import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_shell_event.dart';
part 'app_shell_state.dart';

class AppShellBloc extends Bloc<AppShellEvent, AppShellState> {
  AppShellBloc() : super(AppShellInitial()) {
    on<AppShellEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AppShellPageChangedEvent>(_onPageChanged);
  }

  void _onPageChanged(
    AppShellPageChangedEvent event,
    Emitter<AppShellState> emit,
  ) {
    emit(state.copyWith(currentPageIndex: event.pageIndex));
  }
}
