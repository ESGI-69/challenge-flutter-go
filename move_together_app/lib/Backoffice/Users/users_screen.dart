import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Backoffice/Users/users_table.dart';
import 'package:move_together_app/Backoffice/Widgets/navigation_bar_backoffice.dart';
import 'package:move_together_app/Backoffice/Users/bloc/users_bloc.dart';
import 'package:move_together_app/core/models/user.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({
    super.key
});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  void changeUserRole(User user){
    print('current user passed $user');
    final newRole = user.role == Role.ADMIN ? Role.USER : Role.ADMIN;

    final newUser = User(
      id: user.id,
      name: user.name,
      role: newRole,
    );

    print('Changing role of user ${user.name} to ${roleToString[newRole]}');
    context.read<UsersBloc>().add(UserDataUpdateUser(newUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationBarBackoffice(),
      body: BlocProvider(
        create: (context) => UsersBloc(context)..add(UsersDataFetch()),
        child: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersDataLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UsersDataLoadingError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is UsersDataLoadingSuccess) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const Text(
                      'LIST OF USERS',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: UsersTable(
                        users: state.users,
                        changeUserRole: changeUserRole,
                      ),
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          }
        )
      ),
    );
  }
}