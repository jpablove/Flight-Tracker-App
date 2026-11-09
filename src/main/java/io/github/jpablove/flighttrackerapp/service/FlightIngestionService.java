package io.github.jpablove.flighttrackerapp.service;

import io.github.jpablove.flighttrackerapp.api.client.AviationStackClient;
import io.github.jpablove.flighttrackerapp.api.dto.Flight;
import io.github.jpablove.flighttrackerapp.api.dto.FlightResponse;
import io.github.jpablove.flighttrackerapp.model.FlightSummary;
import io.github.jpablove.flighttrackerapp.repository.FlightQueryRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FlightIngestionService {
    private static final Logger logger = LoggerFactory.getLogger(FlightIngestionService.class);

    private final AviationStackClient aviationStackClient;
    private final FlightPersister flightPersister;
    private final FlightQueryRepository flightQueryRepository;

    public FlightIngestionService(AviationStackClient aviationStackClient, FlightPersister flightPersister, FlightQueryRepository flightQueryRepository) {
        this.aviationStackClient = aviationStackClient;
        this.flightPersister = flightPersister;
        this.flightQueryRepository = flightQueryRepository;
    }

    public void refreshFlights() {
        FlightResponse response = aviationStackClient.getFlights();
        if (response == null || response.getData() == null) {
            logger.warn("AviationStack returned no data");
            return;
        }
        logger.info("Received {} flights", response.getData().size());
        int saved = 0;
        int failed = 0;
        for (Flight flight : response.getData()) {
            try {
                flightPersister.save(flight);
                saved++;
            } catch (Exception e) {
                failed++;
                logger.warn("Flight skipped: {}", e.getMessage());
            }
        }
        logger.info("Refresh finished: {} saved, {} failed", saved, failed);
    }

    public void getFlights() {
        List<FlightSummary> list = this.flightQueryRepository.getFlights();
        for (FlightSummary f : list) {
            logger.info(f.toString());
        }
    }
}
