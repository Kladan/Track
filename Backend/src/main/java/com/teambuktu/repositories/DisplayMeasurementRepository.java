package com.teambuktu.repositories;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.teambuktu.models.DisplayMeasurement;

public interface DisplayMeasurementRepository extends MongoRepository<DisplayMeasurement, String> {

	public List<DisplayMeasurement> findByDeviceIdentifier(String deviceIdentifier);

	public List<DisplayMeasurement> findByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);

	public List<DisplayMeasurement> findTop3ByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);

	public DisplayMeasurement findFirstByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);
}
