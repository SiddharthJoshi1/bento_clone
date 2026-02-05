class LinkConfig {
  final String linkTitle;
  final String linkIcon;
  final String brandColour;

  const LinkConfig({
    required this.linkTitle,
    required this.linkIcon,
    required this.brandColour,
  });

  static LinkConfig fallback = LinkConfig(
    linkTitle: 'Website',
    linkIcon: 'fa-solid fa-link',
    brandColour: '#000000',
  );
}
