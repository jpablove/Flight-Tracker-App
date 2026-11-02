package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Flight {
    @JsonProperty("flight_date")
    private String flight_date;

    @JsonProperty("flight_status")
    private String flight_status;

    @JsonProperty("departure")
    private Departure departure;

    @JsonProperty("arrival")
    private Arrival arrival;

    @JsonProperty("airline")
    private Airline airline;

    @JsonProperty("flight")
    private FlightDetails flightDetails;

    @JsonProperty("aircraft")
    private Aircraft aircraft;

    @JsonProperty("live")
    private Live live;

    public Flight(){}

    public Flight(String flight_date, String flight_status, Departure departure, Arrival arrival, Airline airline, FlightDetails flightDetails, Aircraft aircraft, Live live) {
        this.flight_date = flight_date;
        this.flight_status = flight_status;
        this.departure = departure;
        this.arrival = arrival;
        this.airline = airline;
        this.flightDetails = flightDetails;
        this.aircraft = aircraft;
        this.live = live;
    }

    public String getFlight_date() {
        return flight_date;
    }

    public void setFlight_date(String flight_date) {
        this.flight_date = flight_date;
    }

    public String getFlight_status() {
        return flight_status;
    }

    public void setFlight_status(String flight_status) {
        this.flight_status = flight_status;
    }

    public Departure getDeparture() {
        return departure;
    }

    public void setDeparture(Departure departure) {
        this.departure = departure;
    }

    public Arrival getArrival() {
        return arrival;
    }

    public void setArrival(Arrival arrival) {
        this.arrival = arrival;
    }

    public Airline getAirline() {
        return airline;
    }

    public void setAirline(Airline airline) {
        this.airline = airline;
    }

    public FlightDetails getFlightDetalis() {
        return flightDetails;
    }

    public void setFlightDetalis(FlightDetails flightDetails) {
        this.flightDetails = flightDetails;
    }

    public Aircraft getAircraft() {
        return aircraft;
    }

    public void setAircraft(Aircraft aircraft) {
        this.aircraft = aircraft;
    }

    public Live getLive() {
        return live;
    }

    public void setLive(Live live) {
        this.live = live;
    }

    @Override
    public String toString() {
        return "Flight{" +
                "flight_date='" + flight_date + '\'' +
                ", flight_status='" + flight_status + '\'' +
                ", departure=" + departure +
                ", arrival=" + arrival +
                ", airline=" + airline +
                ", flightDetalis=" + flightDetails +
                ", aircraft=" + aircraft +
                ", live='" + live + '\'' +
                '}';
    }
}