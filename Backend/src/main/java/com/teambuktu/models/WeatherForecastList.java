package com.teambuktu.models;

import java.util.ArrayList;
import java.util.List;

public class WeatherForecastList {
    private List<WeatherForecast> weatherforecasts;

    public WeatherForecastList() {
        weatherforecasts = new ArrayList<>();
    }

    public List<WeatherForecast> getWeatherforecasts() {
        return weatherforecasts;
    }

    public void setWeatherforecasts(List<WeatherForecast> weatherforecasts) {
        this.weatherforecasts = weatherforecasts;
    }
}
