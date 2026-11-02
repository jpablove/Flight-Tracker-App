package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Airline {
    @JsonProperty("name")
    private String name;

    @JsonProperty("iata")
    private String iata;

    @JsonProperty("icao")
    private String icao;

    public Airline(){}

    public Airline(String name, String iata, String icao) {
        this.name = name;
        this.iata = iata;
        this.icao = icao;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getIata() {
        return iata;
    }

    public void setIata(String iata) {
        this.iata = iata;
    }

    public String getIcao() {
        return icao;
    }

    public void setIcao(String icao) {
        this.icao = icao;
    }

    @Override
    public String toString() {
        return "Airline{" +
                "name='" + name + '\'' +
                ", iata='" + iata + '\'' +
                ", icao='" + icao + '\'' +
                "};";
    }
}
