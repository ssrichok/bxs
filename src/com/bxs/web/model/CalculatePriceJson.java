package com.bxs.web.model;

import java.util.List;

public class CalculatePriceJson {

    private List<CalculatePrice> mpList;

    public CalculatePriceJson(List<CalculatePrice> mpList) {
	super();
	this.mpList = mpList;
    }

    public List<CalculatePrice> getMpList() {
	return mpList;
    }

    public void setMpList(List<CalculatePrice> mpList) {
	this.mpList = mpList;
    }
}
