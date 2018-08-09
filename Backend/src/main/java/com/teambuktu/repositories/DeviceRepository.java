package com.teambuktu.repositories;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import com.teambuktu.models.Device;

@RepositoryRestResource(collectionResourceRel = "device", path = "device")
public interface DeviceRepository extends MongoRepository<Device, String> {

	public Device findByDeviceIdentifier(String deviceIdentifier);
}
