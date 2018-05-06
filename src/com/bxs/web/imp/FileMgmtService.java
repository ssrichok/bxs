package com.bxs.web.imp;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.InputStreamReader;
import java.net.URL;

public class FileMgmtService {

    final public static String MSISDN_REGEX = "^[0-9]{1,}\\*?|\\*$";
    final public static String FILEMGMT_DIR_KEY = "/uploadFile";

    private String workingDirecotryPath;
    private URL directoryName;

    public FileMgmtService() {
	directoryName = getClass().getResource(FILEMGMT_DIR_KEY);

    }

    public boolean checkFileValidFormat(String name, byte[] data) throws Exception {
	BusinessRule.assertTrue(name.matches(getFilenamePattern()), "Invalid file name format.");
	return checkFileValidFormat(data);
    }

    public boolean isFileExists(String filename) {
	return FileUtil.checkFileExists(filename, getWorkingFilePath());
    }

    public boolean checkFileValidFormat(byte[] data) throws Exception {
	ByteArrayInputStream bin = new ByteArrayInputStream(data);
	InputStreamReader in = new InputStreamReader(bin);
	BufferedReader reader = new BufferedReader(in);
	String line = null;
	boolean bValid = false;

	while ((line = reader.readLine()) != null) {
	    if (!line.matches(MSISDN_REGEX) || line.length() > 10) {
		reader.close();
		return false;
	    }
	}

	bValid = true;
	reader.close();
	return bValid;
    }

    public void addOrUpdateFile(String filename, byte[] data) throws Exception {
	// Step1. Validate file content
	BusinessRule.assertTrue(checkFileValidFormat(data) == true, "Invalid file content format.");

	// Step2. Check file existing
	String[] name = filename.split("_");

	if (name.length == 2) {
	    filename = filename.toUpperCase().replace(".TXT", ".txt");
	}

	if (!isFileExists(filename)) {
	    // Step2.1 Save file to working directory if file not exist
	    FileUtil.saveFile(filename, getWorkingFilePath(), data);
	} else {
	    // Step2.2 save new file to working directory

	    FileUtil.saveFile(filename, getWorkingFilePath(), data);
	}
    }

    protected String getFilenamePattern() {
	return "^[a-zA-Z0-9-_\\-]*.log$";
    }

    protected String getWorkingFilePath() {
	return this.workingDirecotryPath;
    }

}
