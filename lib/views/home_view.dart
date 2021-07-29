import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olympics/models.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ValueNotifier<MedalStandingsAnswer?> answer;

  @override
  void initState() {
    super.initState();
    answer = ValueNotifier(null);
    setup();
  }

  @override
  Widget build(BuildContext context) => buildHomeView(context);

  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  void setup() async {
    final url = Uri.parse('https://app.sports.qq.com/tokyoOly/medalsList');
    final response = await http.get(url);
    answer.value = MedalStandingsAnswer.fromJSON(response.body);
  }
}

extension on _HomeViewState {
  Widget buildHomeView(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: answer,
        builder: (context, MedalStandingsAnswer? answerValue, child) {
          if (answerValue == null || answerValue.code != 0) {
            return buildLoadingView(context);
          } else {
            return buildStandingsView(context, answerValue.content.standings);
          }
        },
      ),
    );
  }

  Widget buildLoadingView(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildStandingsView(BuildContext context, MedalStandings standings) {
    return ListView.builder(
      itemCount: standings.total.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return buildStandingsHeaderView(context);
        } else {
          final team = standings.total[i - 1];
          return buildStandingsTeamView(context, team);
        }
      },
    );
  }

  Widget buildStandingsHeaderView(BuildContext context) {
    return ListTile(
      key: Key('header'),
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0.0,
      horizontalTitleGap: 0.0,
      tileColor: Colors.grey[300],
      title: Row(
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
      ),
    );
  }

  Widget buildStandingsTeamView(BuildContext context, Team team) {
    return ListTile(
      key: Key(team.id),
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
    );
  }
}
