package com.teambuktu.rest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

	private final Logger logger = LoggerFactory.getLogger(MeasurementRestController.class);

	@Autowired
	private MeasurementRepository measurementRepository;

	@RequestMapping(value = "measurements/device/{id}", method = RequestMethod.GET)
	public ExtendedMeasurement getMeasuredData(@PathVariable("id") String id) {

		logger.info(id);
		Measurement lastMeasurement = measurementRepository.findFirstByDeviceIdentifierOrderByTimestampDesc(id);

		ExtendedMeasurement measurement = new ExtendedMeasurement(lastMeasurement);
		return measurement;
	}

}
