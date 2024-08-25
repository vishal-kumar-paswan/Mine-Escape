import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_event.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_state.dart';

class ScaleTileBloc extends Bloc<ScaleTileEvent, ScaleTileState> {
  ScaleTileBloc() : super(ScaleTileState(1)) {
    on<ScaleTile>((event, emit) => emit(ScaleTileState(event.scale)));
  }
}
