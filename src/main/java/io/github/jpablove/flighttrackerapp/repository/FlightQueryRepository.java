package io.github.jpablove.flighttrackerapp.repository;

import io.github.jpablove.flighttrackerapp.api.dto.Flight;
import io.github.jpablove.flighttrackerapp.model.FlightSummary;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class FlightQueryRepository {
    private final JdbcClient jdbc;

    public FlightQueryRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public List<FlightSummary> getFlights() {
        return jdbc.sql("""
                SELECT *
                FROM flight
                ORDER BY flight_id
                """)
                .query(FlightSummary.class)
                .list();
    }
}
