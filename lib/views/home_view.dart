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
      itemCount: standings.total.length,
      itemBuilder: (context, i) {
        final team = standings.total[i];
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  team.logoUrl,
                  width: 32,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  team.name,
                  overflow: TextOverflow.ellipsis,
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
            ],
          ),
        );
      },
    );
  }
}
