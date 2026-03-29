import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/remote_config_repo.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

/// Drives the portfolio loading lifecycle.
///
/// On [LoadPortfolio]:
///   1. Emits [PortfolioLoading]
///   2. Calls [RemoteConfigRepository.load] — handles remote fetch, caching,
///      version comparison, and OG image enrichment
///   3. Emits [PortfolioLoaded] on success or [PortfolioError] on failure
///
/// Usage:
/// ```dart
/// context.read<PortfolioBloc>().add(const LoadPortfolio());
/// ```
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc(this._repo) : super(const PortfolioLoading()) {
    on<LoadPortfolio>(_onLoad);
  }

  final RemoteConfigRepository _repo;

  Future<void> _onLoad(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(const PortfolioLoading());
    try {
      final content = await _repo.load();
      emit(PortfolioLoaded(content));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }
}
