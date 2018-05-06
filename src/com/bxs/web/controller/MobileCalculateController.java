package com.bxs.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.bxs.web.imp.FileMgmtService;
import com.bxs.web.model.UsageList;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

@Controller
@RequestMapping("/mobile")
public class MobileCalculateController {

    private Logger logger = Logger.getLogger(getClass());
    public static final String DEFAULT_DISPLAY_DATEFORMAT = "dd-MM-yyyy";

    private void initIndex(ModelMap model, FileMgmtService service) throws Exception {
	UsageList usagelist = new UsageList();
	UsageList usagelistUpload = new UsageList();
	model.addAttribute("usagelist", usagelist);
	model.addAttribute("usagelistUpload", usagelistUpload);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response) throws Exception {
	FileMgmtService service = new FileMgmtService();
	initIndex(model, service);
	return "pages/calculateMobilePrice";
    }

    // @Validated MultipartFileWrapper file
    @RequestMapping(value = "/multiPartFileSingle", method = RequestMethod.POST)
    @ResponseBody
    public String uploadFile(@RequestParam(required = false) final boolean confirm, ModelMap model, HttpServletRequest request,
	    HttpServletResponse response, @RequestParam("file") MultipartFile file) throws Exception {
	HttpSession session = request.getSession(false);
	if (session == null)
	    return ""; // Session has been expired

	JsonObject jsonObject = new JsonObject();
	FileMgmtService service = new FileMgmtService();
	try {
	    String filename = file.getOriginalFilename().replaceAll("\\s", "");
	    byte[] data;
	    data = file.getBytes();
	    if (service.checkFileValidFormat(data) && service.checkFileValidFormat(filename, data)) {
		if (service.isFileExists(filename) && confirm != true) {
		    //
		} else {
		    service.addOrUpdateFile(filename, data);
		    jsonObject.addProperty("error_message", "");
		}
	    } else {
		jsonObject.addProperty("error_message", "Invalid file content format.");
	    }
	} catch (Exception e) {
	    logger.error("ERROR! ### VLR File (multiPartFileSingle) ###", e);
	    jsonObject.addProperty("error_message", e.getMessage());
	}

	Gson gson = new GsonBuilder().serializeNulls().setDateFormat(DEFAULT_DISPLAY_DATEFORMAT).create();
	String result = gson.toJson(jsonObject);
	return (result);
    }

}
