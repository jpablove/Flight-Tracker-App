package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class AircraftTypeRepository {
    private final JdbcClient jdbc;

    public AircraftTypeRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(String iataCode, String icaoCode) {
        return jdbc.sql("""
            INSERT INTO aircraft_type (iata_code, icao_code)
            VALUES (:iata_code, :icao_code)
            ON CONFLICT (iata_code) DO UPDATE SET
                icao_code = EXCLUDED.icao_code
            RETURNING aircraft_type_id
            """)
                .param("iata_code", iataCode)
                .param("icao_code", icaoCode)
                .query(Integer.class)
                .single();
    }
}
