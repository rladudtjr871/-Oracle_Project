--D_00 로그인 성공화면(PL)


-- 1. 로그인  > 수강번호 받아오는 프로시저
--      이름과 주민번호, 수강번호로 로그인
create or replace procedure procStuLogin(
    pname tblMember.m_name%type,
    ppw number,
    psugnag_seq number,
    presult out number
)
is
    vsugang_seq number;
    
begin
    select 
        s.sugang_seq
    into
        vsugang_seq
        
    from tblsugang s 
        inner join tblMember m on s.member_seq = m.member_seq 
            where m.m_name = pname and m.m_password = ppw and s.sugang_seq = psugnag_seq ; 
    
    presult := vsugang_seq;
    
exception 
    when others then 
        presult := 0;
    
end procStuLogin;
/





--=============================================================================================
-- 로그인 성공화면 > 수강번호를 받아와서 만드는 화면 

create or replace procedure procStuLoginPrint(
    pseq number -- 학생번호 입력
)
is
  vname tblMember.m_name%type; -- 이름
  vtel tblMember.m_tel%type; -- 전화번호
  vregistdate tblMember.m_registdate%type; -- 등록일자
  vcoursenum number; --과정번호
  vcoursename tblCoursename.course_neme%type; -- 과정명
  vstartdate date; -- 과정시작일
  vendate date; -- 과정종료일
  vroom_name tblRoom.room_name%type; -- 강의실
  vt_name tblTeacher.t_name%type; -- 강사명 
  vreturn number;

begin
    
    select 
        m.m_name , 
        m.m_tel , 
        m.m_registdate ,
        cn.cname_seq,
        cn.course_neme ,
        c.c_start_date,
        c.c_end_date,
        r.room_name,
        t.t_name
    
    into 
        vname, vtel, vregistdate, vcoursenum, vcoursename, vstartdate, vendate, vroom_name, vt_name
    
    from tblMember m 
        inner join tblSugang s on m.member_seq = s.member_seq
            inner join tblCourse c on s.course_seq = c.course_seq
                    inner join tblRoom r on c.room_seq = r.room_seq
                            inner join tblCourseName cn on c.cname_seq = cn.cname_seq
                                    inner join tblTeacher t on c.teacher_seq = t.teacher_seq
                                         where s.sugang_seq = pseq; 
                                            
    
    dbms_output.put_line('===========로그인 성공=============');
    dbms_output.put_line('');
    dbms_output.put_line('이름     : ' || vname);
    dbms_output.put_line('전화번호 : '  || vtel);
    dbms_output.put_line('등록일자 : ' || vregistdate);
    dbms_output.put_line('과정번호 : ' || vcoursenum);
    dbms_output.put_line('과정명   : ' || vcoursename);
    dbms_output.put_line('과정기간 : ' || vstartdate || ' ~ ' || vendate);
    dbms_output.put_line('강의실   : ' || vroom_name);
    dbms_output.put_line('강사명   : '  || vt_name);
    

end;
/

set serverout on;




=====================================================
-- 로그인 분기 

create or replace  procedure pStuLogin (
    pname tblMember.m_name%type,
    ppw number,
    psugnag_seq number
)
is
    vresult number;
begin

    procStuLogin(pname, ppw, psugnag_seq, vresult);
    
    if vresult = 0 then 
        dbms_output.put_line('< 로그인 실패 >');
    else
       procStuLoginPrint(vresult);
    end if;

end;
/

----------------------------------------------------------------

set serverout on;
--최종 실행코드

begin
    pStuLogin('서민지', 1129286, 181);
end;
/
    
select * from tblMember where member_seq = 181;
