package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Codeshared {
    @JsonProperty("airline_name")
    private String airline_name;

    @JsonProperty("airline_iata")
    private String airline_iata;

    @JsonProperty("airline_icao")
    private String airline_icao;

    @JsonProperty("flight_number")
    private String flight_number;

    @JsonProperty("flight_iata")
    private String flight_iata;

    @JsonProperty("flight_icao")
    private String flight_icao;

    public Codeshared(){}

    public Codeshared(String airline_name, String airline_iata, String airline_icao, String flight_number, String flight_iata, String flight_icao) {
        this.airline_name = airline_name;
        this.airline_iata = airline_iata;
        this.airline_icao = airline_icao;
        this.flight_number = flight_number;
        this.flight_iata = flight_iata;
        this.flight_icao = flight_icao;
    }

    public String getAirline_name() {
        return airline_name;
    }

    public void setAirline_name(String airline_name) {
        this.airline_name = airline_name;
    }

    public String getAirline_iata() {
        return airline_iata;
    }

    public void setAirline_iata(String airline_iata) {
        this.airline_iata = airline_iata;
    }

    public String getAirline_icao() {
        return airline_icao;
    }

    public void setAirline_icao(String airline_icao) {
        this.airline_icao = airline_icao;
    }

    public String getFlight_number() {
        return flight_number;
    }

    public void setFlight_number(String flight_number) {
        this.flight_number = flight_number;
    }

    public String getFlight_iata() {
        return flight_iata;
    }

    public void setFlight_iata(String flight_iata) {
        this.flight_iata = flight_iata;
    }

    public String getFlight_icao() {
        return flight_icao;
    }

    public void setFlight_icao(String flight_icao) {
        this.flight_icao = flight_icao;
    }

    @Override
    public String toString() {
        return "Codeshared{" +
                "airline_name='" + airline_name + '\'' +
                ", airline_iata='" + airline_iata + '\'' +
                ", airline_icao='" + airline_icao + '\'' +
                ", flight_number='" + flight_number + '\'' +
                ", flight_iata='" + flight_iata + '\'' +
                ", flight_icao='" + flight_icao + '\'' +
                "};";
    }
}