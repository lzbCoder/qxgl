package com.qxgl.comm;

import com.qxgl.domain.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 登录认证的过滤器
 * is-a Filter
 */

@WebFilter({"*.do","*.jsp"})
public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        //每次请求目标前，会先调用该方法。
        //所以在该方法编写需要在目标前执行的功能。
        //需要登录认证

        HttpServletRequest request = (HttpServletRequest)servletRequest;
        HttpServletResponse response = (HttpServletResponse)servletResponse;
        //先排除登录相关的请求 + 注销相关
        String uri = request.getRequestURI() ;// /main.jsp
        //String url = request.getRequestURL().toString() ;// http://localhost:8080/main.jsp
        String method = request.getParameter("method") ;
        if(
                "/".equals(uri) ||
                uri.indexOf("index.jsp") != -1 ||  //url中包含index.jsp，请求登录页面
                uri.indexOf("UserAction.do") != -1 && "login".equals(method) || //请求登录验证
                uri.indexOf("UserAction.do") != -1 && "exit".equals(method) || //请求注销
                uri.indexOf("timeout.jsp") != -1   //认证失败后访问的提示页面
        ){
            //此次请求不需要登录认证，继续完成后续操作
            filterChain.doFilter(request,response);//继续调用目标方法
            return ;
        }

        //如果上述判断没有成立，证明是一个需要登录认证的请求
        //再判断session中是否装有登录成功的用户信息
        User user = (User) request.getSession().getAttribute("loginUser");
        if(user == null){
            //session中没有数据，表示没有登录或登录超时 ： 提示： 未登录或会话超时，请重新登录。
            response.sendRedirect("timeout.jsp");
        }else{
            //session中有数据，可以继续访问
            filterChain.doFilter(request,response);
        }
    }

    @Override
    public void destroy() {

    }
}
