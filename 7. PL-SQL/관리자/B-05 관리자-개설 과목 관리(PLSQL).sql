-- B-05 개설 과목 관리(PL/SQL).sql

----------------- 특정 개설 과정 개설 과목 정보 신규 등록 ----------------- 
-- 과목명, 과목기간(시작 년월일, 끝 년월일, 교재명 입력
    

-- 과목명, 과목기간(시작 년월일, 끝 년월일) 입력

        
    
    create or replace procedure procOpenSubAdd (
        psubname_seq tblcsub.subname_seq%type, -- 과목명번호
        pcourse_seq tblcsub.course_seq%type, -- 개설 과정 번호
        pcsstart_date tblcsub.csstart_date%type, -- 과목시작일
        pcsend_date tblcsub.csend_date%type, -- 과목종료일
        presult out number
    )
    is
    
    begin
        insert into tblCSub (csub_seq, subname_seq, course_seq, csstart_date, csend_date) 
                values ((select max(csub_seq) + 1 from tblCSub), 
                        psubname_seq, pcourse_seq, pcsstart_date, pcsend_date);
        
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end;    
        
/
--******************************************************************************    

    declare
        vresult number;
    begin
        procOpenSubAdd(1,1,'2022-06-01','2022-07-01' , vresult);
        if vresult = 1 then
            dbms_output.put_line('개설 과목 정보 등록에 성공하였습니다.');
        else
            dbms_output.put_line('개설 과목 정보 등록에 실패하셨습니다.');
        end if;
    end;
/    
--******************************************************************************        
    
-- 과목에 대한 교재명 입력
    
            
    
    create or replace procedure procSubbookAdd (
        psubname_seq tblsubjecttxt.subname_seq%type, -- 과목명번호
        ptxtbook_seq tblsubjecttxt.txtbook_seq%type, -- 교재명번호
        presult out number
    )
    is
    
    begin
         insert into tblSubjectTxt (subtxt_seq, subname_seq, txtbook_seq) values 
                ((select max(subtxt_seq) + 1 from tblSubjectTxt), psubname_seq, ptxtbook_seq);
        
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end;  
    
--******************************************************************************    

    declare
        vresult number;
    begin
        procSubbookAdd(1,1, vresult);
        if vresult = 1 then
            dbms_output.put_line('개설 과목에 대한 교재 등록에 성공하였습니다.');
        else
            dbms_output.put_line('개설 과목에 대한 교재 등록에 실패하셨습니다.');
        end if;
    end;
/    
--******************************************************************************   




----------------- 개설 과목 정보 전체 출력 ----------------- 




-- 1. 현재 개설된 과정 정보
    create or replace view vwOpenCoursePrint
    as
    select distinct
        cn.course_neme as "과정명",
        c.c_start_date as "과정 시작 날짜",
        c.c_end_date as "과정 종료 날짜",
        t.t_name as "교사명"
    from tblCSub cs
        inner join tblCourse c
            on cs.course_seq = c.course_seq
                inner join tblCourseName cn
                    on c.cname_seq = cn.cname_seq
                        inner join tblteacher t
                            on t.teacher_seq = c.teacher_seq
                                order by c.c_start_date desc;


-- 2. 개설된 과정의 과목 정보
/   
    create or replace view vwOpenSPrint
    as
    select distinct
        c.course_seq "과정번호",
        sn.subname as "과목명", 
        cs.csstart_date as "과목 시작 날짜",
        cs.csend_date as "과목 종료 날짜"          
    from tblCourse c
        inner join tblCSub cs
            on c.course_seq = cs.course_seq
                 inner join tblSubjectName sn
                    on sn.subname_seq = cs.subname_seq 
                        inner join tblSubjectTxt st
                                on st.subname_seq = sn.subname_seq
                                    inner join tblTextBook tb
                                        on tb.txtbook_seq = st.txtbook_seq
                                            inner join tblCourse c
                                                on cs.course_seq = c.course_seq
                                                    order by c.course_seq asc;


-- 개설 과목 정보의 교재명 출력
    
    create or replace view vwOpenBookPrint
    as
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
                                        order by sn.subname asc;  
--******************************************************************************                                                        
-- 개설 과목에 대한 모든 정보 함께 출력                                                    
    select * from vwOpenSubPrint; 

-- 현재 개설된 과정 정보    
    select * from vwOpenCoursePrint;
-- 개설된 과정의 과목 정보    
    select * from vwOpenSPrint;
-- 개설 과목 정보의 교재명    
    select * from vwOpenBookPrint;
--******************************************************************************    
    
    
    
----------------- 선택한 개설 과정에 대한 개설 과목 정보 출력 -----------------     
    
-- 1. 선택한 특정 개설 과정의 과정명, 과정 시작 날짜, 과정 종료 날짜, 교사명, 강의실명 출력    

   
    create or replace procedure procOpenCPrint(
        pcourseseq number
    )
    is
        
        pcname tblcoursename.course_neme%type;
        pstartdate tblcourse.c_start_date%type;
        penddate tblcourse.c_end_date%type;
        ptname tblteacher.t_name%type;
        prname tblroom.room_name%type;
        vcnt number;
        cursor vcursor is
        select distinct
            cn.course_neme as "과정명",
            c.c_start_date as "과정 시작 날짜",
            c.c_end_date as "과정 종료 날짜",
            t.t_name as "교사명",
            r.room_name as "강의실명"
        from tblCSub cs
            inner join tblCourse c
                on cs.course_seq = c.course_seq
                    inner join tblCourseName cn
                        on c.cname_seq = cn.cname_seq
                            inner join tblteacher t
                                on t.teacher_seq = c.teacher_seq
                                    inner join tblRoom r
                                        on c.room_seq = r.room_seq
                                            where c.course_seq = pcourseseq
                                                order by c.c_start_date desc;
    begin
        select count(*) into vcnt from tblCourse where course_seq = pcourseseq;
        open vcursor;
        if vcnt > 0 then
            
            dbms_output.put_line(' ');
            dbms_output.put_line(rpad('과정명',33,' ') || '|' || rpad(' 개설과정시작날짜', 20, ' ') || ' |' || rpad(' 개설과정종료날짜', 20, ' ')
                                        || ' |' || rpad(' 교사명', 15, ' ') || ' |' || rpad(' 강의실명', 15, ' '));
            dbms_output.put_line('=====================================================================================================================================');
        
            loop
                fetch vcursor into pcname, pstartdate, penddate, ptname, prname;
                exit when vcursor%notfound;
              
            dbms_output.put_line( rpad( pcname , 30, ' ') || '...| ' ||rpad(pstartdate, 20, ' ')|| '| ' || rpad(penddate, 20, ' ') || '| ' ||rpad(ptname, 15, ' ') || '| ' || rpad(prname, 15, ' '));
          
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
        close vcursor;
        
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;

    end;
        
        
        
--******************************************************************************        
   
    begin
        procOpenCPrint(1);
    end;
   
--******************************************************************************   
   
   
   
-- 2. 선택한 특정 개설 과정의 과목 출력

   
   
   
   
    create or replace procedure procOpenCPrint(
        pcourseseq number
        
    )
    is

        psname tblsubjectname.subname%type;
        pcsstrtdate tblcsub.csstart_date%type;
        pcsedndate tblcsub.csend_date%type;
        vcnt number;
        cursor vcursor is
        select
            sn.subname as "과목명",
            cs.csstart_date as "과목 시작일",
            cs.csend_date as "과목 종료일"
        from tblCourse c            
            inner join tblCourseName cn
                on c.cname_seq = cn.cname_seq
                    inner join tblCSub cs 
                        on c.course_seq = cs.course_seq 
                            inner join tblSubjectName sn
                                on sn.subname_seq = cs.subname_seq
                                    where c.course_seq = pcourseseq;   
    begin

        select count(*) into vcnt from tblCourse where course_seq = pcourseseq;
        open vcursor;
        if vcnt > 0 then
            
            --dbms_output.put_line(pcoursename);
            dbms_output.put_line(rpad('과목명',25,' ') || '|' || rpad(' 과목 시작일', 20, ' ') || '  |' || rpad(' 과목 종료일', 20, ' '));
            dbms_output.put_line('=====================================================================================================================================');
        
            loop
                fetch vcursor into psname, pcsstrtdate, pcsedndate;
                exit when vcursor%notfound;
              
            dbms_output.put_line( rpad( psname , 25, ' ') || '| ' || rpad(pcsstrtdate, 20, ' ')|| ' | ' || rpad(pcsedndate, 20, ' '));
          
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
        close vcursor;
        
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;

    end;      
   
   
--******************************************************************************   
   
   begin
        procOpenCPrint(1);
   end;
   
--******************************************************************************  
   
-- 3. 선택한 특정 개설 과정의 과목교재 출력
          
   
    create or replace procedure procOpenCBook(
        pcourseseq number
        
    )
    is

        psname tblsubjectname.subname%type;
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
                                        where cs.course_seq = pcourseseq
                                            order by sn.subname asc;

    begin

        select count(*) into vcnt from tblCourse where course_seq = pcourseseq;
        open vcursor;
        if vcnt > 0 then
            
            
            dbms_output.put_line(rpad('과목명',20,' ') || '|' || ' 교재명');
            dbms_output.put_line('=====================================================================================================================================');
        
            loop
                fetch vcursor into psname, pbname;
                exit when vcursor%notfound;
              
            dbms_output.put_line( rpad( psname , 20, ' ') || '| ' || pbname);
          
            end loop;
            dbms_output.put_line('=====================================================================================================================================');
        close vcursor;
        
        else
        dbms_output.put_line('========================');
        dbms_output.put_line('개설 과정을 찾을 수 없습니다.');
        dbms_output.put_line('========================');
        end if;

    end;      

--******************************************************************************

    begin
        procOpenCBook(1);
    end;

--******************************************************************************


----------------- 개설 과목 정보 수정 ----------------- 
   
   
-- 개설과정 내 과목 수정
    create or replace procedure procCSubup (
        pnum tblCSub.csub_seq%type,
        pcsstart_date tblcsub.csstart_date%type,
        pcsend_date tblCSub.csend_date%type,
        psubname_seq tblcsub.subname_seq%type,
        presult out number
    )
    is
    begin
    
        update tblCSub set csstart_date = pcsstart_date, csend_date = pcsend_date, subname_seq = psubname_seq where csub_seq = pnum;
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end procCSubup;




--******************************************************************************

declare
    vresult number;
begin
    procCSubup(1, '변경 시작일', '변경 종료일', 5, vresult); -- 변경할 개설과목번호, 과목번호(정적)
    if vresult = 1 then
        dbms_output.put_line('개설과정내과목 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('개설과정내과목 수정에 실패하였습니다.');
    end if;
end;

--******************************************************************************
    
    
    
----------------- 개설 과목 정보 삭제 -----------------    


-- 개설과정 내 과목 삭제
create or replace procedure procCSubde (

    pnum tblCSub.csub_seq%type,
    presult out number
)
is
begin

    delete tblCSub where csub_seq = pnum;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procCSubde;



--******************************************************************************
declare
    vresult number;
begin
    procCSubde(1, vresult); -- 변경할 개설과목번호, 과목번호(정적)
    if vresult = 1 then
        dbms_output.put_line('개설과정내과목 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('개설과정내과목 삭제에 실패하였습니다.');
    end if;
end;    
--******************************************************************************    