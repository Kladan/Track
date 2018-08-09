package com.teambuktu.repositories;

import java.util.List;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.teambuktu.models.Measurement;

public interface MeasurementRepository extends MongoRepository<Measurement, String> {

	public List<Measurement> findByDeviceIdentifier(String deviceIdentifier);

	public List<Measurement> findByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);

	public Measurement findFirstByDeviceIdentifierOrderByTimestampDesc(String deviceIdentifier);
}
