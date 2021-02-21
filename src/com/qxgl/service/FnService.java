package com.qxgl.service;

import com.qxgl.comm.SqlFactoryUtil;
import com.qxgl.dao.FnDao;
import com.qxgl.domain.Fn;

import java.util.ArrayList;
import java.util.List;

public class FnService {

    //单例模式(饿汉式)
    private FnService(){};
    private static FnService service = new FnService();
    public static FnService getService(){
        return service;
    }

    //dao层属性
    private FnDao dao = SqlFactoryUtil.getSession().createDaoImpl(FnDao.class);

    public List<Fn> findAll(){
        List<Fn> list = dao.findAll();
        /*
           分析1：
             首先从数据库中查询出来的功能信息，每条是独立存在的，
             但是按照功能管理分析，这些数据之间是存在父子关系的，
             需要将查找出来的所有数据进行解析，将其按照父子关系重新摆放(重置数据结构)。
           分析2：
             首先需要在所有的菜单中找到根菜单-->也就是找pid=-1的菜单，
             然后再从所有的菜单中找当前根菜单的子菜单-->也就是找pid=根菜单fid的菜单。
           分析3：
             根据pid找第一波菜单(根菜单)，再根据另一个pid找第二波菜单(子菜单)，
             找第二波菜单和找第一波菜单是一样的事。
             因此，使用递归实现(方法自身调用)
             注意：不能使用循环，原因：
                  循环的每次操作都是独立的，并且第一次结束后，才循环第二次；而这个
                  菜单组装的操作是第一次循环只找到了父菜单的基本信息，父菜单并没有
                  结束，还需要找子菜单，只有子菜单找完了，父级菜单才算组装完事。
         */
        List<Fn> newFn = loadFn(list,-1);
        return newFn;
    }

    /*
      重新组装fn
      传入一组原始数据(零散，未组装)
      传入一个查询条件
      返回一组新数据(组装后)
     */
    private List<Fn> loadFn(List<Fn> source,Integer pid){
        List<Fn> target = new ArrayList<Fn>();
        for(Fn fn : source){
            if(fn.getPid().equals(pid)){
                //找到一个符合条件的功能，将其添加到target中
                target.add(fn);
                //但这个fn信息不全，只有自身的信息，没有子信息，
                //还需要fn的子信息，pid=fn.fid的菜单就是fn的子信息
                //所以需要一fid作为pid条件，在source中寻找对应的数据
                //找到当前fn的子菜单，其子菜单的pid=fn.fid
                List<Fn> children = loadFn(source,fn.getFid());
                fn.setChildren(children);
            }
        }
        return target;
    }

    public void save(Fn fn){
        dao.save(fn);
    }

}
