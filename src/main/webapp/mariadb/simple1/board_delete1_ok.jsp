<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>



<%
    request.setCharacterEncoding("utf-8");

    String seq = request.getParameter("seq");
    String password = request.getParameter("password");

    String wip = request.getRemoteAddr(); //클라이언트 ip가져오기

    Connection conn = null;
    PreparedStatement pstmt = null;

    // 0 - 정상, 1 - 비밀번호 오류, 2 - 에러
    int flag = 2;
    try {
        Context initCtx = new InitialContext();
        Context envCtx = (Context)initCtx.lookup("java:comp/env");
        DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb2");

        conn = dataSource.getConnection();

        String sql = "delete from board1 where seq=? and password=password(?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, seq);
        pstmt.setString(2, password);

        int result = pstmt.executeUpdate();
        if(result == 0){
            flag = 1;
        }else if (result == 1){
            flag = 0;
        }
    }catch (NamingException e){
        System.out.println("[에러]" + e.getMessage());
    }catch (SQLException e ){
        System.out.println("[에러]" + e.getMessage());
    }finally{
        if(pstmt != null)pstmt.close();
        if(conn != null) conn.close();
    }
    out.println("<script type='text/javascript'>");
    if(flag == 0){
        //System.out.println("정상 입력");
        out.println("alert('글삭제 성공');");
        out.println("location.href='./board_list1.jsp';");
    }else if(flag == 1){
    out.println("alert('비밀번호 오류');");
    out.println("history.back();");
    }
    else{
        out.println("alert('글삭제 실패');");
        out.println("history.back()");
    }
    out.println("</script>");







%>