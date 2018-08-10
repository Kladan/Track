package com.teambuktu.models;

public class ExtendedMeasurement extends Measurement {

	private int timeToCritical;

	public ExtendedMeasurement(Measurement measurement) {
		this.setId(measurement.getId());
		this.setDeviceIdentifier(measurement.getDeviceIdentifier());
		this.setEnvironmentHumidity(measurement.getEnvironmentHumidity());
		this.setSoilHumidity(measurement.getSoilHumidity());
		this.setTemperature(measurement.getTemperature());
		this.setTimestamp(measurement.getTimestamp());
		this.setDevice(measurement.getDevice());
	}

	public int getTimeToCritical() {
		return timeToCritical;
	}

	public void setTimeToCritical(int timeToCritical) {
		this.timeToCritical = timeToCritical;
	}
}
