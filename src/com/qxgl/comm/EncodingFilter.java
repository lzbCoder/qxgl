package com.qxgl.comm;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter("*.do")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        //每次目标前执行的方法
        //编写具体的功能
        //想实现中文编码处理
        servletRequest.setCharacterEncoding("utf-8");
        //响应时的中文编码
        servletResponse.setContentType("text/html;charset=utf-8");
        servletResponse.setCharacterEncoding("utf-8");
        filterChain.doFilter(servletRequest,servletResponse);//使用了责任链模式，相当于调用目标
    }

    @Override
    public void destroy() {

    }
}
