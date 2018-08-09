package com.teambuktu.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.MeasurementRepository;

@RestController
public class MeasurementRestController {

	@Autowired
	private MeasurementRepository measurementRepository;

	@RequestMapping(value = "measurements/extended/device/{id}", method = RequestMethod.GET)
	public ExtendedMeasurement getExtendedMeasurement(@PathVariable("id") String id) {

		Measurement lastMeasurement = measurementRepository.findFirstByDeviceIdentifierOrderByTimestampDesc(id);

		ExtendedMeasurement measurement = new ExtendedMeasurement(lastMeasurement);
		return measurement;
	}

	@RequestMapping(value = "measurements/device/{id}", method = RequestMethod.GET)
	public List<Measurement> getAllMeasurementsByDeviceId(@PathVariable("id") String id) {

		List<Measurement> measurements = measurementRepository.findByDeviceIdentifier(id);

		return measurements;
	}

}
