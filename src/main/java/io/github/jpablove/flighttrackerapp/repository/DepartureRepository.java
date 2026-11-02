package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;

@Repository
public class DepartureRepository {
    private final JdbcClient jdbc;

    public DepartureRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(long flightId, String terminal, String gate, Integer delay, OffsetDateTime scheduled,
                               OffsetDateTime estimated, OffsetDateTime actual, OffsetDateTime estimatedRunway, OffsetDateTime actualRunway) {
        return jdbc.sql("""
                INSERT INTO departure (flight_id, terminal, gate, delay, scheduled, estimated, actual, estimated_runway, actual_runway)
                VALUES (:flight_id, :terminal, :gate, :delay, :scheduled, :estimated, :actual, :estimated_runway, :actual_runway)
                ON CONFLICT (flight_id)
                DO UPDATE SET terminal = EXCLUDED.terminal,
                              gate = EXCLUDED.gate,
                              delay = EXCLUDED.delay,
                              scheduled = EXCLUDED.scheduled,
                              estimated = EXCLUDED.estimated,
                              actual = EXCLUDED.actual,
                              estimated_runway = EXCLUDED.estimated_runway,
                              actual_runway = EXCLUDED.actual_runway
                RETURNING flight_id
                """)
                .param("flight_id", flightId)
                .param("terminal", terminal)
                .param("gate", gate)
                .param("delay", delay)
                .param("scheduled", scheduled)
                .param("estimated", estimated)
                .param("actual", actual)
                .param("estimated_runway", estimatedRunway)
                .param("actual_runway", actualRunway)
                .query(Integer.class)
                .single();
    }
}
