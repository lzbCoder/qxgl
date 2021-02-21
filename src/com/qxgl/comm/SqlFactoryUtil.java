package com.qxgl.comm;

import jdbc.JdbcFactory;
import jdbc.SqlSession;

/**
 * 单实例管理工厂
 */
public class SqlFactoryUtil {

    private static JdbcFactory factory;
    static {
        factory = new JdbcFactory("mysql.properties");
    }
    public static JdbcFactory getFactory(){
        return factory;
    }

    public static SqlSession getSession(){
        return factory.getSession();
    }
}
