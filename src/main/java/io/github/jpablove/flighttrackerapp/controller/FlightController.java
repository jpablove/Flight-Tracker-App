package io.github.jpablove.flighttrackerapp.controller;

import io.github.jpablove.flighttrackerapp.service.FlightIngestionService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

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

    @GetMapping(value = "/get")
    public void getFlights() {
        this.flightIngestionService.getFlights();
    }

    @GetMapping(value = "/get/{flight_date}")
    public void getFlightsByDate(@PathVariable("flight_date") LocalDate flightDate) {
        this.flightIngestionService.getFlightsByDate(flightDate);
    }
}
