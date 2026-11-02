package io.github.jpablove.flighttrackerapp.service;

import io.github.jpablove.flighttrackerapp.api.client.AviationStackClient;
import io.github.jpablove.flighttrackerapp.api.dto.Flight;
import io.github.jpablove.flighttrackerapp.api.dto.FlightResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class FlightIngestionService {
    private static final Logger logger = LoggerFactory.getLogger(FlightIngestionService.class);

    private final AviationStackClient aviationStackClient;
    private final FlightPersister flightPersister;

    public FlightIngestionService(AviationStackClient aviationStackClient, FlightPersister flightPersister) {
        this.aviationStackClient = aviationStackClient;
        this.flightPersister = flightPersister;
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
}
