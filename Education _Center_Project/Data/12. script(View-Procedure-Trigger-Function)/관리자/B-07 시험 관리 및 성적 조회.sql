-- B-07. 관리자 시험 관리 및 성적 관리

--====================================================================================================================================
--특정 개설 과정 선택(과정번호)
--특정 개설 과정에 등록된 개설 과목정보(기간, 과목명)  & ( 성적등록여부/ 시험문제파일등록여부) 확인
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procCourseInfo (
    pcourse tblCourse.course_seq%type,
    presult out number
)
is
    
    ssubname tblSubjectName.subname%type;
    ccsstart_date tblCSub.csstart_date%type;
    ccsend_date tblCSub.csend_date%type;
    testyn varchar2(20);
    scoreyn varchar2(20);
    cursor vcursor is
        select
            distinct
            sn.subname as "과목명",
            cs.csstart_date as "과목 시작일",
            cs.csend_date as "과목 종료일",
            case
                when tn.test_type in ('필기', '실기') then 'Y'
                else 'N'
            end as "시험 등록 여부",
            case
                when attend_score is null or pilgi_score is null or silgi_score is null then 'N'
                else 'Y'
            end as "성적 등록 여부"
        from tblCourse c
            inner join tblCourseName cn
                on c.cname_seq = cn.cname_seq
                    inner join tblCSub cs
                        on c.course_seq = cs.course_seq
                            inner join tblSubjectName sn
                                on cs.subname_seq = sn.subname_seq
                                  left outer join tblScore sc
                                        on cs.csub_seq = sc.csub_seq
                                            left outer join tblTestDate td
                                                on cs.csub_seq = td.csub_seq
                                                    left outer join tblTest t
                                                        on td.testnum_seq = t.testnum_seq
                                                            left outer join tblTestName tn
                                                                on t.testname_seq = tn.testname_seq --and tn.subname_seq = cs.subname_seq
            where c.course_seq = pcourse; --1번 혹은 25번
                                                            

begin
    open vcursor;
        dbms_output.put_line('=========================================================================================================================');
        dbms_output.put_line( rpad('과목명', 20, ' ') ||  '|  ' || rpad('과목 시작일', 15, ' ') || '|  ' || rpad('과목 종료일', 15, ' ') || '|  ' || rpad('시험 등록 여부', 15,' ') || '|' || rpad('성적 등록 여부', 15, ' '));
        dbms_output.put_line('=========================================================================================================================');
            
        loop                    
            fetch vcursor into ssubname, ccsstart_date, ccsend_date, testyn, scoreyn;
            exit when vcursor%notfound;                        
            dbms_output.put_line( rpad(ssubname, 20, ' ') || '   ' || rpad(ccsstart_date, 15, ' ') || '    ' || rpad(ccsend_date, 15, ' ') || '       ' || rpad(testyn, 15, ' ') || '  ' || rpad(scoreyn, 15, ' '));            
        end loop;  
        presult := 1;
    close vcursor;      
exception
    when others then
        presult := 0;
    
end procCourseInfo;

--------------------------------------------------------------------------------------------------------------------------------------

declare
    vresult number;
    
begin        
        procCourseInfo(1,vresult);
        
    if vresult = 0 then
        dbms_output.put_line('=========================================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('=========================================================================================================================');
    end if;


end;

--====================================================================================================================================





--====================================================================================================================================
-- 성적 정보 출력시 개설 과목별 출력
-- 1.과정명 과정기간 강의실명 과목명 교사명
-- 2.교재명
-- 3.그 과정의 과목을 수강한 모든 교육생들의 성적 정보
--------------------------------------------------------------------------------------------------------------------------------------


create or replace procedure procCSubInfo (
    pcourse_seq tblCourse.course_seq%type
)
is
    ccourse_name tblCourseName.course_neme%type;
    cc_start_date tblCourse.c_start_date%type;
    cc_end_date tblCourse.c_end_date%type;
    rroom tblRoom.room_name%type;
    ssubname tblSubjectName.subname%type;
    tt_name tblTeacher.t_name%type;
    cursor vcursor is
    select
        distinct
        cn.course_neme,
        c.c_start_date,
        c.c_end_date,
        r.room_name,
        sn.subname,
        t.t_name
    from tblMember m
        inner join tblSugang s
            on m.member_seq = s.member_seq
                inner join tblCourse c
                    on s.course_seq = c.course_seq
                        inner join tblCourseName cn
                            on c.cname_seq = cn.cname_seq
                                inner join tblCSub cs
                                    on c.course_seq = cs.course_seq
                                        inner join tblSubjectName sn
                                            on cs.subname_seq = sn.subname_seq
                                                inner join tblRoom r
                                                    on c.room_seq = r.room_seq
                                                        inner join tblTeacher t
                                                            on c.teacher_seq = t.teacher_seq
            where c.course_seq = 1;
begin
    
    open vcursor;
    
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line( '                     ' || rpad('과정명', 40, ' ') ||  '|  ' || rpad('과정 시작일', 12, ' ') || '|  ' || rpad('과정 종료일', 12, ' ') || '|  ' || rpad('강의실', 6,' ') || '     |  ' || rpad('과목명', 15, ' ')  || '|  ' || rpad('교사명', 15, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into ccourse_name, cc_start_date, cc_end_date, rroom, ssubname, tt_name;
            exit when vcursor%notfound;
            
             dbms_output.put_line( rpad(ccourse_name, 60, ' ') || '   ' || rpad(cc_start_date, 8, ' ') || '       ' || rpad(cc_end_date, 8, ' ') || '        ' || rpad(rroom, 8, ' ') || '   ' || rpad(ssubname, 15, ' ') || '   ' || rpad(tt_name, 10, ' '));
            
        end loop;
    close vcursor;

exception
    when others then
        dbms_output.put_line('==========================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('===========================================================================================================');
    
end procCSubInfo;

--------------------------------------------------------------------------------------------------------------------------------------

begin
    procCSubInfo(1);
end;
--------------------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------------------
--2.교재명
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procCBook (
    pcourse_seq tblCourse.course_seq%type
)
is
    
    ssubname tblSubjectName.subname%type;
    tbname tblTextBook.name%type;
    cursor vcursor is
    select
        sn.subname,
        tb.name
    from tblSubjectName sn
        inner join tblCSub cs
            on sn.subname_seq = cs.subname_seq
                inner join tblCourse c
                    on c.course_seq = cs.course_seq
                        inner join tblSubjectTxt st
                            on sn.subname_seq = st.subname_seq
                                inner join tblTextBook tb
                                    on tb.txtbook_seq = st.txtbook_seq
                        where c.course_seq = 1;

begin
    open vcursor;
        dbms_output.put_line('===================================================================================================================================================');
        dbms_output.put_line(rpad('과목명', 15, ' ') ||  '|                                    ' || rpad('도서명', 12, ' '));
        dbms_output.put_line('===================================================================================================================================================');
        
        loop
            fetch vcursor into ssubname, tbname;
            exit when vcursor%notfound;
            
             dbms_output.put_line( rpad(ssubname, 15, ' ') || '   ' || rpad(tbname, 150, ' '));
            
        end loop;
    close vcursor;

exception
    when others then
        dbms_output.put_line('==========================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('===========================================================================================================');
        
end procCBook;

--------------------------------------------------------------------------------------------------------------------------------------
begin
    procCBook(1);
end;


--------------------------------------------------------------------------------------------------------------------------------------
-- 3. 그 과정의 과목을 수강한 모든 교육생들의 성적 정보
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procSuMemScore (
    pcourse_seq tblCourse.course_seq%type
)
is
    ssugang_seq tblSugang.sugang_seq%type;
    mm_name tblMember.m_name%type;
    ssubname tblSubjectName.subname%type;
    ccsstart_date tblCSub.csstart_date%type;
    ccsend_date tblCSub.csstart_date%type;
    aattend_score tblscore.attend_score%type;
    ppilgi_score tblscore.pilgi_score%type;
    ssilgi_score tblscore.silgi_score%type;
    cursor vcursor is
    select
        distinct
        s.sugang_seq,
        m.m_name,
        sn.subname,
        cs.csstart_date,
        cs.csend_date,
        sc.attend_score,
        sc.pilgi_score,
        sc.silgi_score
    from tblMember m
        inner join tblSugang s
            on m.member_seq = s.member_seq
                inner join tblCourse c
                    on s.course_seq = c.course_seq
                        inner join tblCourseName cn
                            on c.cname_seq = cn.cname_seq
                                inner join tblCSub cs
                                    on c.course_seq = cs.course_seq
                                        inner join tblSubjectName sn
                                            on cs.subname_seq = sn.subname_seq
                                                inner join tblRoom r
                                                    on c.room_seq = r.room_seq
                                                        inner join tblTeacher t
                                                            on c.teacher_seq = t.teacher_seq
                                                                inner join tblScore sc
                                                                    on sc.csub_seq = cs.csub_seq and s.sugang_seq = sc.sugang_seq
            where c.course_seq = 1
                order by s.sugang_seq;
begin
    open vcursor;
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line(rpad('수강번호', 8, ' ') ||  '|  ' || rpad('학생명', 10, ' ') || '|  ' || rpad('과목이름', 20, ' ') || '|  ' || rpad('과목 시작일', 11,' ') || '     |  ' || rpad('과목 종료일', 13, ' ')  || '|  ' || rpad('출석점수', 8, ' ') || ' |' || rpad('필기점수', 8, ' ') || ' | ' || rpad('실기점수', 8, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into ssugang_seq, mm_name, ssubname, ccsstart_date, ccsend_date, aattend_score, ppilgi_score, ssilgi_score;
            exit when vcursor%notfound;
            
            dbms_output.put_line(rpad(ssugang_seq, 5, ' ') || '     ' || rpad(mm_name, 10, ' ') || '    '||rpad(ssubname, 20, ' ') || '     ' ||rpad(ccsstart_date, 10, ' ') || '       ' || rpad(ccsend_date, 13, ' ') || '      ' || rpad(aattend_score, 5, ' ') || '     ' || rpad(ppilgi_score, 5, ' ') || '    ' || rpad(ssilgi_score, 5, ' '));
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('==============================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('==============================================================================================================');    
end procSuMemScore;


--------------------------------------------------------------------------------------------------------------------------------------

begin
    procSuMemScore(1);
end;

--------------------------------------------------------------------------------------------------------------------------------------
-- 4. 다 합친 최종 (성적 정보 출력시 개설 과목별 출력)
create or replace procedure procCSubScore (
    pcourse tblCourse.course_seq%type
)
is
begin

    procCSubInfo(pcourse);
    dbms_output.put_line(' ');
    procCBook(pcourse);
    dbms_output.put_line(' ');
    procSuMemScore(pcourse);
   
end procCSubScore;

--------------------------------------------------------------------------------------------------------------------------------------

begin
    procCSubScore(1);
end;
--====================================================================================================================================








--====================================================================================================================================
-- 성적 정보 출력시 개설 과목별 출력
-- 1.과정명 과정기간 강의실명 과목명 교사명
-- 2.교재명
-- 3.그 과정의 과목을 수강한 모든 교육생들의 성적 정보
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procSubScore (
    psugang_seq tblSugang.sugang_seq%type
)
is
    ssubname tblSubjectName.subname%type;
    ccstart_date tblCSub.csstart_date%type;
    ccsend_date tblCSub.csend_date%type;
    aattend_score tblScore.attend_score%type;
    ppilgi_score tblScore.pilgi_score%type;
    ssilgi_score tblScore.silgi_score%type;        
    cursor vcursor is
    select
        distinct
        sn.subname as "개설과목명",
        cs.csstart_date as "개설 과목 시작",
        cs.csend_date as "개설 과목 종료",
        sc.attend_score as "출석 점수",
        sc.pilgi_score as "필기 점수",
        sc.silgi_score as "실기 점수"
    from tblMember m
        inner join tblSugang s
            on m.member_seq = s.member_seq
                inner join tblCourse c
                    on c.course_seq = s.course_seq
                        inner join tblCSub cs
                            on c.course_seq = cs.course_seq
                                inner join tblScore sc
                                    on cs.csub_seq = sc.csub_seq and sc.sugang_seq = s.sugang_seq
                                        inner join tblSubjectName sn
                                            on cs.subname_seq = sn.subname_seq
        where s.sugang_seq = psugang_seq
            order by sn.subname;
                                                    
begin
    
    open vcursor;
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line(rpad('과목이름', 20, ' ') || '|   ' || rpad('과목 시작일', 11,' ') || ' |  ' || rpad('과목 종료일', 13, ' ')  || '|  ' || rpad('출석점수', 8, ' ') || ' |' || rpad('필기점수', 8, ' ') || ' | ' || rpad('실기점수', 8, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into ssubname, ccstart_date, ccsend_date, aattend_score, ppilgi_score, ssilgi_score;
            exit when vcursor%notfound;
            
            dbms_output.put_line(rpad(ssubname, 20, ' ') || '     ' || rpad(ccstart_date, 10, ' ') || '     '||rpad(ccsend_date, 10, ' ') || '        ' ||rpad(aattend_score, 5, ' ') || '       ' || rpad(ppilgi_score, 5, ' ') || '      ' || rpad(ssilgi_score, 5, ' '));
            
        end loop;
    close vcursor;
        
    
end procSubScore;

--------------------------------------------------------------------------------------------------------------------------------------

begin
    procSubScore(1);
end;




















select
    distinct
    sn.subname as "개설과목명",
    cs.csstart_date as "개설 과목 시작",
    cs.csend_date as "개설 과목 종료",
    sc.attend_score as "출석 점수",
    sc.pilgi_score as "필기 점수",
    sc.silgi_score as "실기 점수"
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on c.course_seq = s.course_seq
                    inner join tblCSub cs
                        on c.course_seq = cs.course_seq
                            inner join tblScore sc
                                on cs.csub_seq = sc.csub_seq and sc.sugang_seq = s.sugang_seq
                                    inner join tblSubjectName sn
                                        on cs.subname_seq = sn.subname_seq
                                            where s.sugang_seq = 1
                                                order by sn.subname;

