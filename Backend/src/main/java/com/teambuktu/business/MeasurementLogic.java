package com.teambuktu.business;

import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.teambuktu.models.DisplayMeasurement;
import com.teambuktu.models.ExtendedMeasurement;
import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.DisplayMeasurementRepository;
import com.teambuktu.repositories.MeasurementRepository;

@Component
public class MeasurementLogic {

	private final int MAX_HUMIDITY = 3000;
	private final double CRITICAL_VALUE = 20.0;

	private final Logger logger = LoggerFactory.getLogger(MeasurementLogic.class);

	@Autowired
	private MeasurementRepository measurementRepository;
	@Autowired
	private DisplayMeasurementRepository displayMeasurementRepository;

	public ExtendedMeasurement getExtendedMeasurement(Measurement lastMeasurement) {

		ExtendedMeasurement extendedMeasurement = new ExtendedMeasurement(lastMeasurement);

		long percentageSoilHumidity = calculateSoilHumidityPercentage(extendedMeasurement.getSoilHumidity());
		extendedMeasurement.setSoilHumidity(percentageSoilHumidity);

		predictCriticalValue(extendedMeasurement);

		return extendedMeasurement;
	}

	private long calculateSoilHumidityPercentage(long soilHumidity) {
		double percentageSoilHumidity = (soilHumidity * 100) / this.MAX_HUMIDITY;
		logger.info(String.format("Soil Humidity percentage: %.2f", percentageSoilHumidity));

		return Math.round(percentageSoilHumidity);
	}

	private void predictCriticalValue(ExtendedMeasurement extendedMeasurement) {

		long soilHumidity = extendedMeasurement.getSoilHumidity();
		int temperature = extendedMeasurement.getTemperature();

		int step = -1;

		for (int i = 0; i < 12; i++) {
			step = (i + 1);
			double expVal = -1 * (temperature / 400) * step;
			logger.info(String.format("e^... value: %f", expVal));
			double calculatedValue = soilHumidity * Math.exp(expVal);
			logger.info(String.format("calculated prediction value: %.2f", calculatedValue));

			if (calculatedValue < CRITICAL_VALUE) {
				break;
			}
		}

		logger.info(String.format("Time to critical: %d", step));
		extendedMeasurement.setTimeToCritical(step);
	}

	public void saveDisplayValues(String deviceIdentifier) {
		List<Measurement> latestMeasurements = measurementRepository
				.findTop3ByDeviceIdentifierOrderByTimestampDesc(deviceIdentifier);

		displayMeasurementRepository.save(calculateMedian(latestMeasurements));

	}

	private DisplayMeasurement calculateMedian(List<Measurement> measurements) {
		DisplayMeasurement displayMeasurement = new DisplayMeasurement();

		Long soildHumidity = measurements.stream().map(m -> m.getSoilHumidity()).sorted(Comparator.naturalOrder())
				.collect(Collectors.toList()).get(1);

		Long environmentHumidity = measurements.stream().map(m -> m.getEnvironmentHumidity())
				.sorted(Comparator.naturalOrder()).collect(Collectors.toList()).get(1);

		int temperature = measurements.stream().map(m -> m.getTemperature()).sorted(Comparator.naturalOrder())
				.collect(Collectors.toList()).get(1);

		displayMeasurement.setEnvironmentHumidity(environmentHumidity);
		displayMeasurement.setSoilHumidity(soildHumidity);
		displayMeasurement.setTemperature(temperature);
		displayMeasurement.setDeviceIdentifier(measurements.get(0).getDeviceIdentifier());
		displayMeasurement.setTimestamp(new Date());

		return displayMeasurement;
	}

}
