import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/core/widgets/state_views.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/bloc/venue_detail_cubit.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/bloc/venue_detail_state.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/widgets/slot_grid.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/widgets/venue_extensions.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({
    super.key,
    required this.venueId,
    required this.userId,
  });

  final String venueId;
  final String userId;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  late final VenueDetailCubit _cubit;
  Timer? _pollTimer;
  bool _bookingSucceeded = false;

  @override
  void initState() {
    super.initState();
    _cubit = VenueDetailCubit(
      getVenueUseCase: Injection.getVenueUseCase,
      getSlotsUseCase: Injection.getSlotsUseCase,
      createBookingUseCase: Injection.createBookingUseCase,
      venueId: widget.venueId,
      userId: widget.userId,
    )..initialize();

    // Poll every 5s so slots flip to "booked" when someone else books.
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && !_cubit.state.isBooking) {
        _cubit.loadSlots(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _cubit.close();
    super.dispose();
  }

  void _pop([bool? result]) {
    Navigator.of(context).pop(result ?? _bookingSucceeded);
  }

  Future<void> _pickDate() async {
    final current = _cubit.state.selectedDate;
    final initial = current != null ? DateTime.parse(current) : DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) await _cubit.setDate(picked);
  }

  Future<void> _onSlotTap(SlotEntity slot) async {
    final venue = _cubit.state.venue;
    if (venue == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm booking'),
        content: Text(
          'Book ${venue.name} on ${DateFormat('EEE, d MMM').format(slot.startTime)} '
          'at ${DateFormat('h:mm a').format(slot.startTime)}?\n\n'
          '₹${venue.pricePerHour}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Book')),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await _cubit.bookSlot(slot);
      if (ok) _bookingSucceeded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _pop();
      },
      child: BlocProvider.value(
        value: _cubit,
        child: BlocListener<VenueDetailCubit, VenueDetailState>(
          listenWhen: (p, c) =>
              p.bookingFeedback != c.bookingFeedback && c.bookingFeedback != null,
          listener: (context, state) {
            final msg = state.bookingFeedback!;
            final isSuccess = msg.contains('confirmed');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor:
                    isSuccess ? Colors.green.shade700 : Colors.orange.shade800,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: BlocBuilder<VenueDetailCubit, VenueDetailState>(
            builder: (context, state) {
              final venue = state.venue;
              return Scaffold(
                appBar: AppBar(
                  title: Text(venue?.name ?? 'Venue'),
                  leading: BackButton(onPressed: () => _pop()),
                ),
                body: RefreshIndicator(
                  onRefresh: _cubit.loadSlots,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (venue != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(venue.emoji,
                                        style: const TextStyle(fontSize: 32)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(venue.typeLabel),
                                          Text(venue.location,
                                              style: TextStyle(
                                                  color: Colors.grey.shade600)),
                                        ],
                                      ),
                                    ),
                                    Text('₹${venue.pricePerHour}/hr',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(venue.description),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month),
                        label: Text(state.selectedDate ?? 'Pick date'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Slots refresh every 5s · Green = available · Red = booked',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      if (state.isBooking) const LinearProgressIndicator(),
                      _buildSlots(state),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSlots(VenueDetailState state) {
    return switch (state.status) {
      ViewState.loading || ViewState.idle =>
        const LoadingView(message: 'Loading slots...'),
      ViewState.error => ErrorView(
          message: state.errorMessage ?? 'Error',
          onRetry: _cubit.loadSlots,
        ),
      ViewState.empty => const EmptyView(title: 'No slots for this date'),
      ViewState.success => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${state.availableCount} slots available',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            SlotGrid(
              slots: state.slots,
              onSlotTap: _onSlotTap,
              isBooking: state.isBooking,
            ),
          ],
        ),
    };
  }
}
