package io.github.jpablove.flighttrackerapp.service;

import io.github.jpablove.flighttrackerapp.api.dto.Airline;
import io.github.jpablove.flighttrackerapp.api.dto.Arrival;
import io.github.jpablove.flighttrackerapp.api.dto.Departure;
import io.github.jpablove.flighttrackerapp.api.dto.Flight;
import io.github.jpablove.flighttrackerapp.repository.AirlineRepository;
import io.github.jpablove.flighttrackerapp.repository.AirportRepository;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class FlightPersister {
    private final AirlineRepository airlineRepository;
    private final AirportRepository airportRepository;

    public FlightPersister(AirlineRepository airlineRepository, AirportRepository airportRepository) {
        this.airlineRepository = airlineRepository;
        this.airportRepository = airportRepository;
    }

    @Transactional
    public void save(Flight f) {
        Airline a = f.getAirline();
        Departure dep = f.getDeparture();
        Arrival arrival = f.getArrival();
        if(a == null || dep == null || arrival == null || a.getIata() == null) {
            throw new IllegalArgumentException("Flight does not have airline");
        }
        Integer airlineId = airlineRepository.getOrCreate(a.getIata(), a.getIcao(), a.getName());
        Integer departureId = airportRepository.getOrCreate(dep.getIata(), dep.getIcao(), dep.getAirport(), dep.getTimezone());
        Integer arrivalId = airportRepository.getOrCreate(arrival.getIata(), arrival.getIcao(), arrival.getAirport(), arrival.getTimezone());

    }
}
