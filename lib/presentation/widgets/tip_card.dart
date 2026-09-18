import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/tip.dart';

class TipCard extends StatelessWidget {
  final Tip tip;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.tip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentContainer.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tip.categorie.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tip.titre,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.lightbulb, color: AppColors.accent, size: 28),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tip.contenu,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
