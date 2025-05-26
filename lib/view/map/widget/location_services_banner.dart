import 'package:altur_nearby_stops/core/extension/context.dart';
import 'package:altur_nearby_stops/core/init/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationServicesBanner extends StatelessWidget {
  const LocationServicesBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colorScheme.error.withAlpha(102), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withAlpha(51),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.location_disabled, color: context.colorScheme.error, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  LocaleKeys.location_services_title.tr(),
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            LocaleKeys.location_services_description.tr(),
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onErrorContainer.withAlpha(204),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              icon: Icon(Icons.location_on, size: 18, color: context.colorScheme.onPrimary),
              label: Text(
                LocaleKeys.location_services_go_to_settings.tr(),
                style: TextStyle(color: context.colorScheme.onPrimary, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
