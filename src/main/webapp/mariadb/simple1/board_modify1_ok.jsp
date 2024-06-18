<%--
  Created by IntelliJ IDEA.
  User: jhta
  Date: 2024-06-17
  Time: 오전 10:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%
    request.setCharacterEncoding("utf-8");

//데이터 받고
    String seq = request.getParameter("seq");
    String subject = request.getParameter("subject");
    String mail = request.getParameter("mail1" ) + "@" + request.getParameter("mail2");
    String password = request.getParameter("password");
    String content = request.getParameter("content");

    /* System.out.println(subject);
    System.out.println(writer);
    System.out.println(mail1);
    System.out.println(mail2);
    System.out.println(password);
    System.out.println(content);
    System.out.println(wip); */

    Connection conn = null;
    PreparedStatement pstmt = null;

    //
    int flag = 2;
    try {
        Context initCtx = new InitialContext();
        Context envCtx = (Context)initCtx.lookup("java:comp/env");
        DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb2");

        conn = dataSource.getConnection();

        String sql = "update board1 set subject =  ?, mail=?, content=? where seq=? and password = password(?)";
        pstmt = conn.prepareStatement(sql);

        pstmt.setString(1, subject );
        pstmt.setString(2, mail);
        pstmt.setString(3, content );
        pstmt.setString(4, seq );
        pstmt.setString(5, password );

        int result = pstmt.executeUpdate();

        if(result == 0) {
            flag = 1;
        } else if (result == 1) {
            flag = 0;
        }

    } catch(NamingException e ) {
        System.out.println("에러 : " + e.getMessage());
    }catch(SQLException e ) {
        System.out.println("에러 : " + e.getMessage());
    }finally{
        if(pstmt != null)pstmt.close();
        if(conn != null)conn.close();
    }
    out.println("<script type = 'text/javascript'>");
    if (flag == 0 ) {
        //System.out.println("정상 입력");
        out.println("alert('글수정 성공');");
        out.println("location.href = './board_view1.jsp?seq=" + seq + "';");
    } else if (flag == 1) {
        out.println("alert('비밀번호 오류');");
        out.println("history.back();");
    } else {
        out.println("alert('글수정 실패');");
        out.println("history.back();");
    }
    out.println("</script>");
%>
<html>
<head>
    <title>Title</title>
</head>
<body>

</body>
</html>
