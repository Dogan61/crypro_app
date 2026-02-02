import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_mobil/core/constants/router_const.dart';
import 'package:crypto_mobil/core/di/injection.dart';
import 'package:crypto_mobil/core/mixins/debounce_mixin.dart';
import 'package:crypto_mobil/core/mixins/error_handler_mixin.dart';
import 'package:crypto_mobil/core/navbar/custom_bottom_bar.dart';
import 'package:crypto_mobil/core/utils/coin_image_helper.dart';
import 'package:crypto_mobil/feature/search/bloc/search_bloc.dart';
import 'package:crypto_mobil/feature/search/widgets/custom_search_bar.dart';
import 'package:crypto_mobil/feature/search/widgets/search_view_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchAssetsView extends StatefulWidget {
  const SearchAssetsView({super.key});

  @override
  State<SearchAssetsView> createState() => _SearchAssetsViewState();
}

class _SearchAssetsViewState extends State<SearchAssetsView>
    with DebounceMixin, ErrorHandlerMixin {
  late final SearchBloc _searchBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = getIt<SearchBloc>();
  }

  void _onSearchChanged(String query) {
    debounce(() {
      _searchBloc.add(SearchSymbols(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _searchBloc,
      child: Scaffold(
        appBar: const SearchViewCustomAppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomSearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onClear: () {
                  _searchController.clear();
                  _searchBloc.add(const ClearSearch());
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<SearchBloc, SearchState>(
                listener: (context, state) {
                  if (state.status == SearchStatus.failure) {
                    showErrorSnackBar(
                      context,
                      state.errorMessage ?? 'Search failed',
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == SearchStatus.initial) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Start typing to search coins',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.status == SearchStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.symbols.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }

                  return ListView.builder(
                    itemCount: state.symbols.length,
                    itemBuilder: (context, index) {
                      final symbol = state.symbols[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: CachedNetworkImage(
                            imageUrl: CoinImageHelper.getCoinIconUrl(
                              symbol.symbol,
                            ),
                            width: 30,
                            height: 30,
                            errorWidget: (context, url, error) => Text(
                              CoinImageHelper.getCoinSymbolText(symbol.symbol),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        title: Text(symbol.baseAsset),
                        subtitle: Text(symbol.symbol),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          context.push(RouterConst.coinDetailPath(symbol.symbol));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchBloc.close();
    super.dispose();
  }
}
