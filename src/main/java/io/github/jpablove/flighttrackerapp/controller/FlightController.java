package io.github.jpablove.flighttrackerapp.controller;

import io.github.jpablove.flighttrackerapp.service.FlightIngestionService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/flights")
public class FlightController {
    private final FlightIngestionService flightIngestionService;

    public FlightController(FlightIngestionService flightIngestionService) {
        this.flightIngestionService = flightIngestionService;
    }

    @PostMapping("/refresh")
    public void refresh() {
        this.flightIngestionService.refreshFlights();
    }
}
