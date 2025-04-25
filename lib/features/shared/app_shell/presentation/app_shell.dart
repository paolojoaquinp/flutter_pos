import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/features/home_screen/presentation/home_screen.dart';
import 'package:flutter_pos/features/products_screen/presentation/products_screen.dart';
import 'package:flutter_pos/features/profile_screen/presentation/profile_screen.dart';
import 'package:flutter_pos/features/shared/app_shell/bloc/app_shell_bloc.dart';
import 'widgets/nav_bar_item.dart';


class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const String route = '/';

  static final List<Widget> _pages = [
    const HomeScreen(),
    const ProductScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppShellBloc(),
      child: BlocBuilder<AppShellBloc, AppShellState>(
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state.currentPageIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: BottomAppBar(
                  height: 70,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Home Button
                      NavBarItem(
                        icon: Icon(
                          state.currentPageIndex == 0
                           ? Icons.home
                           : Icons.home_outlined,
                          color: state.currentPageIndex == 0
                              ? const Color(0xFF369F6B)
                              : Colors.grey,
                          size: 28,
                        ),
                        isSelected: state.currentPageIndex == 0,
                        onTap: () => context
                            .read<AppShellBloc>()
                            .add(const AppShellPageChangedEvent(0)),
                      ),
                      // Search Button
                      NavBarItem(
                        icon: Icon(
                          state.currentPageIndex == 1 
                            ? Icons.folder
                            : Icons.folder_outlined,
                          color: state.currentPageIndex == 1
                              ? const Color(0xFF369F6B)
                              : Colors.grey,
                          size: 28,
                        ),
                        isSelected: state.currentPageIndex == 1,
                        onTap: () => context
                            .read<AppShellBloc>()
                            .add(const AppShellPageChangedEvent(1)),
                      ),
                      // Profile Button
                      NavBarItem(
                        icon: Icon(
                          state.currentPageIndex == 2 
                          ? Icons.person
                          : Icons.person_outline,
                          color: state.currentPageIndex == 2
                              ? const Color(0xFF369F6B)
                              : Colors.grey,
                          size: 28,
                        ),
                        isSelected: state.currentPageIndex == 2,
                        onTap: () => context
                            .read<AppShellBloc>()
                            .add(const AppShellPageChangedEvent(2)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 