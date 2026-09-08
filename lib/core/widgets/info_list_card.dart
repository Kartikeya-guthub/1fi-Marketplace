import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class InfoListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? badgeText;
  final VoidCallback? onTap;

  const InfoListCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.badgeText,
    this.onTap,
  });

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        color: AppColors.primaryPurple.withOpacity(0.1),
        child: Center(
          child: Text(
            title.isNotEmpty ? title[0].toUpperCase() : '?',
            style: const TextStyle(
              color: AppColors.primaryPurple,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    if (imageUrl!.startsWith('assets/')) {
      return Image.asset(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: AppColors.textSecondary),
      );
    }

    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: AppColors.textSecondary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.shimmerCardBase,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildImage(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.badgeBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.badgeText,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
