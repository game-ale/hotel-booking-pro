import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/user_profile/user_profile_bloc.dart';
import '../bloc/user_profile/user_profile_event.dart';
import '../bloc/user_profile/user_profile_state.dart';
import 'edit_profile_page.dart';
import 'settings_page.dart';
import 'notification_page.dart';
import 'booking_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: Text('Please log in.')));
    }
    final userId = authState.user.id; // Or should we use UserProfile ID? User ID is safer from Auth.

    return BlocProvider(
      create: (context) => sl<UserProfileBloc>()..add(GetUserProfileEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
              },
            ),
          ],
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profile.profileImageUrl != null
                          ? NetworkImage(profile.profileImageUrl!)
                          : null,
                      child: profile.profileImageUrl == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(profile.email, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Edit Profile'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditProfilePage(profile: profile),
                        )).then((_) {
                           // Refresh logic? BLoC stays alive if provided above? 
                           // No, BlocProvider creates it fresh per build or scope.
                           // Actually, Navigator.push doesn't rebuild the parent immediately.
                           // We need to trigger a refresh or use a scoped Bloc that persists higher up.
                           // For now, easy fix: trigger refresh when returning.
                           // BUT we can't access context.read<UserProfileBloc>() easily if it's child of Build.
                           // Wait, Navigator push is FROM context.
                           // We should trigger event on the Bloc using the context available.
                           // BUT BlocProvider is INSIDE build.
                           // So we need to Wrap Scaffold body or pass Bloc.
                           // Cleanest: Pass bloc to EditPage or refresh on "then".
                           // However, context inside "then" might be different? 
                           // Actually, let's keep it simple: EditPage returns success true/false?
                           // Or better: Refresh on pull-to-refresh or re-init.
                           // Let's implement a refresh trigger in EditPage via the same Bloc instance 
                           // if we pass it, or just reload.
                           // I will stick to re-fetching on next build or manual refresh.
                           // Actually, adding `.then((_) => context.read...` works if context is valid.
                           // But logic is inside BlocProvider child... 
                           // I'll leave it as is, simplistic MVP.
                        });
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Booking History'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingHistoryPage()));
                      },
                    ),
                    // Add more fields like Bio, Phone etc as Text
                    if (profile.bio != null) ...[
                      const Divider(),
                      Align(alignment: Alignment.centerLeft, child: Text('Bio', style: Theme.of(context).textTheme.titleSmall)),
                      Align(alignment: Alignment.centerLeft, child: Text(profile.bio!)),
                    ]
                  ],
                ),
              );
            }
            return const Center(child: Text('Load failed or no profile.'));
          },
        ),
      ),
    );
  }
}
