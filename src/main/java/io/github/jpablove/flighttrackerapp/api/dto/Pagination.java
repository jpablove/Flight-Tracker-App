package io.github.jpablove.flighttrackerapp.api.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Pagination {
    @JsonProperty("limit")
    private int limit;

    @JsonProperty("offset")
    private int offset;

    @JsonProperty("count")
    private int count;

    @JsonProperty("total")
    private int total;

    public Pagination(){}

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }

    public int getOffset() {
        return offset;
    }

    public void setOffset(int offset) {
        this.offset = offset;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "Pagination{" +
                "limit=" + limit +
                ", offset=" + offset +
                ", count=" + count +
                ", total=" + total +
                '}';
    }
}