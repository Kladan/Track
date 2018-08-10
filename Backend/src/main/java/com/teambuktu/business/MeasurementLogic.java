package com.teambuktu.business;

import com.teambuktu.models.DisplayMeasurement;
import com.teambuktu.repositories.DisplayMeasurementRepository;
import com.teambuktu.repositories.MeasurementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class MeasurementLogic {

	@Autowired
	private MeasurementRepository measurementRepository;
	@Autowired
	private DisplayMeasurementRepository displayMeasurementRepository;

	public ExtendedMeasurement getExtendedMeasurement(Measurement lastMeasurement) {

		ExtendedMeasurement extendedMeasurement = new ExtendedMeasurement(lastMeasurement);

		return extendedMeasurement;
	}

	public void saveDisplayValues(String deviceIdentifier)	{
		List<Measurement> latestMeasurements = measurementRepository
				.findTop3ByDeviceIdentifierOrderByTimestampDesc(deviceIdentifier);

		displayMeasurementRepository.save(calculateMedian(latestMeasurements));

	}

	private DisplayMeasurement calculateMedian(List<Measurement> measurements) {
		DisplayMeasurement displayMeasurement = new DisplayMeasurement();

		Long soildHumidity = measurements.stream().map(m->m.getSoilHumidity()).sorted(Comparator.naturalOrder())
				.collect(Collectors.toList()).get(1);

		Long environmentHumidity = measurements.stream().map(m->m.getEnvironmentHumidity()).sorted(Comparator.naturalOrder())
				.collect(Collectors.toList()).get(1);

		int temperature = measurements.stream().map(m->m.getTemperature()).sorted(Comparator.naturalOrder())
				.collect(Collectors.toList()).get(1);

		displayMeasurement.setEnvironmentHumidity(environmentHumidity);
		displayMeasurement.setSoilHumidity(soildHumidity);
		displayMeasurement.setTemperature(temperature);
		displayMeasurement.setDeviceIdentifier(measurements.get(0).getDeviceIdentifier());
		displayMeasurement.setTimestamp(new Date());

		return displayMeasurement;
	}

}
