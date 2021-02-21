package com.qxgl.dao;

import com.qxgl.domain.Fn;
import jdbc.annocations.Insert;
import jdbc.annocations.Select;

import java.util.List;

public interface FnDao {

    @Select("select * from t_fn where del = 1")
    public List<Fn> findAll();

    @Insert("insert into t_fn values(null,#{fname},#{fhref},#{flag},#{pid},1,now(),#{yl1},#{yl2})")
    public void save(Fn fn);

    //1.select rid from t_user_role where uid = #{uid}
    //2.select fid from t_role_fn where rid in ( select rid from t_user_role where uid = #{uid} )
    @Select("select * from t_fn where flag = 1 and fid in ( select fid from t_role_fn where rid in ( select rid from t_user_role where uid = #{uid} ) ) ")
    public List<Fn> findMenuFnByUser(Integer uid);

    @Select("select * from t_fn where flag = 2 and fid in ( select fid from t_role_fn where rid in ( select rid from t_user_role where uid = #{uid} ) ) ")
    public List<Fn> findButtonFnByUser(Integer uid);
}
