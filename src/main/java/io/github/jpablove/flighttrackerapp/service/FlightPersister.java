package io.github.jpablove.flighttrackerapp.service;

import io.github.jpablove.flighttrackerapp.api.dto.*;
import io.github.jpablove.flighttrackerapp.repository.*;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.OffsetDateTime;

@Component
public class FlightPersister {
    private final AircraftRepository aircraftRepository;
    private final AircraftTypeRepository aircraftTypeRepository;
    private final AirlineRepository airlineRepository;
    private final AirportRepository airportRepository;
    private final ArrivalRepository arrivalRepository;
    private final CodeshareRepository codeshareRepository;
    private final DepartureRepository departureRepository;
    private final FlightRepository flightRepository;
    private final LiveRepository liveRepository;

    public FlightPersister(AircraftRepository aircraftRepository,
                           AircraftTypeRepository aircraftTypeRepository,
                           AirlineRepository airlineRepository,
                           AirportRepository airportRepository,
                           ArrivalRepository arrivalRepository,
                           CodeshareRepository codeshareRepository,
                           DepartureRepository departureRepository,
                           FlightRepository flightRepository,
                           LiveRepository liveRepository) {
        this.aircraftRepository = aircraftRepository;
        this.aircraftTypeRepository = aircraftTypeRepository;
        this.airlineRepository = airlineRepository;
        this.airportRepository = airportRepository;
        this.arrivalRepository = arrivalRepository;
        this.codeshareRepository = codeshareRepository;
        this.departureRepository = departureRepository;
        this.flightRepository = flightRepository;
        this.liveRepository = liveRepository;
    }

    @Transactional
    public void save(Flight f) {
        Airline a = f.getAirline();
        Departure dep = f.getDeparture();
        Arrival arrival = f.getArrival();
        Aircraft aircraft = f.getAircraft();
        FlightDetails details = f.getFlightDetalis();

        if (a == null || a.getIata() == null) {
            throw new IllegalArgumentException("Flight without airline");
        }
        if (dep == null || dep.getIcao() == null) {
            throw new IllegalArgumentException("Flight without departure airport");
        }
        if (arrival == null || arrival.getIcao() == null) {
            throw new IllegalArgumentException("Flight without arrival airport");
        }
        if (details == null || details.getNumber() == null) {
            throw new IllegalArgumentException("Flight without number");
        }

        Integer airlineId = airlineRepository.getOrCreate(a.getIata(), a.getIcao(), a.getName());
        Integer departureAirportId = airportRepository.getOrCreate(dep.getIata(), dep.getIcao(), dep.getAirport(), dep.getTimezone());
        Integer arrivalAirportId = airportRepository.getOrCreate(arrival.getIata(), arrival.getIcao(), arrival.getAirport(), arrival.getTimezone());
        Integer aircraftId = getAircraftId(aircraft);

        Integer flightId = flightRepository.getOrCreate(LocalDate.parse(f.getFlight_date()), f.getFlight_status(), airlineId,
                String.valueOf(details.getNumber()), departureAirportId, arrivalAirportId, aircraftId);

        if (flightId != null) {
            OffsetDateTime scheduled = dep.getScheduled() != null ? OffsetDateTime.parse(dep.getScheduled()) : null;
            OffsetDateTime estimated = dep.getEstimated() != null ? OffsetDateTime.parse(dep.getEstimated()) : null;
            OffsetDateTime actual = dep.getActual() != null ? OffsetDateTime.parse(dep.getActual()) : null;
            OffsetDateTime estimatedRunway = dep.getEstimated_runway() != null ? OffsetDateTime.parse(dep.getEstimated_runway()) : null;
            OffsetDateTime actualRunway = dep.getActual_runway() != null ? OffsetDateTime.parse(dep.getActual_runway()) : null;
            departureRepository.getOrCreate(
                    flightId.longValue(),
                    dep.getTerminal(),
                    dep.getGate(),
                    dep.getDelay(),
                    scheduled,
                    estimated,
                    actual,
                    estimatedRunway,
                    actualRunway
            );

            OffsetDateTime arrivalScheduled = arrival.getScheduled() != null ? OffsetDateTime.parse(arrival.getScheduled()) : null;
            OffsetDateTime arrivalEstimated = arrival.getEstimated() != null ? OffsetDateTime.parse(arrival.getEstimated()) : null;
            OffsetDateTime arrivalActual = arrival.getActual() != null ? OffsetDateTime.parse(arrival.getActual()) : null;
            OffsetDateTime arrivalEstimatedRunway = arrival.getEstimated_runway() != null ? OffsetDateTime.parse(arrival.getEstimated_runway()) : null;
            OffsetDateTime arrivalActualRunway = arrival.getActual_runway() != null ? OffsetDateTime.parse(arrival.getActual_runway()) : null;

            arrivalRepository.getOrCreate(
                    flightId.longValue(),
                    arrival.getTerminal(),
                    arrival.getGate(),
                    arrival.getBaggage(),
                    arrival.getDelay(),
                    arrivalScheduled,
                    arrivalEstimated,
                    arrivalActual,
                    arrivalEstimatedRunway,
                    arrivalActualRunway);
        }

        if (details.getCodeshared() != null) {
            Codeshared codeshare = details.getCodeshared();
            codeshareRepository.getOrCreate(
                    flightId.longValue(),
                    airlineId,
                    codeshare.getFlight_number()
            );
        }

        if (f.getLive() != null) {
            Live live = f.getLive();

            OffsetDateTime liveUpdated = live.getUpdated() != null ? OffsetDateTime.parse(live.getUpdated()) : null;

            liveRepository.getOrCreate(
                    flightId.longValue(),
                    liveUpdated,
                    live.getLatitude(),
                    live.getLongitude(),
                    live.getAltitude(),
                    live.getDirection(),
                    live.getSpeedHorizontal(),
                    live.getSpeedVertical(),
                    live.getIsGround()
            );
        }
    }

    private Integer getAircraftId(Aircraft aircraft) {
        if(aircraft != null && aircraft.getRegistration() != null) {
            Integer typeId = (aircraft.getIata() != null || aircraft.getIcao() != null)
                    ? aircraftTypeRepository.getOrCreate(aircraft.getIata(), aircraft.getIcao())
                    : null;
            return aircraftRepository.getOrCreate(aircraft.getRegistration(), aircraft.getIcao24(), typeId);
        }
        return null;
    }
}
