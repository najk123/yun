package cn.allene.yun.utils;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

import cn.allene.yun.pojo.FileCustom;

public class FileUtils {
	private static final String PREFIX = "WEB-INF" + File.separator + "file" + File.separator;
	public static final String NAMESPACE = "username";

	public static String uploadFilePath(HttpServletRequest request, String fileName) {
		// String newFileName = UUID.randomUUID() +
		// fileName.substring(fileName.lastIndexOf("."));
		// checkDir(filePath);
		return getFileName(request, fileName);
	}

	public static String downPackage(HttpServletRequest request, String[] fileNames) throws Exception {
		if (fileNames.length == 1) {
			return getFileName(request, fileNames[0]);
		}
		String[] sourcePath = new String[fileNames.length];
		for (int i = 0; i < fileNames.length; i++) {
			sourcePath[i] = getFileName(request, fileNames[i]);
		}
		String packageZip = packageZip(sourcePath);
		return packageZip;
	}

	private static String packageZip(String[] sourcePath) throws Exception {
		String zipName = sourcePath[0] + (sourcePath.length == 1 ? "" : "等" + sourcePath.length + "个文件") + ".zip";
		ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipName));
		for (String string : sourcePath) {
			writeZos(new File(string), "", zos);
		}
		zos.close();
		return zipName;
	}

	private static void writeZos(File file, String basePath, ZipOutputStream zos) throws IOException {
		if (!file.exists()) {
			throw new FileNotFoundException();
		}
		if (file.isDirectory()) {
			File[] listFiles = file.listFiles();
			if (listFiles.length != 0) {
				for (File childFile : listFiles) {
					writeZos(childFile, basePath + file.getName() + File.separator, zos);
				}
			}
		} else {
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
			ZipEntry entry = new ZipEntry(basePath + file.getName());
			zos.putNextEntry(entry);
			int count = 0;
			byte data[] = new byte[1024];
			while ((count = bis.read(data)) != -1) {
				zos.write(data, 0, count);
			}
			bis.close();
		}
	}

	public static String getRootPath(HttpServletRequest request) {
		String username = (String) request.getSession().getAttribute(NAMESPACE);
		String rootPath = request.getSession().getServletContext().getRealPath("/") + PREFIX + username;
		return rootPath;
	}

	public static String getFileName(HttpServletRequest request, String fileName) {
		if(fileName == null){
			fileName = "";
		}
		return getRootPath(request) + File.separator + fileName;
	}

	public static List<FileCustom> listFile(String realPath) {
		File[] files = new File(realPath).listFiles();
		List<FileCustom> lists = new ArrayList<FileCustom>();
		for (File file : files) {
			FileCustom custom = new FileCustom();
			custom.setFileName(file.getName());
			custom.setLastTime(formatTime(file.lastModified()));
			if(file.isDirectory()){
				custom.setFileSize("-");
				custom.setFile(false);
			}else{
				custom.setFileSize(getDataSize(file.length()));
				custom.setFile(true);
			}
			lists.add(custom);
		}
		return lists;
	}

	public static String getDataSize(long size) {
		DecimalFormat formater = new DecimalFormat("####.0");
		if (size < 1024) {
			return size + "B";
		} else if (size < 1024 * 1024) {
			float kbsize = size / 1024f;
			return formater.format(kbsize) + "KB";
		} else if (size < 1024 * 1024 * 1024) {
			float mbsize = size / 1024f / 1024f;
			return formater.format(mbsize) + "MB";
		} else if (size < 1024 * 1024 * 1024 * 1024) {
			float gbsize = size / 1024f / 1024f / 1024f;
			return formater.format(gbsize) + "GB";
		} else {
			return "-";
		}
	}
	
	public static String formatTime(long time){
		return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date(time));
	}
	
	public static String getUrl8(){
		return UUID.randomUUID().toString().replace("-", "").substring(0, 8);
	}
}
