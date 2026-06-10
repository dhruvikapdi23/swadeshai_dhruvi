import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/core/widgets/state_views.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/bloc/my_bookings_cubit.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/bloc/my_bookings_state.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  Future<void> _cancel(BuildContext context, String bookingId) async {
    final cubit = context.read<MyBookingsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: const Text('This will free the slot for others.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final ok = await cubit.cancelBooking(bookingId);
      if (ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking cancelled')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyBookingsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: BlocBuilder<MyBookingsCubit, MyBookingsState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: cubit.loadBookings,
            child: switch (state.status) {
              ViewState.loading || ViewState.idle =>
                const LoadingView(message: 'Loading bookings...'),
              ViewState.error => ErrorView(
                  message: state.errorMessage ?? 'Error',
                  onRetry: cubit.loadBookings,
                ),
              ViewState.empty => const EmptyView(
                  title: 'No bookings yet',
                  subtitle: 'Browse venues and book a slot.',
                  icon: Icons.event_available,
                ),
              ViewState.success => ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.bookings.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final b = state.bookings[index];
                    final cancelling = state.cancellingId == b.id;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.venueName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(DateFormat('EEE, d MMM yyyy').format(b.slotStart)),
                            Text(
                              '${DateFormat('h:mm a').format(b.slotStart)} – '
                              '${DateFormat('h:mm a').format(b.slotEnd)}',
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: cancelling ? null : () => _cancel(context, b.id),
                                icon: cancelling
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.cancel_outlined),
                                label: Text(cancelling ? 'Cancelling...' : 'Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            },
          );
        },
      ),
    );
  }
}
