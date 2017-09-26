package cn.allene.yun.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import cn.allene.yun.pojo.Share;

@Repository
public interface ShareDao {
	List<Share> findShare(String shareUrl) throws Exception;

	void shareFile(Share share) throws Exception;

}
