package com.teambuktu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.MeasurementRepository;

@SpringBootApplication
public class Application implements CommandLineRunner {

	@Autowired
	private MeasurementRepository measurementRepo;

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}

	@Override
	public void run(String... args) throws Exception {

		measurementRepo.deleteAll();

		Measurement m1 = new Measurement();
		m1.setDeviceName("sngsgi");
		m1.setSoilMoisture(59);
		Measurement m2 = new Measurement();
		m2.setDeviceName("sknkfue");
		m2.setSoilMoisture(71);

		measurementRepo.save(m1);
		measurementRepo.save(m2);

		measurementRepo.findAll().forEach(x -> System.out.println(x.getDeviceName()));

	}

}
