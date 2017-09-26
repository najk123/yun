package cn.allene.yun.pojo;


public class FileCustom {
	private String fileName;
	private boolean isFile;
	private String fileSize;
	private String lastTime;
	private String filePath;
	private String currentPath;
	public String getCurrentPath() {
		return currentPath;
	}
	public void setCurrentPath(String currentPath) {
		this.currentPath = currentPath;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public boolean isFile() {
		return isFile;
	}
	public boolean getIsFile() {
		return isFile;
	}
	public void setFile(boolean isFile) {
		this.isFile = isFile;
	}
	public String getFileSize() {
		return fileSize;
	}
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}
	public String getLastTime() {
		return lastTime;
	}
	public void setLastTime(String lastTime) {
		this.lastTime = lastTime;
	}
}
