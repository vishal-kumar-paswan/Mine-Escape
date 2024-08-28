import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_event.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_state.dart';

class ViewTileBloc extends Bloc<ViewTileEvent, ViewTileState> {
  ViewTileBloc()
      : super(ViewTileState(color: null, icon: null, blurIcon: false)) {
    on<ClickTile>(
      (event, emit) => emit(
        ViewTileState(
          color: event.color,
          icon: event.icon,
          blurIcon: event.blurIcon ?? false,
        ),
      ),
    );
    on<ResetTile>(
      (event, emit) => emit(
        ViewTileState(
          color: null,
          icon: null,
          blurIcon: false,
        ),
      ),
    );
  }
}
