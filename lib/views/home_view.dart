import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olympics/models.dart';
import 'package:olympics/views.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<MedalStandingsAnswer?> answer;
  late RefreshController refreshController;
  late AnimationController loadController;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    answer = ValueNotifier(null);
    refreshController = RefreshController(initialRefresh: false);
    final loadDuration = Duration(seconds: 1);
    loadController = AnimationController(vsync: this, duration: loadDuration);
    final updateDuration = Duration(seconds: 5);
    timer = Timer.periodic(updateDuration, (timer) => updateStandings());
    updateStandings();
  }

  @override
  Widget build(BuildContext context) => buildHomeView(context);

  @override
  void dispose() {
    answer.dispose();
    refreshController.dispose();
    loadController.dispose();
    timer.cancel();
    super.dispose();
  }

  Future<void> loadStandings() async {
    final url = Uri.parse('https://app.sports.qq.com/tokyoOly/medalsList');
    final response = await http.get(url);
    answer.value = MedalStandingsAnswer.fromJSON(response.body);
  }

  Future<void> updateStandings() async {
    try {
      final url = Uri.parse('https://app.sports.qq.com/tokyoOly/medalsList');
      final response = await http.get(url);
      answer.value = MedalStandingsAnswer.fromJSON(response.body);
    } catch (e) {
      answer.value = null;
    }
  }
}

extension on _HomeViewState {
  Widget buildHomeView(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: answer,
        builder: (context, MedalStandingsAnswer? answerValue, child) {
          if (answerValue == null || answerValue.code != 0) {
            return Center(
              child: LoadingView(),
            );
          } else {
            return buildStandingsView(context, answerValue.content.standings);
          }
        },
      ),
    );
  }

  Widget buildLoadingView(BuildContext context) {
    return AnimatedBuilder(
      animation: loadController,
      builder: (context, child) {
        final radians = loadController.value * 2 * pi;
        return Transform(
          transform: Matrix4.rotationY(radians),
          alignment: AlignmentDirectional.center,
          child: Image.asset('images/tokyo2020.png'),
        );
      },
    );
  }

  Widget buildStandingsView(BuildContext context, MedalStandings standings) {
    final headerHeight = 100.0;
    return SmartRefresher(
      controller: refreshController,
      onRefresh: () async {
        try {
          await loadStandings();
          refreshController.refreshCompleted();
        } catch (e) {
          refreshController.refreshFailed();
        }
      },
      header: CustomHeader(
        height: headerHeight,
        onOffsetChange: (offset) {
          if (refreshController.headerStatus == RefreshStatus.idle ||
              refreshController.headerStatus == RefreshStatus.canRefresh) {
            loadController.value = offset / headerHeight;
          }
        },
        completeDuration: Duration(seconds: 1),
        onModeChange: (state) {
          print(state);
          switch (state) {
            case RefreshStatus.refreshing:
              loadController.repeat();
              break;
            case RefreshStatus.idle:
              loadController.stop();
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Container(
            width: headerHeight,
            height: headerHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.all(20.0),
            child: buildLoadingView(context),
          );
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverListHeader(
              color: Theme.of(context).cardColor,
              child: buildStandingsHeaderView(context),
            ),
            pinned: true,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                if (i.isEven) {
                  final team = standings.total[i ~/ 2];
                  return buildStandingsTeamView(context, team);
                } else {
                  return Divider(height: 0.5, thickness: 0.5);
                }
              },
              childCount: standings.total.length * 2 - 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStandingsHeaderView(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      key: Key('header'),
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '名次',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            '国家/地区',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '金牌',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '银牌',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '铜牌',
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '总数',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget buildStandingsTeamView(BuildContext context, Team team) {
    return FlipView(
      key: Key(team.id),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0.0,
        horizontalTitleGap: 0.0,
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                team.rankOfGold,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(
                      team.logoUrl,
                      width: 32,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      team.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                team.totalOfGold,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                team.totalOfSilver,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                team.totalOfBronze,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                team.total,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlipView extends StatefulWidget {
  final Widget? child;

  const FlipView({Key? key, this.child}) : super(key: key);

  @override
  _FlipViewState createState() => _FlipViewState();
}

class _FlipViewState extends State<FlipView>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    final duration = Duration(seconds: 1);
    animation = AnimationController(
      vsync: this,
      duration: duration,
      lowerBound: -1.0,
      upperBound: 0.0,
    );
    animation.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final radians = animation.value * pi * 0.5;
        return Transform(
          transform: Matrix4.rotationX(radians),
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
}

class SliverListHeader extends SliverPersistentHeaderDelegate {
  final double height;
  final Color? color;
  final Widget? child;

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;

  SliverListHeader({
    this.height = 60.0,
    this.color,
    this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.center,
      color: color,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverListHeader old) {
    return minExtent != old.minExtent ||
        maxExtent != old.maxExtent ||
        child != old.child;
  }
}
