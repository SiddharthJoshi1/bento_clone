import '../entities/link.dart';

abstract class LinkRepository {
  LinkConfig getLinkData(String url);
}

class LinkRepositoryImpl implements LinkRepository {
  // The Data Map
  static const Map<String, LinkConfig> _platforms = {
    'instagram': LinkConfig(
      linkTitle: 'Instagram',
      linkIcon: 'fa-brands fa-instagram',
      brandColour: '#E1306C',
    ),
    'facebook': LinkConfig(
      linkTitle: 'Facebook',
      linkIcon: 'fa-brands fa-facebook',
      brandColour: '#1877F2',
    ),
    'twitter': LinkConfig(
      linkTitle: 'Twitter',
      linkIcon: 'fa-brands fa-twitter',
      brandColour: '#1DA1F2',
    ),
    'x.com': LinkConfig(
      linkTitle: 'X',
      linkIcon: 'fa-brands fa-x-twitter',
      brandColour: '#000000',
    ),
    'tiktok': LinkConfig(
      linkTitle: 'TikTok',
      linkIcon: 'fa-brands fa-tiktok',
      brandColour: '#000000',
    ),
    'youtube': LinkConfig(
      linkTitle: 'YouTube',
      linkIcon: 'fa-brands fa-youtube',
      brandColour: '#FF0000',
    ),
    'linkedin': LinkConfig(
      linkTitle: 'LinkedIn',
      linkIcon: 'fa-brands fa-linkedin',
      brandColour: '#006699',
    ),
    'snapchat': LinkConfig(
      linkTitle: 'Snapchat',
      linkIcon: 'fa-brands fa-snapchat',
      brandColour: '#FFFC00',
    ),
    'pinterest': LinkConfig(
      linkTitle: 'Pinterest',
      linkIcon: 'fa-brands fa-pinterest',
      brandColour: '#BD081C',
    ),
    'spotify': LinkConfig(
      linkTitle: 'Spotify',
      linkIcon: 'fa-brands fa-spotify',
      brandColour: '#1DB954',
    ),
    'apple': LinkConfig(
      linkTitle: 'Apple Music',
      linkIcon: 'fa-brands fa-apple',
      brandColour: '#FA243C',
    ),
    'soundcloud': LinkConfig(
      linkTitle: 'SoundCloud',
      linkIcon: 'fa-brands fa-soundcloud',
      brandColour: '#FF5500',
    ),
    'twitch': LinkConfig(
      linkTitle: 'Twitch',
      linkIcon: 'fa-brands fa-twitch',
      brandColour: '#9146FF',
    ),
    'discord': LinkConfig(
      linkTitle: 'Discord',
      linkIcon: 'fa-brands fa-discord',
      brandColour: '#5865F2',
    ),
    'reddit': LinkConfig(
      linkTitle: 'Reddit',
      linkIcon: 'fa-brands fa-reddit',
      brandColour: '#FF4500',
    ),
    'whatsapp': LinkConfig(
      linkTitle: 'WhatsApp',
      linkIcon: 'fa-brands fa-whatsapp',
      brandColour: '#25D366',
    ),
    'telegram': LinkConfig(
      linkTitle: 'Telegram',
      linkIcon: 'fa-brands fa-telegram',
      brandColour: '#26A5E4',
    ),
    'patreon': LinkConfig(
      linkTitle: 'Patreon',
      linkIcon: 'fa-brands fa-patreon',
      brandColour: '#FF424D',
    ),
    'github': LinkConfig(
      linkTitle: 'GitHub',
      linkIcon: 'fa-brands fa-github',
      brandColour: '#181717',
    ),
    'medium': LinkConfig(
      linkTitle: 'Medium',
      linkIcon: 'fa-brands fa-medium',
      brandColour: '#000000',
    ),
    'behance': LinkConfig(
      linkTitle: 'Behance',
      linkIcon: 'fa-brands fa-behance',
      brandColour: '#1769FF',
    ),
    'dribbble': LinkConfig(
      linkTitle: 'Dribbble',
      linkIcon: 'fa-brands fa-dribbble',
      brandColour: '#EA4C89',
    ),
    'threads': LinkConfig(
      linkTitle: 'Threads',
      linkIcon: 'fa-brands fa-threads',
      brandColour: '#000000',
    ),
    'substack': LinkConfig(
      linkTitle: 'Substack',
      linkIcon: 'fa-brands fa-substack',
      brandColour: '#FF6719',
    ),
  };

  @override
  LinkConfig getLinkData(String url) {
    if (url.isEmpty) return LinkConfig.fallback;

    // Normalize URL to handle 'www', 'https', etc.
    Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      // Try adding https if missing to help parsing
      uri = Uri.tryParse('https://$url');
    }

    // Get the host (e.g., "www.instagram.com")
    final host = uri?.host.toLowerCase() ?? "";

    // 1. Handle Special Short/Alternative Domains
    if (host.contains('youtu.be')) return _platforms['youtube']!;
    if (host.contains('t.me')) return _platforms['telegram']!;
    if (host.contains('music.apple.com')) return _platforms['apple']!;

    // 2. Iterate through keys to find a match in the host
    for (final key in _platforms.keys) {
      if (host.contains(key)) {
        return _platforms[key]!;
      }
    }

    // 3. Return default if no match found
    return LinkConfig.fallback;
  }
}
