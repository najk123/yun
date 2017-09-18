package cn.allene.yun.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.allene.yun.pojo.FileCustom;
import cn.allene.yun.pojo.Result;
import cn.allene.yun.service.FileService;

@Controller
@RequestMapping("/file")
public class FileController {
	@Autowired
	private HttpServletRequest request;

	@Autowired
	private FileService fileService;

	@RequestMapping("/upload")
	public @ResponseBody Result<String> upload(@RequestParam("files") MultipartFile[] files, String currentPath) {
		Result<String> result = null;
		if (files != null) {
			for (MultipartFile file : files) {
				String filePath = fileService.uploadFilePath(request, file.getOriginalFilename());
				try {
					file.transferTo(new File(filePath));
				} catch (Exception e) {
					e.printStackTrace();
					result = new Result<String>(301, false, "上传失败");
					return result;
				}
			}
		}
		result = new Result<String>(305, true, "上传成功");
		return result;
	}

	@RequestMapping("/download")
	public ResponseEntity<byte[]> download(String[] downPath) {
		try {
			String downPackage = fileService.downPackage(request, downPath);
			File downloadFile = new File(downPackage);
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			String fileName = new String(downloadFile.getName().getBytes("utf-8"), "iso-8859-1");
			headers.setContentDispositionFormData("attachment", fileName);
			return new ResponseEntity<byte[]>(org.apache.commons.io.FileUtils.readFileToByteArray(downloadFile),
					headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@RequestMapping("/getFiles")
	public @ResponseBody Result<List<FileCustom>> getFiles(String path) {
		String realPath = fileService.getFileName(request, path);
		List<FileCustom> listFile = fileService.listFile(realPath);
		Result<List<FileCustom>> result = new Result<List<FileCustom>>(325, true, "获取成功");
		result.setData(listFile);
		return result;
	}
	@RequestMapping("/addDirectory")
	public @ResponseBody Result<String> addDirectory(String currentPath, String directoryName){
		try {
			fileService.addDirectory(request, currentPath, directoryName);
			return new Result<>(326, true, "添加成功");
		} catch (Exception e) {
			return new Result<>(321, false, "添加失败");
		}
	}
	
	@RequestMapping("/delDirectory")
	public @ResponseBody Result<String> delDirectory(String currentPath, String[] directoryName){
		try {
			fileService.delDirectory(request, currentPath, directoryName);
			return new Result<>(327, true, "删除成功");
		} catch (Exception e) {
			return new Result<>(322, false, "删除失败");
		}
	}
	
	@RequestMapping("/renameDirectory")
	public @ResponseBody Result<String> renameDirectory(String currentPath, String srcName, String destName){
		try {
			fileService.renameDirectory(request, currentPath, srcName, destName);
			return new Result<>(328, true, "重命名成功");
		} catch (Exception e) {
			return new Result<>(323, false, "重命名失败");
		}
	}
}
