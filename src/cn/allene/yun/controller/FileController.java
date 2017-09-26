package cn.allene.yun.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
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
import cn.allene.yun.pojo.User;
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
				fileService.uploadFilePath(request, files, currentPath);
			} catch (Exception e) {
				return new Result<>(301, false, "上传失败");
			}
			return new Result<String>(305, true, "上传成功");
	}

	@RequestMapping("/download")
	public ResponseEntity<byte[]> download(String currentPath, String[] downPath, String username) {
		try {
			String down = request.getParameter("downPath");
			File downloadFile = fileService.downPackage(request, currentPath, downPath, username);
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
	@RequestMapping("/getFilesByCategory")
	public @ResponseBody Result<List<FileCustom>> getFilesByCategory(String category) {
		String realPath = fileService.getFileName(request, category);
		List<FileCustom> listFile = fileService.listFile(realPath);
		Result<List<FileCustom>> result = new Result<List<FileCustom>>(325, true, "获取成功");
		result.setData(listFile);
		return result;
	} 
	@RequestMapping("/getShareFiles")
	public @ResponseBody Result<List<FileCustom>> getFiles(String path, String username) {
		String realPath = fileService.getFileName(request, path, username);
		List<FileCustom> listFile = fileService.listFile(realPath);
		Result<List<FileCustom>> result = new Result<List<FileCustom>>(326, true, "获取成功");
		result.setData(listFile);
		return result;
	}
	@RequestMapping("/addDirectory")
	public @ResponseBody Result<String> addDirectory(String currentPath, String directoryName){
		try {
			fileService.addDirectory(request, currentPath, directoryName);
			return new Result<>(336, true, "添加成功");
		} catch (Exception e) {
			return new Result<>(331, false, "添加失败");
		}
	}
	
	@RequestMapping("/delDirectory")
	public @ResponseBody Result<String> delDirectory(String currentPath, String[] directoryName){
		try {
			fileService.delDirectory(request, currentPath, directoryName);
			return new Result<>(346, true, "删除成功");
		} catch (Exception e) {
			return new Result<>(341, false, "删除失败");
		}
	}
	//测试test分支pull requst
	//测试test分支pull requst2
	@RequestMapping("/renameDirectory")
	public @ResponseBody Result<String> renameDirectory(String currentPath, String srcName, String destName){
		try {
			fileService.renameDirectory(request, currentPath, srcName, destName);
			return new Result<>(356, true, "重命名成功");
		} catch (Exception e) {
			return new Result<>(351, false, "重命名失败");
		}
	}
	
	@RequestMapping("/moveDirectory")
	public @ResponseBody Result<String> moveDirectory(String currentPath, String[] directoryName, String targetdirectorypath) throws Exception{
		
		try {
			fileService.moveDirectory(request,currentPath, directoryName, targetdirectorypath);
			return new Result<>(366, true, "移动成功");
		} catch (IOException e) {
			return new Result<>(361, true, "移动失败");
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
	
	@RequestMapping("/searchFile")
	public @ResponseBody Result<List<FileCustom>> searchFile(String reg, String currentPath, String regType){
		try{
			List<FileCustom> searchFile = fileService.searchFile(request, currentPath, reg, regType);
			Result<List<FileCustom>> result = new Result<>(376, true, "查找成功");
			result.setData(searchFile);
			return result;
		}catch (Exception e) {
			e.printStackTrace();
			return new Result<>(371, false, "查找失败");
		}
	}
	@RequestMapping("/openFile")
	public void openFile(HttpServletResponse response,String currentPath, String fileName, String type){
		try {
			fileService.respFile(response, request, currentPath, fileName, type);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/*--存储回收站所有删除文件信息，并返回给recycle.jsp--*/
	@RequestMapping("/recycleFile")
	public String recycleFile(){
		try{
		List<FileCustom> findDelFile = fileService.recycleFile(request);
		request.setAttribute("findDelFile", findDelFile);
		}catch(Exception e){
			e.printStackTrace();
		}
		return "recycle";
	}
	
	/* --删除回收站文件--
	 * --获取当前路径以及文件名--*/
	@RequestMapping("/delRecycleDirectory")
	public @ResponseBody Result<String> delRecycleDirectory(String currentPath,String[] directoryName){
		try {
			fileService.delRecycleDirectory(request, currentPath,directoryName);
			return new Result<>(327, true, "删除成功");
		} catch (Exception e) {
			return new Result<>(322, false, "删除失败");
		}
	}
	
	/* --还原回收站文件--
	 * --获取目的路径以及文件名--*/
	@RequestMapping("/revertDirectory")
	public @ResponseBody Result<String> revertDirectory(String[] directoryName, String targetdirectorypath){
		try {
			fileService.moveDirectory(request,User.RECYCLE,directoryName,targetdirectorypath);
			return new Result<>(327, true, "还原成功");
		} catch (Exception e) {
			return new Result<>(322, false, "还原失败");
		}
	}
}
