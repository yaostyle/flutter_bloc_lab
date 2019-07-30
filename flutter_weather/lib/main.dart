import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/repositories.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather/widgets/widgets.dart';
import 'package:flutter_weather/blocs/blocs.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(httpClient: http.Client()),
  );

  runApp(App(weatherRepository: weatherRepository));
}

class App extends StatelessWidget {
  final WeatherRepository weatherRepository;

  const App({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Weather',
        home: BlocProvider(
          builder: (context) =>
              WeatherBloc(weatherRepository: weatherRepository),
          child: Weather(),
        ));
  }
}
