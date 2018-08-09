package com.teambuktu.business;

import org.springframework.stereotype.Component;

import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;

@Component
public class MeasurementLogic {

	public ExtendedMeasurement getExtendedMeasurement(Measurement lastMeasurement) {

		ExtendedMeasurement extendedMeasurement = new ExtendedMeasurement(lastMeasurement);

		return extendedMeasurement;
	}

}
