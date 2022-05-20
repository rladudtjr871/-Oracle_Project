
-- C-03교사_배점입출력.sql - pl sql

-- 교사 로그인(테스트 교사)
select * from tblTeacher where t_password = 2142021;

-- 배점 입력해야 하는 과목 정보 출력
-- 과목번호/과정명/과정시작일/과정종료일/강의실/과목명/과목시작일/과목종료일/교재명/출결/필기배점/실기배점
create or replace procedure procViewSubtPoint(

    -- 패스워드 입력
    ppw in tblteacher.t_password%type

)
is
    cscsub_seq tblcsub.csub_seq%type;
    cc_start_date tblcourse.c_start_date%type;
    cc_end_date tblcourse.c_end_date%type;
    rroom_name tblroom.room_name%type;
    snsubname tblsubjectname.subname%type;
    cscsstart_date tblcsub.csstart_date%type;
    cscsend_date tblcsub.csend_date%type;
    spattend_point tblsubtpoint.attend_point%type;
    sppilgi_point tblsubtpoint.pilgi_point%type;
    spsilgi_point tblsubtpoint.silgi_point%type;
    
    vstart_date date;
    vend_date date;
    
cursor vcursor 
    is
select 
    cs.csub_seq as 과목번호,
    c.c_start_date as 과정시작일,
    c.c_end_date as 과정종료일,
    r.room_name as 강의실,
    sn.subname as 과목명,
    cs.csstart_date as 과목시작일,
    cs.csend_date as 과목종료일,
    sp.attend_point as 출결배점,
    sp.pilgi_point as 필기배점,
    sp.silgi_point as 실기배점
from tblCourse c
    inner join tblRoom r
    on c.room_seq = r.room_seq
    inner join tblCourseName cn
    on c.cname_seq = cn.cname_seq
    inner join tblCSub cs
    on c.course_seq = cs.course_seq
    inner join tblSubjectName sn
    on cs.subname_seq = sn.subname_seq
    left outer join tblSubtPoint sp
    on cs.csub_seq = sp.csub_seq
where cs.csend_date < sysdate and sysdate < c.c_end_date and c.teacher_seq = (select teacher_seq from tblTeacher where t_password = ppw)
    order by cs.csstart_date;

begin
     
     open vcursor; 
     
     dbms_output.put_line('================================================================================================================================================='); 
     dbms_output.put_line(rpad('과목번호', 10, ' ') || rpad('강의실', 10, ' ')|| rpad('과정시작일', 15, ' ') || rpad('과정종료일', 15, ' ') || rpad('과목명', 30, ' ') || rpad('과목시작일', 15, ' ') || rpad('과목종료일', 15, ' ')||rpad('출결배점', 12, ' ') || rpad('필기배점', 12, ' ') || rpad('실기배점', 12, ' '));
     dbms_output.put_line('================================================================================================================================================='); 
        loop
            fetch vcursor into  cscsub_seq, cc_start_date, cc_end_date, rroom_name, snsubname, cscsstart_date , cscsend_date ,  spattend_point ,  sppilgi_point ,  spsilgi_point ;
            exit when vcursor%notfound;
            
                dbms_output.put_line(rpad(cscsub_seq, 10, ' ') || rpad(rroom_name, 10, ' ') || rpad(cc_start_date, 15, ' ') || rpad(cc_end_date, 15, ' ') || rpad(snsubname, 30, ' ') || rpad(cscsstart_date, 15, ' ') || rpad(cscsend_date, 15, ' ') ||  rpad(spattend_point, 12, ' ') ||  rpad(sppilgi_point, 12, ' ') ||  rpad(spsilgi_point, 12, ' '));
        end loop;
    dbms_output.put_line('=================================================================================================================================================='); 
    close vcursor;

end;


begin
    procViewSubtPoint(2142021);
end;


-- 특정 과목 선택 배점 입력
-- 배점 입력
create or replace procedure procSubtPoint(
    
     -- 패스워드 입력
    ppw in tblteacher.t_password%type,
    
    -- 배점 점수
    pattend_point in tblsubtpoint.attend_point%type,
    ppilgi_point in tblsubtpoint.pilgi_point%type,
    psilgi_point in tblsubtpoint.silgi_point%type,
    
    -- 과목 선택
    pcsub_seq in tblsubtpoint.csub_seq%type,
    
    -- 실행 결과
    presult out number
)
is
    vteacher_seq number;
    vsum number;
begin
    select teacher_seq into vteacher_seq from tblteacher where t_password= ppw;
    
    vsum := pattend_point + ppilgi_point + psilgi_point;
       
    if(vsum = 100) and (pattend_point >= 20) then
        insert into tblSubtPoint (subpoint_seq, attend_point, pilgi_point, silgi_point, teacher_seq, csub_seq) 
            values ((select max(subpoint_seq)+1 from tblSubtPoint), pattend_point, ppilgi_point, psilgi_point, vteacher_seq, pcsub_seq);
        presult := 1;
    elsif pattend_point is null or ppilgi_point is null or psilgi_point is null then
        presult := 2;    
    end if;

exception
    when others then
        presult := 0;
end procSubtPoint;

-- 배점 입력 insert
declare
    vresult number;
begin
    procSubtPoint(20, 30, 50, 152, 2142021, vresult);
    if(vresult = 1) then
        dbms_output.put_line('배점 입력에 성공했습니다.');
    else 
        dbms_output.put_line('배점 입력에 실패했습니다.');
    end if;
end;



-- 문제 입력
--...







