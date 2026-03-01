import 'package:flutter/material.dart';

import '../../core/injector.dart';
import '../../core/responsive/breakpoints.dart';
import '../../domain/repos/profile_repo.dart';
import '../theme/app_theme.dart';

/// Profile display — adapts its own layout for desktop and mobile.
///
/// On desktop it sits in the left side panel: horizontally padded with
/// [AppInsets.xxl] and vertically centred via [MainAxisAlignment.center].
///
/// On mobile it renders inline inside the tile scroll view, using standard
/// horizontal padding and tighter spacing.
///
/// Both contexts read from [ProfileRepository], which is loaded from
/// `assets/data/content.json` at startup.
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = locator<ProfileRepository>().getProfile();
    final bool isDesktop = Breakpoints.isDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppInsets.xxl : AppInsets.l,
      ),
      child: Column(
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) const SizedBox(height: 80),
          if (isDesktop)
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(profile.avatarPath),
            )
          else
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(profile.avatarPath),
              ),
            ),
          const SizedBox(height: 50),
          Text(
            profile.name,
            style: isDesktop
                ? Theme.of(context).textTheme.displayMedium
                : Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            profile.bio,
            softWrap: true,
            style: isDesktop
                ? Theme.of(context).textTheme.titleLarge
                : Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
