import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../abstract/tile.dart';
import '../../repository/repository.dart';
import '../cubit/game_cubit_cubit.dart';

class CustomCellAnimatedPositioned extends StatefulWidget {
  CustomCellAnimatedPositioned(
      {Key? key,
      required this.x,
      required this.y,
      required this.id,
      required this.controller,
      required this.tile})
      : super(key: key);
  double x;
  double y;
  int id;
  AnimationController controller;
  Tile tile;

  @override
  State<CustomCellAnimatedPositioned> createState() =>
      _CustomCellAnimatedPositionedState();
}

class _CustomCellAnimatedPositionedState extends State<CustomCellAnimatedPositioned>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = widget.controller;

  @override
  void initState() {
    _controller.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return AnimatedPositioned(
          onEnd: () {
            //  context.read<GameCubit>().checkGameIsDone();
          },
          curve: Curves.bounceOut,
          top: widget.y,
          left: widget.x,
          duration: const Duration(milliseconds: 750),
          child: Container(
            decoration: BoxDecoration(
              //color:Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            width: MediaQuery.of(context).size.width /
                GameRepository.instance.boardColumnCount,
            height: MediaQuery.of(context).size.width /
                GameRepository.instance.boardColumnCount,
            child: Center(
                child: Opacity(
              opacity:
                  widget.tile.getPath.toLowerCase().contains("free") ? 0.0 : 1,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width /
                      GameRepository.instance.boardColumnCount,
                  height: MediaQuery.of(context).size.width /
                      GameRepository.instance.boardColumnCount,
                  //GameRepository.instance.tileList[widget.id]//bu şekilde verince VERİTİCALLAR HORİZONTAL FİLAN GELDİ BEYNİM YANDI
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/tiles/${widget.tile.getPath}",
                      scale: size.width > 600 ? 0.1 : 1,
                      width: MediaQuery.of(context).size.width /
                          GameRepository.instance.boardColumnCount,
                      height: MediaQuery.of(context).size.width /
                          GameRepository.instance.boardColumnCount,
                    ),
                  )),
            )),
          ),
        );
      },
    );
  }
}
