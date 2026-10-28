import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/models/user_profile.dart';
import '../../auth/views/viewmodel/login_cubit.dart';
import '../../auth/views/viewmodel/login_state.dart';

/// Profile tab of the main shell.
///
/// Reuses the existing [LoginCubit]: a logged-in user sees the data the login
/// response really contained; everyone else sees the Guest Profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _bg = Color(0xFFF5EEE8);
  static const _dark = Color(0xFF5C453D);
  static const _brown = Color(0xFF8B5E52);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _dark,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            final user = state.user;
            return state.isLoggedIn && user != null
                ? _UserProfileView(user: user)
                : const _GuestProfileView();
          },
        ),
      ),
    );
  }
}

class _GuestProfileView extends StatelessWidget {
  const _GuestProfileView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Avatar(),
            const SizedBox(height: 16),
            const Text(
              'Guest User',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ProfileScreen._dark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You are browsing as a guest. Log in or sign up to see your '
              'profile information.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: ProfileScreen._brown,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                ),
                style: _buttonStyle,
                child: const Text(
                  'Login / Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileView extends StatelessWidget {
  final UserProfile user;

  const _UserProfileView({required this.user});

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      MapEntry('Username', user.username),
      if (user.email != null) MapEntry('Email', user.email!),
      if (user.gender != null) MapEntry('Gender', user.gender!),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _Avatar(imageUrl: user.image),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: ProfileScreen._dark,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [for (final r in rows) _InfoRow(r.key, r.value)],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.read<LoginCubit>().logout(),
              style: _buttonStyle,
              child: const Text('Log Out', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: ProfileScreen._brown),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ProfileScreen._dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Round avatar: the user's picture when there is one, otherwise a person
/// icon (also used when the picture cannot be loaded).
class _Avatar extends StatelessWidget {
  final String? imageUrl;

  const _Avatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    const size = 96.0;
    const fallback = Icon(Icons.person, size: 56, color: Colors.white);

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ProfileScreen._brown,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl == null
          ? fallback
          : Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: ProfileScreen._dark,
  foregroundColor: Colors.white,
  elevation: 0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
);
