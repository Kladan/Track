package com.teambuktu.mqtt;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.MeasurementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class Receiver {

    @Autowired
    private MeasurementRepository repo;

    public void receiveMessage(byte[] message) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        System.out.println(new String(message));
        Measurement measurement = objectMapper.readValue(new String(message), Measurement.class);

        repo.save(measurement);
    }

}