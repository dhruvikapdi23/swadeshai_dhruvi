import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/core/widgets/state_views.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/venue_detail_screen.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/bloc/venues_cubit.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/bloc/venues_state.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/widgets/venue_card.dart';

class VenuesScreen extends StatelessWidget {
  const VenuesScreen({super.key, this.onLogout, this.onBookingChanged});

  final VoidCallback? onLogout;
  final VoidCallback? onBookingChanged;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.currentUser;
    final cubit = context.read<VenuesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Venues'),
            if (user != null)
              Text('Hi, ${user.name.split(' ').first}',
                  style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          if (onLogout != null)
            IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
        ],
      ),
      body: BlocBuilder<VenuesCubit, VenuesState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: cubit.loadVenues,
            child: switch (state.status) {
              ViewState.loading || ViewState.idle =>
                const LoadingView(message: 'Loading venues...'),
              ViewState.error => ErrorView(
                  message: state.errorMessage ?? 'Error',
                  onRetry: cubit.loadVenues,
                ),
              ViewState.empty => const EmptyView(
                  title: 'No venues available',
                  icon: Icons.sports_tennis,
                ),
              ViewState.success => ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.venues.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final venue = state.venues[index];
                    return VenueCard(
                      venue: venue,
                      onTap: () {
                        if (user == null) return;
                        Navigator.of(context)
                            .push<bool>(
                          MaterialPageRoute<bool>(
                            builder: (_) => VenueDetailScreen(
                              venueId: venue.id,
                              userId: user.id,
                            ),
                          ),
                        )
                            .then((booked) {
                          if (booked == true) onBookingChanged?.call();
                        });
                      },
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
