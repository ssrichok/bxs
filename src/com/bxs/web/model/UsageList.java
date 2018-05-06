package com.bxs.web.model;

import java.util.Date;

public class UsageList {
    String date;
    Date startTime;
    Date stopTime;
    String msisdn;
    String promotion;

    // private SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyyHH:mm:ss", Locale.ENGLISH);
    //
    // UsageList(String txt) throws ParseException {
    // String[] t = txt.split("[|]");
    // date = t[0];
    // startTime = dateFormat.parse(t[0] + t[1]);
    // stopTime = dateFormat.parse(t[0] + t[2]);
    // msisdn = t[3];
    // promotion = t[4];
    // }

    public String getDate() {
	return date;
    }

    public Date getStartTime() {
	return startTime;
    }

    public Date getStopTime() {
	return stopTime;
    }

    public String getMsisdn() {
	return msisdn;
    }

    public String getPromotion() {
	return promotion;
    }

}
