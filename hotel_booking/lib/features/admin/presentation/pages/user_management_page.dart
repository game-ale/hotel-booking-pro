import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../bloc/admin_user_bloc.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminUserBloc>()..add(LoadAllUsers()),
      child: BlocBuilder<AdminUserBloc, AdminUserState>(
        builder: (context, state) {
          if (state is AdminUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminUserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text(user.email),
                  subtitle: Text('Role: ${user.role}'),
                  trailing: user.isSuspended
                      ? ElevatedButton(
                          onPressed: () {
                            context.read<AdminUserBloc>().add(SuspendUserEvent(user.id, false));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Unsuspend'),
                        )
                      : ElevatedButton(
                          onPressed: () {
                             context.read<AdminUserBloc>().add(SuspendUserEvent(user.id, true));
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Suspend'),
                        ),
                );
              },
            );
          } else if (state is AdminUserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
