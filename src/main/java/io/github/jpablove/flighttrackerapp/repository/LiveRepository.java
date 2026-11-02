package io.github.jpablove.flighttrackerapp.repository;

import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;

@Repository
public class LiveRepository {
    private final JdbcClient jdbc;

    public LiveRepository(JdbcClient jdbc) {
        this.jdbc = jdbc;
    }

    public Integer getOrCreate(long flightId, OffsetDateTime updated, Double latitude, Double longitude,
                               Double altitude, Double direction, Double speedHorizontal,
                               Double speedVertical, Boolean isGround) {
        return jdbc.sql("""
                INSERT INTO live (flight_id, updated, latitude, longitude, altitude, direction, speed_horizontal, speed_vertical, is_ground)
                VALUES (:flight_id, :updated, :latitude, :longitude, :altitude, :direction, :speed_horizontal, :speed_vertical, :is_ground)
                ON CONFLICT (flight_id)
                DO UPDATE SET
                    updated = EXCLUDED.updated,
                    latitude = EXCLUDED.latitude,
                    longitude = EXCLUDED.longitude,
                    altitude = EXCLUDED.altitude,
                    direction = EXCLUDED.direction,
                    speed_horizontal = EXCLUDED.speed_horizontal,
                    speed_vertical = EXCLUDED.speed_vertical,
                    is_ground = EXCLUDED.is_ground
                RETURNING flight_id
                """)
                .param("flight_id", flightId)
                .param("updated", updated)
                .param("latitude", latitude)
                .param("longitude", longitude)
                .param("altitude", altitude)
                .param("direction", direction)
                .param("speed_horizontal", speedHorizontal)
                .param("speed_vertical", speedVertical)
                .param("is_ground", isGround)
                .query(Integer.class)
                .single();
    }
}
