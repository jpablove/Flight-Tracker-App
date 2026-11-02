package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Aircraft {
    @JsonProperty("registration")
    private String registration;

    @JsonProperty("iata")
    private String iata;

    @JsonProperty("icao")
    private String icao;

    @JsonProperty("icao24")
    private String icao24;

    public Aircraft(){}

    public Aircraft(String registration, String iata, String icao, String icao24) {
        this.registration = registration;
        this.iata = iata;
        this.icao = icao;
        this.icao24 = icao24;
    }

    public String getRegistration() {
        return registration;
    }

    public void setRegistration(String registration) {
        this.registration = registration;
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

    public String getIcao24() {
        return icao24;
    }

    public void setIcao24(String icao24) {
        this.icao24 = icao24;
    }

    @Override
    public String toString() {
        return "Aircraft{" +
                "registration='" + registration + '\'' +
                ", iata='" + iata + '\'' +
                ", icao='" + icao + '\'' +
                ", icao24='" + icao24 + '\'' +
                "};";
    }
}
