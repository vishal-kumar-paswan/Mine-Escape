import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_bloc.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_event.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_bloc.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_event.dart';
import 'package:mines/constants.dart';
import 'package:mines/utils/display_message.dart';
import 'package:mines/widgets/tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = Tile unopened
  // 1 = Diamond
  // -1 = Mine
  List<int> _tiles = List<int>.filled(25, 0);
  final Map<int, ViewTileBloc> _viewTileBlocMap = {};
  final Map<int, ScaleTileBloc> _scaleTileBlocMap = {};
  double _totalMines = 1;
  late int _clickedMineIndex;
  bool _isGameStarted = false;
  bool _isTileClickable = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 25; i++) {
      _viewTileBlocMap[i] = ViewTileBloc();
      _scaleTileBlocMap[i] = ScaleTileBloc();
    }
  }

  void generateMineIndexes() {
    int count = _totalMines.ceil();
    final random = Random();
    while (count != 0) {
      int index = random.nextInt(25);
      if (_tiles[index] != -1) {
        _tiles[index] = -1;
        --count;
      }
    }

    print(_tiles);

    _isTileClickable = true;

    setState(() {
      _isGameStarted = true;
    });
  }

  void revealAllTiles(BuildContext context) {
    int tileCount = 0;

    Timer.periodic(const Duration(milliseconds: 165), (timer) {
      if (tileCount < 25) {
        _scaleTileBlocMap[tileCount]?.add(ScaleTile(1.1));
        if (_tiles[tileCount] == -1) {
          _viewTileBlocMap[tileCount]?.add(
            ClickTile(
              color: tileCount == _clickedMineIndex
                  ? Colors.red.shade900
                  : const Color.fromARGB(255, 123, 34, 34),
              icon: Constants.mineIcon,
              blurIcon: true,
            ),
          );
        } else {
          _viewTileBlocMap[tileCount]?.add(
            ClickTile(
              color: const Color.fromARGB(255, 33, 75, 34),
              icon: Constants.diamondIcon,
              blurIcon: true,
            ),
          );
        }

        Future.delayed(
          const Duration(milliseconds: 75),
          () {
            _scaleTileBlocMap[tileCount++]?.add(ScaleTile(1));
          },
        );
      } else {
        timer.cancel();
        Future.delayed(
          const Duration(
            seconds: 1,
            milliseconds: 250,
          ),
          () {
            DisplayMessage.dialogBox(
              context,
              Constants.mineAnimation,
              'You lost!',
              () => resetGame(context),
            );
          },
        );
      }
    });
  }

  void resetGame(BuildContext context) {
    _tiles = List<int>.filled(25, 0);
    _totalMines = 1;
    _isTileClickable = false;
    setState(() {
      _isGameStarted = false;
    });

    // Reset all tile BLoCs to grey
    for (int i = 0; i < 25; i++) {
      _viewTileBlocMap[i]?.add(ResetTile());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget controls() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff213743),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 28,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total mines',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w800),
            ),
            const Gap(4),
            Text(
              '${_totalMines.ceil()}',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(1),
            Transform.scale(
              scale: 1.3,
              child: AbsorbPointer(
                absorbing: _isGameStarted,
                child: Slider(
                  thumbColor: !_isGameStarted
                      ? const Color(0xff1FFF20)
                      : Colors.red.shade600,
                  min: 1,
                  max: 24,
                  value: _totalMines.ceilToDouble(),
                  onChanged: (minesCount) {
                    setState(() {
                      _totalMines = minesCount.ceilToDouble();
                    });
                  },
                ),
              ),
            ),
            const Gap(1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(150, 50),
                backgroundColor: _isGameStarted
                    ? Colors.red.shade600
                    : const Color(0xff1FFF20),
              ),
              onPressed: () {
                if (!_isGameStarted) {
                  generateMineIndexes();
                } else {
                  resetGame(context);
                }
              },
              child: Text(
                !_isGameStarted ? 'START' : 'RESET',
                style: TextStyle(
                  fontSize: 15,
                  color: !_isGameStarted ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget board() {
      return SizedBox(
        height: 630,
        width: 630,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: 25,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1 / 1,
            mainAxisSpacing: 11.5,
            crossAxisSpacing: 11.5,
          ),
          itemBuilder: (context, index) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<ScaleTileBloc>.value(
                  value: _scaleTileBlocMap[index]!,
                ),
                BlocProvider<ViewTileBloc>.value(
                  value: _viewTileBlocMap[index]!,
                ),
              ],
              child: Builder(
                builder: (context) {
                  final scaleTileBlocState =
                      context.watch<ScaleTileBloc>().state;
                  final viewTileBlocState = context.watch<ViewTileBloc>().state;

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onHover: (isHovered) {
                      BlocProvider.of<ScaleTileBloc>(context).add(
                        ScaleTile(isHovered ? 1.05 : 1),
                      );
                    },
                    onTap: () {
                      if (!_isGameStarted) {
                        DisplayMessage.toast(
                          "Please start the game first!",
                        );
                      } else if (_isTileClickable) {
                        if (_tiles[index] == 0) {
                          _tiles[index] = 1;
                          BlocProvider.of<ViewTileBloc>(context).add(
                            ClickTile(
                              color: Colors.green,
                              icon: Constants.diamondIcon,
                            ),
                          );

                          int totalDiamonds =
                              _tiles.where((tile) => tile == 1).length;

                          if (totalDiamonds == (25 - _totalMines)) {
                            _isTileClickable = false;
                            Future.delayed(
                              const Duration(
                                seconds: 1,
                                milliseconds: 250,
                              ),
                              () {
                                DisplayMessage.dialogBox(
                                  context,
                                  Constants.diamondAnimation,
                                  'You won!',
                                  () => resetGame(context),
                                );
                              },
                            );
                          }
                        } else if (_tiles[index] == -1) {
                          _isTileClickable = false;
                          _clickedMineIndex = index;

                          BlocProvider.of<ViewTileBloc>(context).add(
                            ClickTile(
                                color: Colors.red, icon: Constants.mineIcon),
                          );
                          revealAllTiles(context);
                        }
                      }
                    },
                    child: AnimatedScale(
                      scale: scaleTileBlocState.scale,
                      duration: const Duration(milliseconds: 300),
                      child: Tile(
                        color: viewTileBlocState.color,
                        icon: viewTileBlocState.icon,
                        blurIcon: viewTileBlocState.blurIcon,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      controls(),
                      const Gap(35),
                      board(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Transform.scale(scale: 1.35, child: controls()),
                      const Gap(80),
                      Transform.scale(scale: 1, child: board()),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
