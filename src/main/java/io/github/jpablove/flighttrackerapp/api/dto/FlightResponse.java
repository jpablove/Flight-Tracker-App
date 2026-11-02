package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public class FlightResponse {
    @JsonProperty("pagination")
    private Pagination pagination;

    @JsonProperty("data")
    private List<Flight> data;

    public FlightResponse(){}

    public FlightResponse(Pagination pagination, List<Flight> data) {
        this.pagination = pagination;
        this.data = data;
    }

    public Pagination getPagination() {
        return pagination;
    }

    public void setPagination(Pagination pagination) {
        this.pagination = pagination;
    }

    public List<Flight> getData() {
        return data;
    }

    public void setData(List<Flight> data) {
        this.data = data;
    }
}