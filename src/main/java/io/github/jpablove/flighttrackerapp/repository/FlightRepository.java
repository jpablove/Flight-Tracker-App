package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;

@Repository
public class FlightRepository {
    private final JdbcClient jdbc;

    public FlightRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(LocalDate flightDate, String flightStatus, Integer airlineId, String flightNumber,
                               Integer departureAirportId, Integer arrivalAirportId, Integer aircraftId) {
        return jdbc.sql("""
                INSERT INTO flight (flight_date, flight_status, airline_id, flight_number,
                                    departure_airport_id, arrival_airport_id, aircraft_id)
                VALUES (:flight_date, :flight_status, :airline_id, :flight_number,
                        :departure_airport_id, :arrival_airport_id, :aircraft_id)
                ON CONFLICT (flight_date, airline_id, flight_number, departure_airport_id)
                DO UPDATE SET flight_status      = EXCLUDED.flight_status,
                              arrival_airport_id = EXCLUDED.arrival_airport_id,
                              aircraft_id        = COALESCE(EXCLUDED.aircraft_id, flight.aircraft_id),
                              updated_at         = now()
                RETURNING flight_id
                """)
                .param("flight_date", flightDate)
                .param("flight_status", flightStatus)
                .param("airline_id", airlineId)
                .param("flight_number", flightNumber)
                .param("departure_airport_id", departureAirportId)
                .param("arrival_airport_id", arrivalAirportId)
                .param("aircraft_id", aircraftId)
                .query(Integer.class)
                .single();

    }
}
