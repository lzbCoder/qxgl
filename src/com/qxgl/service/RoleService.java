package com.qxgl.service;

import com.qxgl.dao.RoleDao;
import com.qxgl.domain.Page;
import com.qxgl.domain.Role;

import java.util.List;

public class RoleService {

    /**
     * 单例模式
     */
    private RoleService(){}
    private static RoleService service = new RoleService();
    public static RoleService getService(){
        return service;
    }
    //属性
    private RoleDao dao = RoleDao.getDao();

    public Page list(Integer page,Integer rows){
        //要查找page页的rows条数据，需要确保page页面是一个正确的页码
        //page >= 1 && page <= max
        if(page < 1){
            page = 1;
        }
        // max = total/rows
        long total = dao.total();
        int max = 1;
        if(total != 0){
            max = (int) (total%rows==0?total/rows : (total/rows)+1);
        }
        if(page > max){
            page = max;
        }
        //mysql的分页语句需要的是start和length
        int start = (page-1)*rows;
        int length = rows;
        List<Role> list = dao.find(start,length);
        Page p = new Page(list,max,page);
        return p;
    }

    public List<Role> list(){
        return dao.findAll();
    }

    public void setFns(Integer rid , String[] fidArray){
        //先删除之前分配的关系
        dao.deleteRelationship(rid);
        //循环保存新的关系
        for(String fid:fidArray){
            dao.addRelationship(rid,new Integer(fid));
        }
    }

    public List<Integer> findFidsByRole(Integer rid){
        return dao.findFidsByRole(rid);
    }

}
