package io.github.jpablove.flighttrackerapp.repository;

import io.github.jpablove.flighttrackerapp.model.FlightSummary;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
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

    public List<FlightSummary> getFlightsByDate(LocalDate flightDate) {
        return jdbc.sql("""
                SELECT *
                FROM flight
                WHERE flight_date = :flightDate
                ORDER BY flight_id
                """)
                .param("flightDate", flightDate)
                .query(FlightSummary.class)
                .list();
    }
}
