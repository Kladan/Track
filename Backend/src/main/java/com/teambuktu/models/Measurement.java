package com.teambuktu.models;

import org.bson.BsonTimestamp;
import org.springframework.data.annotation.Id;

public class Measurement {

	@Id
	private String id;

	private double latitude;

	private double longitude;

	private long SoilMoisture;

	private long EnvironementMoisture;

	private BsonTimestamp timestamp;

	private float temperature;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public long getSoilMoisture() {
		return SoilMoisture;
	}

	public void setSoilMoisture(long soilMoisture) {
		SoilMoisture = soilMoisture;
	}

	public long getEnvironementMoisture() {
		return EnvironementMoisture;
	}

	public void setEnvironementMoisture(long environementMoisture) {
		EnvironementMoisture = environementMoisture;
	}

	public BsonTimestamp getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(BsonTimestamp timestamp) {
		this.timestamp = timestamp;
	}

	public float getTemperature() {
		return temperature;
	}

	public void setTemperature(float temperature) {
		this.temperature = temperature;
	}

}
