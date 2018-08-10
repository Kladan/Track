package com.teambuktu.repositories;

import com.teambuktu.models.DisplayMeasurement;
import com.teambuktu.models.Measurement;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface DisplayMeasurementRepository extends MongoRepository<DisplayMeasurement, String> {

	public List<DisplayMeasurement> findByDeviceIdentifier(String deviceIdentifier);

	public List<DisplayMeasurement> findByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);

	public List<DisplayMeasurement> findTop3ByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);

	public DisplayMeasurement findFirstByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);
}
