-- B-07. 관리자 시험 관리 및 성적 관리
set serverout on;
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
            where c.course_seq = pcourse
                order by cs.csstart_date asc; -- 1번 혹은 25번
                                                            

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
/
--------------------------------------------------------------------------------------------------------------------------------------

declare
    vresult number;
    
begin        
        procCourseInfo(25,vresult);
        
    if vresult = 0 then
        dbms_output.put_line('=========================================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('=========================================================================================================================');
    end if;


end;
/
--====================================================================================================================================





------------------------------------------------------------------------------------
-- 성적 정보 출력시 개설 과목별 출력 
------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- 1.1 개설과정명, 개설과정시작일, 개설과정종료일, 과목명, 강의실명, 강의실명, 교사명
--------------------------------------------------------------------------------------

create or replace procedure procCSubInfo (
    pcsub_seq tblCsub.csub_seq%type     -- 개설 과목 별
)
is
    ccourse_name tblCourseName.course_neme%type;    -- 개설과정명
    cc_start_date tblCourse.c_start_date%type;      -- 개설과정시작일
    cc_end_date tblCourse.c_end_date%type;          -- 개설과정종료일
    snsubname tblsubjectname.subname%type;          -- 과목명
    rroom tblRoom.room_name%type;                   -- 강의실명
    tt_name tblTeacher.t_name%type;                 -- 교사명
    cursor vcursor is
    select
        distinct
        cn.course_neme,     -- 개설과정명
        c.c_start_date,     -- 개설과정시작일
        c.c_end_date,       -- 개설과정종료일
        sn.subname,         -- 과목명
        r.room_name,        -- 강의실명
        t.t_name            -- 교사명
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
            where sn.subname_seq = pcsub_seq;
begin
    
    open vcursor;
    
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line('          ' || rpad('개설 과정명', 27, ' ') || '|  ' || rpad('개설 과정 시작일', 18, ' ') || '|  ' || rpad('개설 과정 종료일', 18, ' ') || '|' || rpad('개설 과목명', 12, ' ') || '|' || rpad('강의실명', 8,' ') || '|' || rpad('교사명', 10, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into ccourse_name, cc_start_date, cc_end_date, snsubname, rroom, tt_name;
            exit when vcursor%notfound;
            
             dbms_output.put_line(rpad(ccourse_name, 32, ' ') || '...' || '  |' || '    ' || rpad(cc_start_date, 18, ' ') || '    ' || '|' || rpad(cc_end_date, 18, ' ') || rpad(snsubname, 12, ' ') || '|  ' ||  '        ' || rpad(rroom, 8, ' ') || '   ' || '   ' || rpad(tt_name, 10, ' '));
            
        end loop;
    close vcursor;

exception
    when others then
        dbms_output.put_line('==========================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('===========================================================================================================');
    
end procCSubInfo;
/

--------------------------------------------------------------------------------------

begin
    procCSubInfo(1);
end;
/

--------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------
-- 1-2. 교재명
--------------------------------------------------------------------------------------

create or replace procedure procCBook (
    pcsub_seq tblCsub.csub_seq%type     -- 개설 과목 별
)
is
    snsubname tblsubjectname.subname%type;      -- 과목명
    tbname tblTextBook.name%type;               -- 교재명
    cursor vcursor is
    select
        distinct
        sn.subname,                             -- 과목명
        tb.name                                 -- 교재명
    from tblSubjectName sn
        inner join tblCSub cs
            on sn.subname_seq = cs.subname_seq
                inner join tblCourse c
                    on c.course_seq = cs.course_seq
                        inner join tblSubjectTxt st
                            on sn.subname_seq = st.subname_seq
                                inner join tblTextBook tb
                                    on tb.txtbook_seq = st.txtbook_seq
                        where sn.subname_seq = pcsub_seq;

begin
    open vcursor;
        dbms_output.put_line('=======================================================');
        dbms_output.put_line(rpad('과목명',10,' ') || '                         ' || rpad('도서명', 50, ' '));
        dbms_output.put_line('=======================================================');
        
        loop
            fetch vcursor into snsubname, tbname;
            exit when vcursor%notfound;
            
             dbms_output.put_line(rpad(snsubname, 10, ' ') || rpad(tbname, 50, ' ') || '...');
            
        end loop;
    close vcursor;

exception
    when others then
        dbms_output.put_line('=======================================================');
        dbms_output.put_line('                  잘못된 값을 입력했습니다.');
        dbms_output.put_line('=======================================================');
        
end procCBook;
/

--------------------------------------------------------------------------------------

begin
    procCBook(1);
end;
/

--------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------
-- 1-3. 교육생 정보
-- 교육생이름, 주민번호 뒷자리, 출결 점수, 필기 점수, 실기 점수
--------------------------------------------------------------------------------------

create or replace procedure procSuMemScore (
    pcsub_seq tblCsub.csub_seq%type     -- 개설 과목 별
)
is
    snsubname tblsubjectname.subname%type;       -- 과목명
    mm_name tblMember.m_name%type;               -- 교육생 이름
    mm_password tblMember.m_password%type;       -- 주민번호 뒷자리
    scattend_score tblscore.attend_score%type;   -- 출결점수
    scpilgi_score tblscore.pilgi_score%type;     -- 필기점수
    scsilgi_score tblscore.silgi_score%type;     -- 실기점수
    cursor vcursor is
    select
        sn.subname,
        m.m_name,
        m.m_password,
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
                                                                    on sc.csub_seq = cs.csub_seq
                                                                    
            where s.sugang_seq = pcsub_seq and s.sugang_seq = sc.sugang_seq;
               
begin
    open vcursor;
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line(rpad('과목명', 16, ' ') || '|' ||rpad('교육생이름', 10, ' ') ||  '| ' || rpad('주민번호 뒷자리', 15, ' ') || ' |' || rpad('출결점수', 8, ' ') || '|' || rpad('필기점수', 8, ' ') || '|' || rpad('실기점수', 8, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into snsubname, mm_name, mm_password, scattend_score, scpilgi_score, scsilgi_score;
            exit when vcursor%notfound;
            
            dbms_output.put_line(rpad(snsubname, 16, ' ') ||  '|' ||rpad(mm_name, 10, ' ') ||  '|     ' || rpad(mm_password, 10, ' ') || ' |   ' || rpad(scattend_score, 5, ' ') || '|   ' || rpad(scpilgi_score, 5, ' ') || '|   ' || rpad(scsilgi_score, 5, ' '));
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('==============================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('==============================================================================================================');    
end procSuMemScore;
/

--------------------------------------------------------------------------------------

begin
    procSuMemScore(1);
end;
/

--------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------
-- 2. 성적 정보 출력 시 교육생 개인별
--------------------------------------------------------------------------------------

create or replace procedure procSuMemScore (
    pssugang_seq tblSugang.sugang_seq%type
)
is
    
    mm_name tblMember.m_name%type;
    mm_password tblMember.m_password%type;
    cncourse_neme tblCourseName.course_neme%type;
    cc_start_date tblCourse.c_start_date%type;
    cc_end_date tblCourse.c_end_date%type;
    rroom_name tblRoom.room_name%type;
    ssubname tblSubjectName.subname%type;
    ccsstart_date tblCSub.csstart_date%type;
    ccsend_date tblCSub.csstart_date%type;
    tteacher_name tblTeacher.t_name%type;
    aattend_score tblscore.attend_score%type;
    ppilgi_score tblscore.pilgi_score%type;
    ssilgi_score tblscore.silgi_score%type;
    cursor vcursor is
    select
        m.m_name,
        m.m_password,
        cn.course_neme,
        c.c_start_date,
        c.c_end_date,
        r.room_name,
        sn.subname,
        cs.csstart_date,
        cs.csend_date,
        t.t_name,
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
            where s.sugang_seq = pssugang_seq;
               
begin
    open vcursor;
        dbms_output.put_line('=====================================================================================================================================');
        dbms_output.put_line(rpad('교육생이름', 10, ' ') ||  '|  ' || rpad('주민번호 뒷자리', 10, ' ') || '|  ' ||
                             rpad('개설과정명', 20, ' ') || '|  ' || rpad('개설 과정 시작일', 13,' ') || '     |  ' || rpad('개설 과정 종료일', 13, ' ')  || '|  ' || rpad('강의실명', 8, ' ') || '|' ||
                             rpad('개설과목명', 20, ' ') || ' |' || rpad('개설 과목 시작일', 13, ' ') || ' | ' || rpad('개설 과목 종료일', 13, ' ') || '|' || 
                             rpad('교사명', 8, ' ') || '|' || rpad('출결점수', 8, ' ') || '|' || rpad('필기점수', 8, ' ') || '|' || rpad('실기점수', 8, ' '));
        dbms_output.put_line('=====================================================================================================================================');
        
        loop
            fetch vcursor into mm_name, mm_password, cncourse_neme, cc_start_date, cc_end_date, rroom_name, ssubname, ccsstart_date, ccsend_date, tteacher_name, aattend_score, ppilgi_score, ssilgi_score;
            exit when vcursor%notfound;
            
            dbms_output.put_line(rpad(mm_name, 10, ' ') ||  '|  ' || rpad(mm_password, 10, ' ') || '|  ' ||
                             rpad(cncourse_neme, 20, ' ') || '...' || '|  ' || rpad(cc_start_date, 13,' ') || '     |  ' || rpad(cc_end_date, 13, ' ')  || '|  ' || rpad(rroom_name, 8, ' ') || '|' ||
                             rpad(ssubname, 20, ' ') || ' |' || rpad(ccsstart_date, 13, ' ') || ' | ' || rpad(ccsend_date, 13, ' ') || '|' || 
                             rpad(tteacher_name, 8, ' ') || '|' || rpad(aattend_score, 8, ' ') || '|' || rpad(ppilgi_score, 8, ' ') || '|' || rpad(ssilgi_score, 8, ' '));
            
        end loop;
    close vcursor;
exception
    when others then
        dbms_output.put_line('==============================================================================================================');
        dbms_output.put_line('                                        잘못된 값을 입력했습니다.');
        dbms_output.put_line('==============================================================================================================');    
end procSuMemScore;
/

--------------------------------------------------------------------------------------

begin
    procSuMemScore(180);
end;
/

--------------------------------------------------------------------------------------