package io.github.jpablove.flighttrackerapp.api.client;

import io.github.jpablove.flighttrackerapp.api.dto.FlightResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

@Component
public class AviationStackClient {
    private final RestClient restClient;
    private final String apiKey;

    public AviationStackClient(@Value("${aviationstack.api-key}") String apiKey) {
        this.apiKey = apiKey;
        this.restClient = RestClient.builder()
                .baseUrl("https://api.aviationstack.com/v1")
                .defaultHeader("Accept", "application/json")
                .build();
    }

    public FlightResponse getFlights() {
        return this.restClient.get()
                .uri(uri -> uri.path("/flights")
                        .queryParam("access_key", apiKey)
                        .build())
                .retrieve()
                .body(FlightResponse.class);
    }
}
