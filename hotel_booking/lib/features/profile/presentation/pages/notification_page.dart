import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/user_notification/user_notification_bloc.dart';
import '../bloc/user_notification/user_notification_event.dart';
import '../bloc/user_notification/user_notification_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: Text('Please log in.')));
    }
    final userId = authState.user.id;

    return BlocProvider(
      create: (context) => sl<UserNotificationBloc>()..add(StartNotificationStream(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: BlocBuilder<UserNotificationBloc, UserNotificationState>(
          builder: (context, state) {
             if (state is NotificationLoading) {
               return const Center(child: CircularProgressIndicator());
             } else if (state is NotificationError) {
               return Center(child: Text('Error: ${state.message}'));
             } else if (state is NotificationsLoaded) {
               final items = state.notifications;
               if (items.isEmpty) {
                 return const Center(child: Text('No notifications.'));
               }
               return ListView.builder(
                 itemCount: items.length,
                 itemBuilder: (context, index) {
                   final item = items[index];
                   return Card(
                     color: item.isRead ? Colors.white : Colors.blue.shade50,
                     child: ListTile(
                       title: Text(item.title, style: TextStyle(fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold)),
                       subtitle: Text(item.body),
                       trailing: Text('${item.timestamp.hour}:${item.timestamp.minute}'),
                       onTap: () {
                         if (!item.isRead) {
                           context.read<UserNotificationBloc>().add(MarkAsReadEvent(userId, item.id));
                         }
                         // Navigate to related entity if needed
                       },
                     ),
                   );
                 },
               );
             }
             return const Center(child: Text('Loading notifications...'));
          },
        ),
      ),
    );
  }
}
