package cn.allene.yun.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import cn.allene.yun.pojo.FileCustom;
import cn.allene.yun.pojo.Result;
import cn.allene.yun.pojo.summaryFile;
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
			try {
				fileService.uploadFilePath(request, files);
			} catch (Exception e) {
				return new Result<>(301, false, "上传失败");
			}
			return new Result<String>(305, true, "上传成功");
	}

	@RequestMapping("/download")
	public ResponseEntity<byte[]> download(String currentPath, String[] downPath) {
		try {
			File downloadFile = fileService.downPackage(request, currentPath, downPath);
			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
			String fileName = new String(downloadFile.getName().getBytes("utf-8"), "iso-8859-1");
			headers.setContentDispositionFormData("attachment", fileName);
			byte[] fileToByteArray = org.apache.commons.io.FileUtils.readFileToByteArray(downloadFile);
			fileService.deleteDownPackage(downloadFile);
			return new ResponseEntity<byte[]>(fileToByteArray, headers, HttpStatus.CREATED);
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
	//测试test分支pull requst
	//测试test分支pull requst2
	@RequestMapping("/renameDirectory")
	public @ResponseBody Result<String> renameDirectory(String currentPath, String srcName, String destName){
		try {
			fileService.renameDirectory(request, currentPath, srcName, destName);
			return new Result<>(328, true, "重命名成功");
		} catch (Exception e) {
			return new Result<>(323, false, "重命名失败");
		}
	}
	
	@RequestMapping("/moveDirectory")
	public @ResponseBody Result<String> moveDirectory(String currentPath, String[] directoryName, String targetdirectorypath){
		
		try {
			fileService.moveDirectory(request,currentPath, directoryName, targetdirectorypath);
			return new Result<>(326, true, "移动成功");
		} catch (IOException e) {
			return new Result<>(324, true, "移动失败");
		}
	}
	
	@RequestMapping("/summarylist")
	/*如果方法声明了注解@ResponseBody ，则会直接将返回值输出到页面。*/
	public String summarylist(Model model) throws ServletException, IOException{
		String webrootpath = fileService.getFileName(request, "");
		int number = webrootpath.length();
		summaryFile rootlist = fileService.summarylistFile(webrootpath,number);
		model.addAttribute("rootlist", rootlist);
//		request.setAttribute("summarylist", listFile);
//		request.getRequestDispatcher("/WEB-INF/jsp/summarylist.jsp").forward(request, response);
		return "summarylist";
	}
}
