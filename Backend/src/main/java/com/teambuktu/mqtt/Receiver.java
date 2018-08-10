package com.teambuktu.mqtt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.teambuktu.business.MeasurementLogic;
import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.MeasurementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Date;

@Component
public class Receiver {

    @Autowired
    private MeasurementRepository repo;
    @Autowired
    private MeasurementLogic measurementLogic;

    public void receiveMessage(byte[] message) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        System.out.println(new String(message));
        Measurement measurement = objectMapper.readValue(new String(message), Measurement.class);
        measurement.setTimestamp(new Date());
        repo.save(measurement);
        measurementLogic.saveDisplayValues(measurement.getDeviceIdentifier());
    }

}