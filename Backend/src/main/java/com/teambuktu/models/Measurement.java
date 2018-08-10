package com.teambuktu.models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.format.annotation.DateTimeFormat.ISO;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Measurement {

	@Id
	private String id;

	private String deviceIdentifier;

	@Transient
	private Device device;

	private long soilHumidity;

	private long environmentHumidity;

	@DateTimeFormat(iso = ISO.DATE_TIME)
	private Date timestamp;

	private int temperature;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public long getSoilHumidity() {
		return soilHumidity;
	}

	public void setSoilHumidity(long soilHumidity) {
		this.soilHumidity = soilHumidity;
	}

	public long getEnvironmentHumidity() {
		return environmentHumidity;
	}

	public void setEnvironmentHumidity(long environmentHumidity) {
		this.environmentHumidity = environmentHumidity;
	}

	public Date getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}

	public int getTemperature() {
		return temperature;
	}

	public void setTemperature(int temperature) {
		this.temperature = temperature;
	}

	public String getDeviceIdentifier() {
		return this.deviceIdentifier;
	}

	public Device getDevice() {
		if (this.device == null) {

		}

		return this.device;
	}

	public void setDevice(Device device) {
		this.device = device;
	}

	public void setDeviceIdentifier(String deviceIdentifier) {
		this.deviceIdentifier = deviceIdentifier;
	}

}
