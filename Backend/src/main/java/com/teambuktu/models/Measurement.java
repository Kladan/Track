package com.teambuktu.models;

import java.util.Date;

import org.springframework.data.annotation.Id;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

public class Measurement {

	@Id
	private String id;

	private String deviceIdentifier;

	private long soilMoisture;

	private long environementMoisture;

	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date timestamp;

	private float temperature;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public long getSoilMoisture() {
		return soilMoisture;
	}

	public void setSoilMoisture(long soilMoisture) {
		this.soilMoisture = soilMoisture;
	}

	public long getEnvironementMoisture() {
		return environementMoisture;
	}

	public void setEnvironementMoisture(long environementMoisture) {
		this.environementMoisture = environementMoisture;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public float getTemperature() {
		return temperature;
	}

	public void setTemperature(float temperature) {
		this.temperature = temperature;
	}

	public String getDeviceIdentifier() {
		return this.deviceIdentifier;
	}

	public void setDeviceIdentifier(String deviceIdentifier) {
		this.deviceIdentifier = deviceIdentifier;
	}

}
