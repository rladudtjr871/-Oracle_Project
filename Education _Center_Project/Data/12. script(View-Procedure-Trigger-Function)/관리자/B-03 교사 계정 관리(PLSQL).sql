-- B-03 교사 계정 관리(PL/SQL).sql


----------------- 교사 정보 입력 -----------------

-- 1. 교사 이름, 주민번호 뒷자리, 전화번호 입력
    create or replace procedure procTAdd(
        pname tblteacher.t_name%type,
        ppw tblteacher.t_password%type,
        ptel tblteacher.t_tel%type,
        presult out number
    )
    is
    begin
        insert into tblteacher (teacher_seq, t_name, t_password, t_tel) 
            values ((select max(teacher_seq) + 1 from tblteacher), pname, ppw, ptel);

        presult := 1;
        
    exception
        when others then
            presult := 0;
    end;   
                


--******************************************************************************
    declare
        vresult number;
    begin
        procTAdd('테스트', 1234, '010-1234-1234', vresult);
        if vresult = 1 then
            dbms_output.put_line('교사 정보 등록에 성공하였습니다.');
        else
            dbms_output.put_line('교사 정보 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************


-- 2. 교사의 강의 가능 과목 입력

 create or replace procedure procTSubAdd(
        pname tblteacher.t_name%type,
        psubname tblsubjectname.subname%type,
        presult out number
    )
    is
    begin
        insert into tblTeacherSub (tsubject_seq, teacher_seq, subname_seq) values ((select max(tsubject_seq) + 1 from tblTeacherSub)
                                                                            ,(select teacher_seq from tblteacher where t_name = pname)
                                                                            ,(select subname_seq from tblSubjectName where subname = psubname));

        presult := 1;
        
    exception
        when others then
            presult := 0;
    end;   
                


--******************************************************************************
    declare
        vresult number;
    begin
        procTSubAdd('테스트', 'Oracle', vresult);
        if vresult = 1 then
            dbms_output.put_line('교사 정보 등록에 성공하였습니다.');
        else
            dbms_output.put_line('교사 정보 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************




----------------- 교사 정보 전체 출력 -----------------


-- 1. 교사의 개인 정보 출력

    create or replace view vwTeacher
    as
    select 
        t.t_name as "교사명", 
        t.t_password as "주민등록번호 뒷자리", 
        t.t_tel as "전화번호"
    from tblteacher t
    order by t.t_name asc;
    
    
    select * from vwTeacher;
    
    

--******************************************************************************

    select * from vwTeacher;

--******************************************************************************   


-- 2. 교사의 강의 가능 과목 출력

    create or replace view vwTSub
    as
    select 
        t.t_name as "교사명",
        n.subname as "강의 가능 과목"
    from tblteacher t
        inner join tblTeacherSub s
            on t.teacher_seq = s.teacher_seq
                inner join tblSubjectName n
                    on s.subname_seq = n.subname_seq
                        order by t.t_name asc;
                        
                        
--******************************************************************************

    select * from vwTSub;

--****************************************************************************** 




----------------- 특정 교사 정보 출력 -----------------


-- 1. 특정 교사의 배정된 개설 과목 출력


    create or replace procedure procTeacherSubFind(
    tname varchar2
    )
    is
        psubname tblSubjectname.subname%type;
        pcsstart_date tblCSub.csstart_date%type;
        pcsend_date tblCSub.csend_date%type;
        vcnt number;
        
        cursor vcursor is
        select 
            sj.subname as "배정된 개설 과목명",
            cs.csstart_date "개설 과목 시작날짜",
            cs.csend_date "개설 과목 종료날짜"
        from tblCSub cs
            inner join tblSubjectname sj 
                on cs.subname_seq = sj.subname_seq
                    inner join tblCourse c 
                        on cs.course_seq = c.course_seq
                             inner join tblteacher t
                                on c.teacher_seq = t.teacher_seq
                                    where t.t_name = tname;
    begin
        select count(*) into vcnt from tblteacher where t_name = tname;
        open vcursor;
        if vcnt > 0 then
             dbms_output.put_line('======<<' || tname || ' 교사의 배정된 개설 과목>>============================================================================================'); 
             dbms_output.put_line(' ');
             dbms_output.put_line(rpad('[배정된 개설 과목명]',30,' ') || '|' || rpad(' [개설 과목 시작날짜]',25, ' ') || ' |' || rpad(' [개설 과목 종료날짜]', 25, ' '));
             
            loop
                fetch vcursor into psubname, pcsstart_date, pcsend_date;
                exit when vcursor%notfound;
              
            dbms_output.put_line( rpad( psubname , 30, ' ') || '| ' ||rpad(pcsstart_date, 25, ' ')|| '| ' || rpad(pcsend_date, 25, ' '));
          
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
            close vcursor;
            
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('교사를 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;
  
    end procTeacherSubFind;
    
    
--******************************************************************************
    begin
    
    procTeacherSubFind('최경하');
    
    end;
    
--******************************************************************************


-- 2. 특정 교사의 과정 정보 , 강의실명, 강의 진행 상태 출력 

    create or replace procedure procTeacherCourseFind(
    tname varchar2
    )
    is
        pcname tblcoursename.course_neme%type;
        pstartdate tblcourse.c_start_date%type;
        penddate tblcourse.c_end_date%type;
        prname tblroom.room_name%type;
        pstate varchar2(20);
        vcnt number;
        cursor vcursor is
        select 
            cn.course_neme as "과정명", 
            c.c_start_date as "개설과정시작날짜", 
            c.c_end_date as "개설과정끝날짜",
            r.room_name as "강의실명",        
            case 
                when c_start_date > sysdate then '강의 예정'
                when c_start_date < sysdate and c_end_date > sysdate then '강의중'
                when c_end_date < sysdate then '강의종료'
            end as "강의 진행 상태"
        from tblteacher t
            inner join tblCourse c
                on t.teacher_seq = c.teacher_seq
                    inner join tblCourseName cn
                        on cn.cname_seq = c.cname_seq
                            inner join tblRoom r
                                on c.room_seq = r.room_seq
                                     where t.t_name = tname
                                        order by c.c_start_date asc;
    begin
        select count(*) into vcnt from tblteacher where t_name = tname;
        open vcursor;
        if vcnt > 0 then
            dbms_output.put_line('======<<' || tname || ' 교사의 과정 정보 , 강의실명, 강의 진행 상태>>========================================================================'); 
            dbms_output.put_line(' ');
            dbms_output.put_line(rpad('과정명',33,' ') || '|' || rpad(' 개설과정시작날짜', 20, ' ') || ' |' || rpad(' 개설과정끝날짜', 20, ' ')
                                        || ' |' || rpad(' 강의실명', 15, ' ') || ' |' || rpad(' 강의 진행 상태', 15, ' '));
            dbms_output.put_line('=====================================================================================================================================');
        
            loop
                fetch vcursor into pcname, pstartdate, penddate, prname, pstate;
                exit when vcursor%notfound;
              
            dbms_output.put_line( rpad( pcname , 30, ' ') || '...| ' ||rpad(pstartdate, 20, ' ')|| '| ' || rpad(penddate, 20, ' ') || '| ' ||rpad(prname, 15, ' ') || '| ' || rpad(pstate, 15, ' '));
          
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
        close vcursor;
        
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('교사를 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;

    end;


    
--******************************************************************************

    begin
        procTeacherCourseFind('최경하');
    end;

    
--******************************************************************************


-- 3. 특정 교사의 수업하는 교재명 출력


    create or replace procedure procTBookFind(
    tname varchar2      -- 조회할 교사 이름
    )
    is
    
        pbname tblTextBook.name%type;
        vcnt number;
    
        cursor vcursor is
            
        select
            tb.name
        from tblteacher t
            inner join tblTeacherSub ts
                on t.teacher_seq = ts.teacher_seq
                    inner join tblSubjectName sn
                        on sn.subname_seq = ts.subname_seq                       
                            inner join tblSubjectTxt st           
                                    on st.subname_seq = sn.subname_seq
                                        inner join tblTextBook tb   
                                            on tb.txtbook_seq = st.txtbook_seq
                                                 where t.t_name = tname;
    
    begin
    
        select count(*) into vcnt from tblteacher where t_name = tname;
        open vcursor;
        if vcnt > 0 then
        dbms_output.put_line('======<<' || tname || ' 교사의 수업하는 교재명>>========================================================================'); 
        
        
            loop
                fetch vcursor into pbname;
                exit when vcursor%notfound;
                
                dbms_output.put_line(pbname);
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
            close vcursor;
        
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('교사를 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;

    end;


    
--******************************************************************************

    begin
        procTBookFind('최경하');
    end;   
    
--******************************************************************************


----------------- 교사 정보 수정 -----------------

-- 1. 교사 기본 정보 수정
create or replace procedure procTeacherup (
    pteacher_seq tblTeacher.teacher_seq%type,
    pt_name tblTeacher.t_name%type,
    pt_password tblTeacher.t_password%type,
    pt_tel tblTeacher.t_tel%type,
    presult out number
)
is
begin

    update tblTeacher set t_name = pt_name, t_password = pt_password, t_tel = pt_tel where teacher_seq = pteacher_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procTeacherup;


--******************************************************************************
declare
    vresult number;
begin
    procTeacherup(1, '최경숙', 2532102, '010-5285-3994', vresult);
    if vresult = 1 then
        dbms_output.put_line('교사 정보 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교사 정보 수정에 실패하셨습니다.');
    end if;
end;
--******************************************************************************



-- 2. 교사의 강의 가능 과목 수정

create or replace procedure procTeacherSubup (
    psname tblsubjectname.subname%type,
    psnum tblteachersub.tsubject_seq%type,
    presult out number
)
is
begin

    update tblTeacherSub set subname_seq = (select subname_seq from tblSubjectName where subname = psname) 
                                                    where tsubject_seq = psnum;
    presult := 1;
    
exception
    when others then
        presult := 0;
end;


--******************************************************************************
declare
    vresult number;
begin
    procTeacherSubup('Oracle' , 3, vresult);
    if vresult = 1 then
        dbms_output.put_line('교사 정보 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교사 정보 수정에 실패하셨습니다.');
    end if;
end;
--******************************************************************************

----------------- 교사 정보 삭제 -----------------  



-- 교사 삭제
create or replace procedure procTeacherde (
    pteacher_seq tblTeacher.teacher_seq%type,
    presult out number
)
is
begin

    delete tblTeacher where teacher_seq = pteacher_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procTeacherde;


--******************************************************************************
declare
    vresult number;
begin
    procTeacherde(1, vresult);
    if vresult = 1 then
        dbms_output.put_line('교사 정보 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('교사 정보 삭제에 실패하셨습니다.');
    end if;
end;

--******************************************************************************









