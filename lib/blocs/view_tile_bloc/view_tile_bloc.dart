import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_event.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_state.dart';

class ViewTileBloc extends Bloc<ViewTileEvent, ViewTileState> {
  ViewTileBloc() : super(ViewTileState(null, null)) {
    on<ClickTile>(
      (event, emit) => emit(ViewTileState(event.color, event.icon)),
    );
    on<ResetTile>(
      (event, emit) => emit(ViewTileState(null, null)),
    );
  }
}
