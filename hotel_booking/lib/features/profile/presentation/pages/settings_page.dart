import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/user_settings.dart';
import '../bloc/user_settings/user_settings_bloc.dart';
import '../bloc/user_settings/user_settings_event.dart';
import '../bloc/user_settings/user_settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: Text('Please log in.')));
    }
    final userId = authState.user.id;

    return BlocProvider(
      create: (context) => sl<UserSettingsBloc>()..add(GetUserSettingsEvent(userId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: BlocBuilder<UserSettingsBloc, UserSettingsState>(
          builder: (context, state) {
            if (state is UserSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserSettingsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserSettingsLoaded) {
              final settings = state.settings;
              return ListView(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    value: settings.isPushEnabled,
                    onChanged: (val) {
                      _updateSettings(context, settings, isPushEnabled: val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Email Notifications'),
                    value: settings.isEmailEnabled,
                    onChanged: (val) {
                       _updateSettings(context, settings, isEmailEnabled: val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: settings.isDarkMode,
                    onChanged: (val) {
                       _updateSettings(context, settings, isDarkMode: val);
                    },
                  ),
                  ListTile(
                    title: const Text('Currency'),
                     subtitle: Text(settings.currency),
                     onTap: () {
                       // Show dialog to pick currency
                     },
                  ),
                  ListTile(
                     title: const Text('Language'),
                     subtitle: Text(settings.language),
                     onTap: () {
                       // Show dialog to pick language
                     },
                  ),
                ],
              );
            }
            return const Center(child: Text('Loading settings...'));
          },
        ),
      ),
    );
  }

  void _updateSettings(BuildContext context, UserSettings current, {bool? isPushEnabled, bool? isEmailEnabled, bool? isDarkMode}) {
     final newSettings = UserSettings(
       userId: current.userId,
       isPushEnabled: isPushEnabled ?? current.isPushEnabled,
       isEmailEnabled: isEmailEnabled ?? current.isEmailEnabled,
       isDarkMode: isDarkMode ?? current.isDarkMode,
       currency: current.currency,
       language: current.language,
     );
     context.read<UserSettingsBloc>().add(UpdateUserSettingsEvent(newSettings));
  }
}
