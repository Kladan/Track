package com.teambuktu.business;

import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;

public class MeasurementLogic {

	public ExtendedMeasurement getExtendedMeasurement(Measurement measurement) {

		ExtendedMeasurement extendedMeasurement = new ExtendedMeasurement(measurement);

		return extendedMeasurement;
	}

}
