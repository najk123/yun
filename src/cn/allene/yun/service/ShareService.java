package cn.allene.yun.service;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.allene.yun.dao.ShareDao;
import cn.allene.yun.pojo.FileCustom;
import cn.allene.yun.pojo.Share;
import cn.allene.yun.pojo.ShareFile;
import cn.allene.yun.pojo.User;
import cn.allene.yun.utils.FileUtils;
import cn.allene.yun.utils.UserUtils;

@Service
public class ShareService {
	@Autowired
	private ShareDao shareDao;
	
	public List<ShareFile> findShare(HttpServletRequest request, String shareUrl) throws Exception{
		Share share = new Share();
		share.setShareUrl(shareUrl);
		share.setStatus(Share.PUBLIC);
		List<Share> shares = shareDao.findShare(share);
		return getShareFile(request, shares);
	}

	public List<ShareFile> findShareByName(HttpServletRequest request, int status) throws Exception{
		List<Share> shares = shareDao.findShareByName(UserUtils.getUsername(request), status);
		return getShareFile(request, shares);
	}
	
	private List<ShareFile> getShareFile(HttpServletRequest request, List<Share> shares){
		List<ShareFile> files = null;
		if(shares != null){
			files = new ArrayList<>();
			String rootPath = request.getSession().getServletContext().getRealPath("/") + FileService.PREFIX;
			for (Share share : shares) {
				File file = new File(rootPath + share.getShareUser(), share.getPath());
				ShareFile shareFile = new ShareFile();
				shareFile.setFileType(FileUtils.getFileType(file));
				shareFile.setFileName(file.getName());
				shareFile.setFileSize(file.isFile() ? FileUtils.getDataSize(file.length()) : "-");
				shareFile.setLastTime(FileUtils.formatTime(file.lastModified()));
				shareFile.setPath(share.getPath());
				shareFile.setShareUser(share.getShareUser());
				shareFile.setUrl(share.getShareUrl());
				files.add(shareFile);
			}
		}
		return files;
	}
	public String shareFile(HttpServletRequest request, String currentPath, String[] shareFile) throws Exception {
		String username = (String) request.getSession().getAttribute(User.NAMESPACE);
		String shareUrl = FileUtils.getUrl8();
		for (String file : shareFile) {
			Share share = new Share();
			share.setPath(currentPath + File.separator + file);
			share.setShareUser(username);
			share.setShareUrl(shareUrl);
			shareDao.shareFile(share);
		}
		return shareUrl;
	}
}
