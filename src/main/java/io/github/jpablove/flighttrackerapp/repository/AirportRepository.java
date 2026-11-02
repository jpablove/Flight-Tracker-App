package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class AirportRepository {
    private final JdbcClient jdbc;

    public AirportRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public int getOrCreate(String iata, String icao, String name, String timezone) {
        return jdbc.sql("INSERT INTO airport (iata, icao, name, timezone) VALUES (:iata, :icao, :name, :timezone) " +
                "ON CONFLICT (iata) " +
                "DO UPDATE SET  icao = EXCLUDED.icao, " +
                "               name = EXCLUDED.name, " +
                "               timezone = EXCLUDED.timezone " +
                "RETURNING airport_id")
                .param("iata", iata)
                .param("icao", icao)
                .param("name", name)
                .param("timezone", timezone)
                .query(Integer.class)
                .single();
    }
}
