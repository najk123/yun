package cn.allene.yun.pojo;


public class FileCustom {
	private String fileName;
	private String fileType;
	private String fileSize;
	private String lastTime;
	private String prePath;
	public String getPrePath() {
		return prePath;
	}
	public void setPrePath(String prePath) {
		this.prePath = prePath;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
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
