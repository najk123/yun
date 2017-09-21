package cn.allene.yun.service;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;

import cn.allene.yun.pojo.FileCustom;
import cn.allene.yun.pojo.summaryFile;
import cn.allene.yun.utils.FileUtils;
@Service
public class FileService {
	private static final String PREFIX = "WEB-INF" + File.separator + "file" + File.separator;
	public static final String NAMESPACE = "username";
	public static final String[] DEFAULT_DIRECTORY = {"vido","music","source"};
	
	public String uploadFilePath(HttpServletRequest request, String fileName) {
		return getFileName(request, fileName);
	}

	public String downPackage(HttpServletRequest request, String[] fileNames) throws Exception {
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

	private String packageZip(String[] sourcePath) throws Exception {
		String zipName = sourcePath[0] + (sourcePath.length == 1 ? "" : "等" + sourcePath.length + "个文件") + ".zip";
		ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(zipName));
		for (String string : sourcePath) {
			writeZos(new File(string), "", zos);
		}
		zos.close();
		return zipName;
	}

	private void writeZos(File file, String basePath, ZipOutputStream zos) throws IOException {
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

	public String getRootPath(HttpServletRequest request) {
		String rootPath = request.getSession().getServletContext().getRealPath("/") + PREFIX;
		return rootPath;
	}

	public String getFileName(HttpServletRequest request, String fileName) {
		if(fileName == null){
			fileName = "";
		}
		String username = (String) request.getSession().getAttribute(NAMESPACE);
		return getRootPath(request) + username + File.separator + fileName;
	}

	public List<FileCustom> listFile(String realPath) {
		File[] files = new File(realPath).listFiles();
		List<FileCustom> lists = new ArrayList<FileCustom>();
		for (File file : files) {
			FileCustom custom = new FileCustom();
			custom.setFileName(file.getName());
			custom.setLastTime(FileUtils.formatTime(file.lastModified()));
			if(file.isDirectory()){
				custom.setFileSize("-");
				custom.setFile(false);
			}else{
				custom.setFileSize(FileUtils.getDataSize(file.length()));
				custom.setFile(true);
			}
			lists.add(custom);
		}
		return lists;
	}
	
	public summaryFile summarylistFile(String realPath,int number){
		File file = new File(realPath);
		summaryFile sF = new summaryFile();
		List<summaryFile> returnlist = new ArrayList<summaryFile>();
		if(file.isDirectory()){
			sF.setisFile(false);
			if(realPath.length()<=number){
				sF.setfileName("yun盘");
				sF.setPath("");
			}else{
				String path = file.getPath();
				sF.setfileName(file.getName());
				sF.setPath(path.substring(number));
			}
			/*设置抽象文件夹的包含文件集合*/
			for(File filex : file.listFiles()){
				summaryFile innersF = summarylistFile(filex.getPath(),number);
				if(!innersF.getisFile()){
					returnlist.add(innersF);
				}
			}
			sF.setListFile(returnlist);
			/*设置抽象文件夹的包含文件夹个数*/
			sF.setListdiretory(returnlist.size());
			
		}else{
			sF.setisFile(true);
		}
		return sF;
	}

	public boolean addDirectory(HttpServletRequest request, String currentPath, String directoryName) {
		File file = new File(getFileName(request, currentPath), directoryName);
		return file.mkdir();
	}

	public void delDirectory(HttpServletRequest request, String currentPath, String[] directoryName) {
		for (String delName : directoryName) {
			File srcFile = new File(getFileName(request, currentPath), delName);
			delFile(srcFile);
		}
	}

	private void delFile(File srcFile) {
		/*如果是文件，直接删除*/
		if(!srcFile.isDirectory()){
			srcFile.delete();
			return ;
		}
		/*如果是文件夹，再遍历*/
		File[] listFiles = srcFile.listFiles();
		for (File file : listFiles) {
			if(file.isDirectory()){
				delFile(file);
			}else{
				if(file.exists()){
					file.delete();
				}
			}
		}
		if(srcFile.exists()){
			srcFile.delete();
		}
	}

	public boolean renameDirectory(HttpServletRequest request, String currentPath, String srcName, String destName) {
		File file = new File(getFileName(request, currentPath), srcName);
		File descFile = new File(getFileName(request, currentPath), destName);
		return file.renameTo(descFile);
	}

	public void addNewNameSpace(HttpServletRequest request, String namespace) {
		String fileName = getRootPath(request);
		File file = new File(fileName, namespace);
		file.mkdir();
		for (String newFileName : DEFAULT_DIRECTORY) {
			File newFile = new File(file, newFileName);
			newFile.mkdir();
		}
	}

	private void copyfile(File srcFile, File targetFile) throws IOException {
		// TODO Auto-generated method stub
		if(!srcFile.isDirectory()){
			/*如果是文件，直接复制*/
			targetFile.createNewFile();
			FileInputStream src = (new FileInputStream(srcFile));
			FileOutputStream target = new FileOutputStream(targetFile);
			FileChannel in = src.getChannel();
			FileChannel out = target.getChannel();
			in.transferTo(0, in.size(), out);
			src.close();
			target.close();
		}else{
			/*如果是文件夹，再遍历*/
			File[] listFiles = srcFile.listFiles();
			targetFile.mkdir();
			for (File file : listFiles) {
				File realtargetFile = new File(targetFile, file.getName());
				copyfile(file,realtargetFile);
			}
		}
	}
	public void moveDirectory(HttpServletRequest request, String currentPath,String[] directoryName, String targetdirectorypath) throws IOException {
		// TODO Auto-generated method stub
		for (String srcName : directoryName) {
			File srcFile = new File(getFileName(request, currentPath), srcName);
			File targetFile = new File(getFileName(request, targetdirectorypath), srcName);
			/*处理目标目录中存在同名文件或文件夹问题*/
			if(srcFile.isDirectory()){
				if(targetFile.exists()){
					for(int i = 1;!targetFile.mkdir();i++){
						targetFile = new File(targetFile.getParentFile(),srcName+"("+i+")");
					};
				}
			}else{
				if(targetFile.exists()){
					for(int i = 1;!targetFile.createNewFile();i++){
						targetFile = new File(targetFile.getParentFile(),srcName+"("+i+")");
					}
				}
			}
			
			/*移动即先复制，再删除*/
		    copyfile(srcFile,targetFile);
		    delFile(srcFile);
		}
	}
}
