import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/hotel_list/hotel_list_bloc.dart';
import '../bloc/hotel_list/hotel_list_event.dart';
import '../bloc/hotel_list/hotel_list_state.dart';
import '../widgets/hotel_card.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<HotelListBloc>().add(LoadHotels());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HotelListBloc>().add(LoadMoreHotels());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/hotel-search'),
          ),
        ],
      ),
      body: BlocBuilder<HotelListBloc, HotelListState>(
        builder: (context, state) {
          if (state is HotelListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HotelListFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<HotelListBloc>().add(LoadHotels()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is HotelListLoaded ||
              state is HotelListLoadingMore) {
            final hotels = state is HotelListLoaded
                ? state.hotels
                : (state as HotelListLoadingMore).hotels;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HotelListBloc>().add(RefreshHotels());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: hotels.length + (state is HotelListLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= hotels.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final hotel = hotels[index];
                  return HotelCard(
                    hotel: hotel,
                    onTap: () => context.push('/hotel-details/${hotel.id}'),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
