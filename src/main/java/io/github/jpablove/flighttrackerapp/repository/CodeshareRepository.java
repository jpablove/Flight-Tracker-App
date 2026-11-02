package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class CodeshareRepository {
    private final JdbcClient jdbc;

    public CodeshareRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(long flightId, Integer operatingAirlineNumber, String operatingFlightNumber) {
        return jdbc.sql("""
            INSERT INTO codeshare (flight_id, operating_airline_id, operating_flight_number)
            VALUES (:flight_id, :operating_airline_id, :operating_flight_number)
            ON CONFLICT (flight_id) DO UPDATE SET
                operating_airline_id = EXCLUDED.operating_airline_id,
                operating_flight_number = EXCLUDED.operating_flight_number
            RETURNING flight_id
            """)
                .param("flight_id", flightId)
                .param("operating_airline_id", operatingAirlineNumber)
                .param("operating_flight_number", operatingFlightNumber)
                .query(Integer.class)
                .single();
    }
}
