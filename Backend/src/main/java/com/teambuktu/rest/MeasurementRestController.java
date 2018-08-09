package com.teambuktu.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.teambuktu.business.MeasurementLogic;
import com.teambuktu.models.Device;
import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.DeviceRepository;
import com.teambuktu.repositories.MeasurementRepository;

@RestController
public class MeasurementRestController {

	@Autowired
	private MeasurementRepository measurementRepository;

	@Autowired
	private DeviceRepository deviceRepository;

	@Autowired
	private MeasurementLogic measurementLogic;

	/**
	 * Returns an json object with the last measurement data and device data
	 * 
	 * @param id: Device Identifier
	 * @return
	 */
	@RequestMapping(value = "measurements/extended/device/{id}", method = RequestMethod.GET)
	public ExtendedMeasurement getExtendedMeasurement(@PathVariable("id") String id) {

		Device device = deviceRepository.findByDeviceIdentifier(id);
		Measurement lastMeasurement = measurementRepository.findFirstByDeviceIdentifierOrderByTimestampDesc(id);
		lastMeasurement.setDevice(device);

		return measurementLogic.getExtendedMeasurement(lastMeasurement);
	}

	/**
	 * Returns all measured data for an device.
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "measurements/device/{id}", method = RequestMethod.GET)
	public List<Measurement> getAllMeasurementsByDeviceId(@PathVariable("id") String id) {

		Device device = deviceRepository.findByDeviceIdentifier(id);

		List<Measurement> measurements = measurementRepository.findByDeviceIdentifierOrderByTimestampDesc(id);
		for (Measurement measurement : measurements) {
			measurement.setDevice(device);
		}

		return measurements;
	}
}
