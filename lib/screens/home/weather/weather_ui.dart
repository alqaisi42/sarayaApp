



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/config/constants.dart';


import '../../../bloc/weatherBloc/weather_bloc.dart';

import '../../../bloc/weatherBloc/weather_event.dart';
import '../../../bloc/weatherBloc/weather_state.dart';
import '../../../config/colors.dart';
import '../../../config/helper/helper_functions.dart';
import '../../../config/shimmer.dart';

import '../../../l10n/app_localizations.dart';

class WeatherUI extends StatefulWidget {
  final double lat;
  final double lon;
  const WeatherUI({super.key,required this.lat,required this.lon});

  @override
  State<WeatherUI> createState() => _WeatherUIState();
}

class _WeatherUIState extends State<WeatherUI> {
  bool _isExpanded = false;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _curve = Curves.easeInOut;

  double kelvinToCelsius(dynamic kelvin) {
    if (kelvin == null) return 0.0;
    return (kelvin is int ? kelvin.toDouble() : kelvin) - 273.15;
  }

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchWeatherData(lat: widget.lat, lon: widget.lon));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return ShimmerWidget(
            width: MediaQueryHelper.screenWidth(context),
            height: MediaQueryHelper.screenHeight(context) * 0.12,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQueryHelper.screenWidth(context) * 0.04,
              vertical: MediaQueryHelper.screenHeight(context) * 0.03,
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQueryHelper.screenHeight(context) * 0.001,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: AnimatedContainer(
              duration: _animationDuration,
              curve: _curve,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _buildWeatherContent(state),
            ),
          ),

        );
      },
    );
  }

  Widget _buildWeatherContent(WeatherState state) {
    if (state is WeatherErrorState) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors().primaryColor, fontFamily: fontType),
            ),
          ],
        ),
      );
    } else if (state is WeatherSuccessState) {
      final weather = state.weatherData;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final arrowColor = isDark ? Colors.grey.shade300 : Colors.black;

      return AnimatedSize(
        duration: _animationDuration,
        curve: _curve,
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: always visible
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Location + Country
                  Row(
                    children: [
                      Text(
                        weather.name ?? '',
                        style: TextStyle(fontSize: 13, fontFamily: fontType),
                      ),
                      const SizedBox(width: 6),
                      if (weather.sys?.country != null)
                        Text(
                          weather.sys!.country!,
                          style: TextStyle(fontSize: 11, fontFamily: fontType),
                        ),
                    ],
                  ),

                  /// Temp + Icon + Arrow
                  Row(
                    children: [
                      WeatherIconWidget(icon: weather.weather?[0].icon),
                      const SizedBox(width: 8),
                      Text(
                        '${kelvinToCelsius(weather.main?.temp).round()}°C',
                        style: TextStyle(fontSize: 13, fontFamily: fontType),
                      ),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 23,
                        color: arrowColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Expanded details
            if (_isExpanded) ...[
              SizedBox(height: MediaQueryHelper.screenHeight(context) * 0.01),
              if (weather.weather?.isNotEmpty ?? false)
                Text(
                  weather.weather![0].description?.toUpperCase() ?? '',
                  style: TextStyle(fontSize: 10, fontFamily: fontType),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWeatherDetail(
                    context,
                    AppLocalizations.of(context)!.humidity,
                    '${_toDouble(weather.main?.humidity).round()}%',
                    Icons.water_drop,
                  ),
                  _buildWeatherDetail(
                    context,
                    AppLocalizations.of(context)!.wind,
                    '${_toDouble(weather.wind?.speed).toStringAsFixed(1)} m/s',
                    Icons.air,
                  ),
                  _buildWeatherDetail(
                    context,
                    AppLocalizations.of(context)!.pressure,
                    '${_toDouble(weather.main?.pressure).round()} hPa',
                    Icons.speed,
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return 0.0;
  }

  Widget _buildWeatherDetail(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors().primaryColor),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontFamily: fontType)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontFamily: fontType)),
      ],
    );
  }
}






class WeatherIconWidget extends StatelessWidget {
  final String? icon;

  const WeatherIconWidget({super.key, this.icon});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        height: 35,
        child: Image.asset("assets/img/weatherImg/$icon.png",fit:BoxFit.contain ,));


  }
}




