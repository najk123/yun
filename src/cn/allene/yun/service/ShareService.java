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
import cn.allene.yun.utils.FileUtils;

@Service
public class ShareService {
	@Autowired
	private ShareDao shareDao;
	
	public List<ShareFile> findShare(HttpServletRequest request, String shareUrl) throws Exception{
		List<Share> shares = shareDao.findShare(shareUrl);
		List<ShareFile> files = null;
		if(shares != null){
			files = new ArrayList<>();
			String rootPath = request.getSession().getServletContext().getRealPath("/") + FileService.PREFIX;
			for (Share share : shares) {
				File file = new File(rootPath + share.getShareUser(), share.getPath());
				ShareFile shareFile = new ShareFile();
				shareFile.setFile(file.isFile());
				shareFile.setFileName(file.getName());
				shareFile.setFileSize(FileUtils.getDataSize(file.length()));
				shareFile.setLastTime(FileUtils.formatTime(file.lastModified()));
				shareFile.setPath(share.getPath());
				shareFile.setShareUser(share.getShareUser());
				files.add(shareFile);
			}
		}
		return files;
	}

	public String shareFile(HttpServletRequest request, String currentPath, String[] shareFile) throws Exception {
		String username = (String) request.getSession().getAttribute(FileService.NAMESPACE);
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
