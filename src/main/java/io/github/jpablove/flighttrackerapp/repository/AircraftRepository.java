package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class AircraftRepository {
    private final JdbcClient jdbc;

    public AircraftRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(String registration, String icao24, Integer aircraftTypeId) {
        return jdbc.sql("""
                        INSERT INTO aircraft (registration, icao24, aircraft_type_id) 
                        VALUES (:registration, :icao24, :aircraft_type_id) 
                        ON CONFLICT (icao24) 
                        DO UPDATE SET registration = EXCLUDED.registration 
                        RETURNING aircraft_id
                        """)
                .param("registration", registration)
                .param("icao24", icao24)
                .param("aircraft_type_id", aircraftTypeId)
                .query(Integer.class)
                .single();
    }
}
