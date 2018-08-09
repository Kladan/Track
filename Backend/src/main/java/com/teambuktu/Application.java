package com.teambuktu;

import com.teambuktu.models.Measurement;
import com.teambuktu.repositories.MeasurementRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.util.Date;

@SpringBootApplication
public class Application implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);


	}

	@Autowired
	private MeasurementRepository repo;

	@Override
	public void run(String... args) throws Exception {


	}
}
