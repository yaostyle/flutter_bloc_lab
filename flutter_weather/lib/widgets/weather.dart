import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/widgets/widgets.dart';
import 'package:flutter_weather/blocs/blocs.dart';

class Weather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final city = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitySelection(),
                ),
              );
              if (city != null) {
                weatherBloc.dispatch(FetchWeather(city: city));
              }
            },
          )
        ],
      ),
      body: Center(
        child:
            BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
          if (state is WeatherEmpty) {
            return Center(
              child: Text('Please Select a Location'),
            );
          }
          if (state is WeatherLoaded) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is WeatherLoaded) {
            final weather = state.weather;
            return ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Location(location: weather.location),
                  ),
                ),
                Center(
                  child: LastUpdated(dateTime: weather.lastUpdated),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.0),
                  child: Center(
                    child: CombinedWeatherTemperature(weather: weather),
                  ),
                )
              ],
            );
          }
          if (state is WeatherError) {
            return Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            );
          }
          return Center(
            child: Text('Please Select a Location'),
          );
        }),
      ),
    );
  }
}
