package com.teambuktu.models;

public class ExtendedMeasurement extends Measurement {

	public ExtendedMeasurement(Measurement measurement) {
		this.setId(measurement.getId());
		this.setDeviceIdentifier(measurement.getDeviceIdentifier());
		this.setEnvironmentHumidity(measurement.getEnvironmentHumidity());
		this.setSoilHumidity(measurement.getSoilHumidity());
		this.setTemperature(measurement.getTemperature());
		this.setTimestamp(measurement.getTimestamp());
	}
}
