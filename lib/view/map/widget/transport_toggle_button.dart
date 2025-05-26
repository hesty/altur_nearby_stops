import 'package:altur_nearby_stops/view/map/model/marker_model.dart';
import 'package:altur_nearby_stops/core/init/language/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:altur_nearby_stops/core/extension/context.dart';

class TransportToggleButton extends StatelessWidget {
  final TransportType transportType;
  final bool isVisible;
  final VoidCallback onToggle;

  const TransportToggleButton({
    super.key,
    required this.transportType,
    required this.isVisible,
    required this.onToggle,
  });

  String _getTransportTypeName() {
    switch (transportType) {
      case TransportType.metrobus:
        return LocaleKeys.transport_type_metrobus.tr();
      case TransportType.bus:
        return LocaleKeys.transport_type_bus.tr();
      case TransportType.tram:
        return LocaleKeys.transport_type_tram.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = MarkerModel.fromTransportType(transportType, context);

    return Tooltip(
      message: _getTransportTypeName(),
      child: GestureDetector(
        onTap: onToggle,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isVisible ? config.color : context.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(color: context.colorScheme.onPrimary, width: 2),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withAlpha(51),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            config.icon,
            color: isVisible ? context.colorScheme.onPrimary : context.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
    );
  }
}
