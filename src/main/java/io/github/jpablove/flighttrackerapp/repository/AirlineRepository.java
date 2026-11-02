package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

@Repository
public class AirlineRepository {
    private final JdbcClient jdbc;

    public AirlineRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public int getOrCreate(String iata, String icao, String name) {
        return jdbc.sql("""
            INSERT INTO airline (iata, icao, name) VALUES (:iata, :icao, :name)
                 ON CONFLICT (iata) DO UPDATE SET icao = EXCLUDED.icao,\s
                                                  name = EXCLUDED.name
            RETURNING airline_id
                \s""")
                .param("iata", iata)
                .param("icao", icao)
                .param("name", name)
                .query(Integer.class)
                .single();
    }
}
