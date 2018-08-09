package com.teambuktu.models;

public class ExtendedMeasurement extends Measurement {

	public ExtendedMeasurement(Measurement measurement) {
		this.setId(measurement.getId());
		this.setDeviceIdentifier(measurement.getDeviceIdentifier());
		this.setEnvironementMoisture(measurement.getEnvironementMoisture());
		this.setSoilMoisture(measurement.getSoilMoisture());
		this.setTemperature(measurement.getTemperature());
		this.setTimestamp(measurement.getTimestamp());
	}
}
