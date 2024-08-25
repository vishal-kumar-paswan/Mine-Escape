import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_bloc.dart';
import 'package:mines/blocs/scale_tile_bloc/scale_tile_event.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_bloc.dart';
import 'package:mines/blocs/view_tile_bloc/view_tile_event.dart';
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
  List<int> tiles = List<int>.filled(25, 0);
  double totalMines = 1;
  bool isGameStarted = false;
  bool isTileClickable = false;

  final Map<int, ViewTileBloc> _tileBlocMap = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 25; i++) {
      _tileBlocMap[i] = ViewTileBloc();
    }
  }

  void generateMineIndexes() {
    int count = totalMines.ceil();
    final random = Random();
    while (count != 0) {
      int index = random.nextInt(25);
      if (tiles[index] != -1) {
        tiles[index] = -1;
        --count;
      }
    }

    print("tiles:: $tiles");
    isTileClickable = true;

    setState(() {
      isGameStarted = true;
    });
  }

  void resetGame(BuildContext context) {
    tiles = List<int>.filled(25, 0);
    totalMines = 1;
    isTileClickable = false;
    setState(() {
      isGameStarted = false;
    });

    // Reset all tile BLoCs to grey
    for (int i = 0; i < 25; i++) {
      _tileBlocMap[i]?.add(ResetTile());
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
              '${totalMines.ceil()}',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(1),
            Transform.scale(
              scale: 1.3,
              child: AbsorbPointer(
                absorbing: isGameStarted,
                child: Slider(
                  thumbColor: !isGameStarted
                      ? const Color(0xff1FFF20)
                      : Colors.red.shade600,
                  min: 1,
                  max: 24,
                  value: totalMines.ceilToDouble(),
                  onChanged: (minesCount) {
                    setState(() {
                      totalMines = minesCount.ceilToDouble();
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
                backgroundColor: isGameStarted
                    ? Colors.red.shade600
                    : const Color(0xff1FFF20),
              ),
              onPressed: () {
                if (!isGameStarted) {
                  generateMineIndexes();
                } else {
                  resetGame(context);
                }
              },
              child: Text(
                !isGameStarted ? 'START' : 'RESET',
                style: TextStyle(
                  fontSize: 15,
                  color: !isGameStarted ? Colors.black : Colors.white,
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
                BlocProvider<ScaleTileBloc>(
                  create: (context) => ScaleTileBloc(),
                ),
                BlocProvider<ViewTileBloc>.value(
                  value: _tileBlocMap[index]!,
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
                      if (!isGameStarted) {
                        DisplayMessage.toast(
                          "Please start the game first!",
                        );
                      } else if (isTileClickable) {
                        if (tiles[index] == 0) {
                          tiles[index] = 1;
                          BlocProvider.of<ViewTileBloc>(context).add(
                            ClickTile(
                              Colors.green,
                              'assets/icons/diamond.png',
                            ),
                          );

                          int totalDiamonds =
                              tiles.where((tile) => tile == 1).length;

                          if (totalDiamonds == (25 - totalMines)) {
                            isTileClickable = false;
                            Future.delayed(
                              const Duration(seconds: 1),
                              () {
                                DisplayMessage.dialogBox(
                                  context,
                                  'assets/animations/diamond.json',
                                  'You won!',
                                  () => resetGame(context),
                                );
                              },
                            );
                          }
                        } else if (tiles[index] == -1) {
                          isTileClickable = false;
                          BlocProvider.of<ViewTileBloc>(context).add(
                            ClickTile(
                              Colors.red,
                              'assets/icons/mine.png',
                            ),
                          );

                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              DisplayMessage.dialogBox(
                                context,
                                'assets/animations/mine.json',
                                'You lost!',
                                () => resetGame(context),
                              );
                            },
                          );
                        }
                      }
                    },
                    child: AnimatedScale(
                      scale: scaleTileBlocState.scale,
                      duration: const Duration(milliseconds: 45),
                      child: Tile(
                        color: viewTileBlocState.color,
                        icon: viewTileBlocState.icon,
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