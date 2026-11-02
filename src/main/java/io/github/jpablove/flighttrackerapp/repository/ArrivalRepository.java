package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;

@Repository
public class ArrivalRepository {
    private final JdbcClient jdbc;

    public ArrivalRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(long flightId, String terminal, String gate, String baggage, Integer delay, OffsetDateTime scheduled,
                               OffsetDateTime estimated, OffsetDateTime actual, OffsetDateTime estimatedRunway, OffsetDateTime actualRunway) {
        return jdbc.sql("""
                     INSERT INTO arrival (flight_id, terminal, gate, baggage, delay, scheduled, estimated, actual, estimated_runway, actual_runway) VALUES (:flight_id, :terminal, :gate, :baggage, :delay, :scheduled, :estimated, :actual, :estimated_runway, :actual_runway)\s
                     ON CONFLICT (flight_id)\s
                     DO UPDATE SET scheduled = EXCLUDED.scheduled\s
                        RETURNING flight_id
                \s""")
                .param("flight_id", flightId)
                .param("terminal", terminal)
                .param("gate", gate)
                .param("baggage", baggage)
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
