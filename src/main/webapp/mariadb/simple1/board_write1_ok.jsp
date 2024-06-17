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

		String subject = request.getParameter("subject");
		String writer = request.getParameter("writer");
		//String mail1 = request.getParameter("mail1");
		//String mail2 = request.getParameter("mail2");
		String mail = request.getParameter("mail1") + "@" + request.getParameter("mail2");
		String password = request.getParameter("password");
		String content = request.getParameter("content");
		
		String wip = request.getRemoteAddr(); //클라이언트 ip가져오기
		
		//System.out.println(subject);
		//System.out.println(writer);
		//System.out.println(mail1);
		//System.out.println(mail2);
		//System.out.println(password);
		//System.out.println(content);
		//System.out.println(wip);
		
		
			Connection conn = null;
			PreparedStatement pstmt = null;
			
			int flag = 1;
			try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mariadb2");
		
			conn = dataSource.getConnection();
			String sql = "insert into board1 values(0, ?, ?, ?, password(?), ?,0,?, now() )";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, subject);
			pstmt.setString(2, writer);
			pstmt.setString(3, mail);
			pstmt.setString(4, password);
			pstmt.setString(5, content);
			pstmt.setString(6, wip);
		
			if(pstmt.executeUpdate() == 1){
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
			out.println("alert('글쓰기에 성공');");
			out.println("location.href='./board_list1.jsp';");
		}else{
			//System.out.println("에러");
			out.println("alert('글쓰기에 실패');");
			out.println("history.back()");
		}
		out.println("</script>");
		
		
		
		
		
		
		
%>