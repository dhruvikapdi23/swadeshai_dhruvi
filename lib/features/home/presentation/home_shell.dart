import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/bloc/my_bookings_cubit.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/my_bookings_screen.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/bloc/venues_cubit.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/venues_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  VenuesCubit? _venuesCubit;
  MyBookingsCubit? _bookingsCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_venuesCubit != null) return;

    final userId = context.read<AuthCubit>().state.currentUser!.id;
    _venuesCubit = VenuesCubit(Injection.getVenuesUseCase)..loadVenues();
    _bookingsCubit = MyBookingsCubit(
      getUserBookingsUseCase: Injection.getUserBookingsUseCase,
      cancelBookingUseCase: Injection.cancelBookingUseCase,
      userId: userId,
    )..loadBookings();
  }

  @override
  void dispose() {
    _venuesCubit?.close();
    _bookingsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venuesCubit = _venuesCubit;
    final bookingsCubit = _bookingsCubit;
    if (venuesCubit == null || bookingsCubit == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: venuesCubit),
        BlocProvider.value(value: bookingsCubit),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            VenuesScreen(onLogout: () => context.read<AuthCubit>().logout()),
            const MyBookingsScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.sports), label: 'Venues'),
            NavigationDestination(icon: Icon(Icons.bookmark), label: 'My Bookings'),
          ],
        ),
      ),
    );
  }
}
