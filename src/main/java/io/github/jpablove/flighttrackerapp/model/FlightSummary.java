package io.github.jpablove.flighttrackerapp.model;

import java.time.LocalDate;

public record FlightSummary(
        long flightId,
        LocalDate flightDate,
        String flightStatus,
        String airlineId,
        String flightNumber,
        String departureAirportId,
        String arrivalAirportId,
        String aircraftId,
        String updatedAt) {
}