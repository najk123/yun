package cn.allene.yun.dao;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface OfficeDao {
	void addOffice(@Param("officeId") String officeId, @Param("officePath") String officePath) throws Exception;
	
	String getOfficeId(String officePath) throws Exception;
}
