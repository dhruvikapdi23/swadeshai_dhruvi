import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swadesai_dhruvi/core/theme/app_theme.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';

class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.slots,
    required this.onSlotTap,
    this.isBooking = false,
  });

  final List<SlotEntity> slots;
  final ValueChanged<SlotEntity> onSlotTap;
  final bool isBooking;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.3,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final available = slot.status == SlotStatus.available;
        final time = DateFormat('h:mm a').format(slot.startTime);

        return Material(
          color: available ? AppTheme.available : AppTheme.booked,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: available && !isBooking ? () => onSlotTap(slot) : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: available ? AppTheme.availableBorder : AppTheme.bookedBorder,
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(time, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(
                    available ? 'Available' : 'Booked',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
