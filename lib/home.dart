// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';
import 'dart:math' as mathLib;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MenuState();
}

class _MenuState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  static const _menuTitles = [
    'Company Vision',
    'Mission',
    'Our Team',
    'Clients',
    'Contact Us',
  ];

  final List<Interval> _itemSlideIntervals = [];

  Duration _initialDelay = const Duration(milliseconds: 50);
  Duration _itemSlideDelay = const Duration(milliseconds: 250);
  Duration _staggerDelay = const Duration(milliseconds: 50);
  Duration _buttonDelay = const Duration(milliseconds: 150);
  Duration _buttonUpDelay = const Duration(milliseconds: 250);
  Duration _blankDelay = const Duration(milliseconds: 300);
  late Duration _animationDuration;

  @override
  void initState() {
    super.initState();
    _animationDuration = _initialDelay +
        (_itemSlideDelay * _menuTitles.length) +
        _buttonDelay +
        _buttonUpDelay;
    _createAnimationItervals();

    controller = AnimationController(vsync: this, duration: _animationDuration)
      ..forward();
  }

  void _createAnimationItervals() {
    for (var i = 0; i < _menuTitles.length; i++) {
      final startTime = _initialDelay + (_staggerDelay *i);
      final endTime = startTime + _itemSlideDelay;
      _itemSlideIntervals.add(Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    // TODO: We'll implement this later.
    return const SizedBox(height: 250, width: 250, child: FlutterLogo());
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildStartBuilding(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(controller.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;
            return Opacity(
                opacity: opacity,
                child: Transform.translate(
                    offset: Offset(slideDistance, 0), child: child));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildStartBuilding() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          ),
          onPressed: () {},
          child: const Text(
            'Let\'s Start Building',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
