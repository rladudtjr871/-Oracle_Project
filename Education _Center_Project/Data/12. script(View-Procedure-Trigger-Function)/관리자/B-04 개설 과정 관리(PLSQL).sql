-- B-04 개설 과정 관리(PL/SQL).sql

----------------- 개설정보 등록(입력) ----------------- 

     create or replace procedure procCourseIAdd (
        psdate tblcourse.c_start_date%type,
        pedate tblcourse.c_end_date%type,
        pcseq tblcourse.cname_seq%type,
        ptseq tblcourse.teacher_seq%type,
        prseq tblcourse.room_seq%type,
        presult out number
    )
    is
    begin
      insert into tblCourse (course_seq, c_start_date, c_end_date, cname_seq, teacher_seq, room_seq) 
                        values ((select max(course_seq) + 1 from tblCourse), psdate, pedate, pcseq, ptseq, prseq );
     
    presult := 1;            
    exception
        when others then
            presult := 0;
    end;
    

--******************************************************************************
    declare
        vresult number;
    begin
         procCourseIAdd('2022-08-20','2023-02-20',1,10,1, vresult);
        if vresult = 1 then
            dbms_output.put_line('개설정보 등록에 성공하였습니다.');
        else
            dbms_output.put_line('개설정보 등록에 실패하셨습니다.');
        end if;
    end;
    select * from tblCourse;
--******************************************************************************    


----------------- 개설정보 출력 -----------------    


    create or replace view vwCoursePrint
    as
    select
        cn.course_neme as "개설 과정명",
        c.c_start_date as "개설과정 시작날짜",
        c.c_end_date as "개설과정 종료날짜",
        r.room_name as "강의실명",
        t.t_name as "교사명",
        case when c.course_seq in (select distinct course_seq from tblCSub) then 'Y'
             else 'N' 
        end as "개설과목 등록여부",
        (select count(*) from tblSugang where course_seq = c.course_seq) as "수강 인원"
    from tblCourse c
        inner join tblCourseName cn
            on c.cname_seq = cn.cname_seq
                inner join tblRoom r
                    on c.room_seq = r.room_seq
                        inner join tblteacher t
                            on c.teacher_seq = t.teacher_seq
                                order by c.c_start_date desc, cn.course_neme desc;
                                
                                

--******************************************************************************
    
    select * from vwCoursePrint;
    
--******************************************************************************    
    

----------------- 특정 개설 과정 선택해서 출력 -----------------  
    

-- 1. 선택한 특정 개설 과정의 교사 출력
    create or replace procedure procCTeacherPring(
    pcnum number
    )
    is  
        pcname varchar2(100);
        tname tblteacher.t_name%type;
        tnum number; -- 조회할 개설 과정번호
        vcnt number;
        cursor vcursor is
        select 
            t.t_name as "교사명"
        from tblCourse c 
             inner join tblteacher t
                on t.teacher_seq = c.teacher_seq
                    where c.course_seq = pcnum;

        
    begin
        
        
        
        select count(*) into vcnt from tblCourse where course_seq = pcnum;
        open vcursor;
        if vcnt > 0 then
        dbms_output.put_line('======================');
        dbms_output.put_line('[교사명]');
        
        
            loop
                fetch vcursor into tname;
                exit when vcursor%notfound;
                dbms_output.put_line(''); 
                dbms_output.put_line(' '||tname);
                
            end loop;
            dbms_output.put_line('======================');
            
        close vcursor;
        
        else
        dbms_output.put_line('=======================================');
        dbms_output.put_line('입력한 개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('=======================================');
        end if;
    
    end;
    
--******************************************************************************

    begin
        procCTeacherPring(1);
    end;
    
--******************************************************************************


-- 2. 선택한 특정 개설 과정의 과목 출력 


   

    create or replace procedure procCourseSubPrint(
    pcnum number
    )
    is
        
        psubname tblSubjectName.subname%type;
        pcsstart_date tblcsub.csstart_date%type;
        pcsedn_date tblcsub.csend_date%type;
        vcnt number;
        cursor vcursor is
        select 
            sn.subname as "과목명",
            cs.csstart_date as "과목 시작일",
            cs.csend_date as "과목 종료일"
        from tblCourse c
            inner join tblCSub cs 
                on c.course_seq = cs.course_seq 
                    inner join tblSubjectName sn
                        on sn.subname_seq = cs.subname_seq
                            where c.course_seq = pcnum;
        
    begin
        select count(*) into vcnt from tblCourse where course_seq = pcnum;
        open vcursor;
        if vcnt > 0 then
            dbms_output.put_line('=============================================================================================================');
            dbms_output.put_line(rpad('과목명',20,' ') || '|' || rpad(' 과목 시작일', 20, ' ') || ' |' || rpad(' 과목 종료일', 20, ' '));
            dbms_output.put_line('=============================================================================================================');
            
            loop
                fetch vcursor into psubname, pcsstart_date, pcsedn_date;
                exit when vcursor%notfound;
                
            dbms_output.put_line(rpad( psubname , 20, ' ') || '| ' ||rpad(pcsstart_date, 20, ' ')|| '| ' || rpad(pcsedn_date, 20, ' '));
            
            end loop;
            dbms_output.put_line('=============================================================================================================');
        close vcursor;    
            
        else
        dbms_output.put_line('=====================================');
        dbms_output.put_line('입력한 개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('=====================================');

        end if;    
    
    end;

--******************************************************************************

    begin
        procCourseSubPrint(1);
    end;

--******************************************************************************


-- 3. 선택한 특정 개설 과정의 과목교재 출력



    create or replace procedure procCBookPrint(
    pcnum number
    )
    is
        psubname tblSubjectName.subname%type;
        pbname tbltextbook.name%type;
        vcnt number;
        cursor vcursor is
        select distinct
            sn.subname as "과목명", 
            tb.name as "교재명"    
        from tblCSub cs                                 
            inner join tblSubjectName sn                   
                on sn.subname_seq = cs.subname_seq 
                    inner join tblSubjectTxt st           
                            on st.subname_seq = sn.subname_seq
                                inner join tblTextBook tb   
                                    on tb.txtbook_seq = st.txtbook_seq
                                        where cs.course_seq = pcnum
                                            order by sn.subname asc;      
    begin
    

        select count(*) into vcnt from tblCourse where course_seq = pcnum;
        open vcursor;
        if vcnt > 0 then
            dbms_output.put_line('=============================================================================================================');
            dbms_output.put_line(rpad('과목명',20,' ') || '|' || ' 교재명' );
            dbms_output.put_line('=============================================================================================================');
            
            loop
                fetch vcursor into psubname, pbname;
                exit when vcursor%notfound;
                
            dbms_output.put_line(rpad( psubname , 20, ' ') || '| ' || pbname);
            
            end loop;
            dbms_output.put_line('=============================================================================================================');
        close vcursor;    
            
        else
        dbms_output.put_line('=====================================');
        dbms_output.put_line('입력한 개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('=====================================');

        end if;    
    
    end;


--******************************************************************************


    begin
        procCBookPrint(1);
    end;

--******************************************************************************



-- 4. 선택한 특정 개설 과정의 교육생 출력

    
    create or replace procedure procCStuPrint(
    pcnum number
    )
    is
        
        
        psname tblmember.m_name%type;
        ppw tblmember.m_password%type;
        ptel tblmember.m_tel%type;
        pregistdate tblmember.m_registdate%type;
        pmajor tblmember.m_major%type;
        pstate varchar2(20);
        vcnt number;
        cursor vcursor is
        select 
            m.m_name as "교육생명",
            m.m_password as "주민번호 뒷자리",
            m.m_tel as "교육생전화번호",
            m.m_registdate as "교육생등록일",
            m.m_major as "전공여부",
            case
                when s.progress = '수강종료' then '수료'
                when s.progress = '중도탈락' then '중도탈락'
            end as "수료 및 중도 탈락"
        from tblCourse c     
            inner join tblSugang s
                on s.course_seq = c.course_seq
                    inner join tblMember m
                        on s.member_seq = m.member_seq
                            where c.course_seq = pcnum;     
    begin
        select count(*) into vcnt from tblCourse where course_seq = pcnum;
        open vcursor;
        if vcnt > 0 then
            dbms_output.put_line('=============================================================================================================');
            dbms_output.put_line(rpad('교육생명',10,' ') || '|' || rpad('주민번호 뒷자리',20,' ') || ' |' ||rpad('교육생전화번호',20,' ') || '|' ||
                                        rpad('교육생등록일',20,' ') || ' |' || rpad('전공여부',10,' ')|| ' |' || '수료 및 중도탈락');
            dbms_output.put_line('=============================================================================================================');
            
            loop
                fetch vcursor into psname, ppw, ptel, pregistdate, pmajor, pstate ;
                exit when vcursor%notfound;
                
            dbms_output.put_line(rpad(psname , 10, ' ') || '| ' ||rpad(ppw , 20, ' ') || '|' ||rpad(ptel , 20, ' ') || '| ' ||
                                    rpad(pregistdate , 20, ' ') || '| ' ||rpad(pmajor , 10, ' ')|| '| ' || pstate);
            
            end loop;
            dbms_output.put_line('=============================================================================================================');
        close vcursor;    
            
        else
        dbms_output.put_line('=====================================');
        dbms_output.put_line('입력한 개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('=====================================');

        end if;    
    
    end;

--******************************************************************************

    begin
        procCStuPrint(1);
    end;
    

--******************************************************************************



----------------- 개설 과정 정보 수정 -----------------  

-- 개설과정 정보 수정
create or replace procedure procCourseup (
    pseq tblcourse.course_seq%type,
    pname tblcoursename.course_neme%type,
    pstart tblcourse.c_start_date%type,
    pend tblcourse.c_end_date%type,
    proom tblcourse.room_seq%type,
    presult out number
)
is
begin

    update tblCourse set cname_seq = 
        (select cname_seq from tblCourseName where course_neme = pname), c_start_date = pstart, c_end_date = pend, room_seq = proom where course_seq = pseq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procCourseup;


--******************************************************************************

declare
    vresult number;
begin
    procCourseup(1, '찾을 과목명', '시작일', '종료일', 5, vresult); -- 강의실번호
    if vresult = 1 then
        dbms_output.put_line('개설과정 정보 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('개설과정 정보 수정에 실패하셨습니다.');
    end if;
end;

--******************************************************************************





----------------- 개설 과정 정보 삭제 -----------------  

-- 개설과정 정보 삭제
create or replace procedure procCoursede (
    pseq tblcourse.course_seq%type,
    presult out number
)
is
begin

    delete tblCourse where course_seq = pseq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procCoursede;


--******************************************************************************
declare
    vresult number;
begin
    procCoursede(1, vresult);
    if vresult = 1 then
        dbms_output.put_line('개설과정 정보 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('개설과정 정보 삭제에 실패하셨습니다.');
    end if;
end;

--******************************************************************************

----------------- 수료날짜 지정 -----------------  


-- 특정 개설 과정이 수료한 경우 등록된 교육생 전체 수료날짜 지정(중도탈락자는 제외)



    create or replace procedure procCdateUpdate(
        presult out number
    )
    is
    
    psugang tblsugang.sugang_seq%type;
    
    cursor vcursor is
    select 
    s.sugang_seq
    from tblcourse c
        inner join tblsugang s
            on c.course_seq = s.course_seq
                where c.c_end_date < sysdate and s.complete_date is null;
    
    begin
    
        open vcursor;
        
            loop
                fetch vcursor into psugang;
                exit when vcursor%notfound;
                
        update tblsugang sg set complete_date = (select c.c_end_date
                                                 from tblcourse c 
                                                    inner join tblsugang s 
                                                        on c.course_seq = s.course_seq    
                                                            where c.c_end_date < sysdate and s.sugang_seq = psugang and s.progress <> '중도탈락');
            end loop;
            close vcursor;
       
        presult := 1;
        commit;
    exception
        when others then
            presult := 0;
            rollback;
    
    end;                                             
    




--******************************************************************************

    
declare
    vresult number;
begin
    procCdateUpdate(vresult);
    if vresult = 1 then
        dbms_output.put_line('업데이트를 성공했습니다.');
    else
        dbms_output.put_line('업데이트를 실패했습니다.');
    end if;
end;

--******************************************************************************




























