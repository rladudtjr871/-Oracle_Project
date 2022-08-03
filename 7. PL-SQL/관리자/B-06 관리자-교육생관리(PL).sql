-- B-06. 관리자 교육생 관리


--====================================================================================================================================
--회원 정보 등록
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procAddMemberInfo (
    pname tblMember.m_name%type,
    ppassword tblMember.m_password%type,
    ptel tblMember.m_tel%type,
    pmajor tblMember.m_major%type,
    presult out number

)
is

begin
    
    insert into tblMember (member_seq, m_name, m_password, m_tel, m_registdate, m_major)
    values ((select max(member_seq) + 1 from tblMember), pname, ppassword, ptel, sysdate, pmajor);
    
    presult := 1;
    
exception
    when others then
        presult := 0;
        
end procAddMemberInfo;
/
drop procedure procAddMemberInfo;

--------------------------------------------------------------------------------------------------------------------------------------

declare
    vresult number;
begin
    procAddMemberInfo('박진진', '1021513', '010-8295-0601','비전공', vresult);
    
    if vresult = 1 then
        dbms_output.put_line('========================================================');
        dbms_output.put_line('         회원 등록을 정상적으로 끝냈습니다.');
        dbms_output.put_line('========================================================');
    
    else 
        dbms_output.put_line('========================================================');
        dbms_output.put_line('              회원 등록에 실패햇습니다.');
        dbms_output.put_line('========================================================');
    end if;
    
end;
/
set serverout on;

rollback;
--====================================================================================================================================

-- 회원 정보 수정


-- 회원 이름 수정 프로시저
create or replace procedure procmembername (
    pm_name tblMember.m_name%type,
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    update tblMember set m_name = pm_name where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmembername;
/


-- 회원 이름 수정
declare
    vresult number;
begin
    procmembername('김영숙', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 이름 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 이름 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 회원 주민번호 수정 프로시저
create or replace procedure procmemberjumin (
    pm_password tblMember.m_password%type,
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    update tblMember set m_password = pm_password where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmemberjumin;
/


-- 회원 주민번호 수정
declare
    vresult number;
begin
    procmemberjumin(1000000, 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 주민번호 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 주민번호 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

--회원 전화번호 수정 프로시저
create or replace procedure procmembertel (
    pm_tel tblMember.m_tel%type,
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    update tblMember set m_tel = pm_tel where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmembertel;
/


--회원 전화번호 수정
declare
    vresult number;
begin
    procmembertel('010-1234-5678', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 전화번호 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 전화번호 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

--회원 등록일 수정 프로시저
create or replace procedure procmembertel (
    pm_registdate tblMember.m_registdate%type,
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    update tblMember set m_registdate = pm_registdate where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmembertel;
/


--회원 등록일 수정
declare
    vresult number;
begin
    procmembertel('22/05/05', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 등록일 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 등록일 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

--회원 전공여부 수정 프로시저
create or replace procedure procmembertel (
    pm_major tblMember.m_major%type,
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    update tblMember set m_major = pm_major where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmembertel;
/


--회원 전공여부 수정
declare
    vresult number;
begin
    procmembertel('전공', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 전공여부 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 전공여부 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 회원 정보 삭제 프로시저
create or replace procedure procmemberbye (
    pm_seq tblMember.member_seq%type,
    presult out number
)
is
begin
    delete from tblMember where member_seq = pm_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procmemberbye;
/


--회원 삭제
declare
    vresult number;
begin
    procmemberbye(1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('회원 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('회원 삭제에 실패하셨습니다.');
    end if;
end;


--====================================================================================================================================
--교육생 정보 등록
--------------------------------------------------------------------------------------------------------------------------------------
create or replace procedure procAddSugangInfo (
    penddate tblSugang.complete_date%type,
    pnow tblSugang.progress%type,
    pm_num tblSugang.member_seq%type,
    pcouse_num tblSugang.course_seq%type,
    presult out number

)
is

begin
    
    insert into tblSugang values ((select max(sugang_seq)+1 from tblSugang), penddate, pnow, pm_num, pcouse_num);
    
    presult := 1;
    
exception
    when others then
        presult := 0;
        
end procAddSugangInfo;
/

--------------------------------------------------------------------------------------------------------------------------------------

declare
    vresult number;
begin
    procAddSugangInfo('23/05/05', '진행예정', 1, 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('========================================================');
        dbms_output.put_line('         교육생 등록을 정상적으로 끝냈습니다.');
        dbms_output.put_line('========================================================');
    
    else 
        dbms_output.put_line('========================================================');
        dbms_output.put_line('              교육생 등록에 실패했습니다.');
        dbms_output.put_line('========================================================');
    end if;
    
end;
/

--====================================================================================================================================

-- 교육생 정보 수정


-- 교육생 수료날짜 수정 프로시저
create or replace procedure procsuend (
    psu_com tblSugang.complete_date%type,
    psu_seq tblSugang.sugang_seq%type,
    presult out number
)
is
begin
    update tblSugang set complete_date = psu_com where sugang_seq = psu_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procsuend;
/


-- 교육생 수료날짜 수정
declare
    vresult number;
begin
    procsuend('22/04/03', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('교육생 수료날짜 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교육생 수료날짜 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 교육생 진행상태 수정 프로시저
create or replace procedure procsuprog (
    psu_prog tblSugang.progress%type,
    psu_seq tblSugang.sugang_seq%type,
    presult out number
)
is
begin
    update tblSugang set progress = psu_prog where sugang_seq = psu_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procsuprog;
/


-- 교육생 진행상태 수정
declare
    vresult number;
begin
    procsuprog('수강중', 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('교육생 진행상태 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교육생 진행상태 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 교육생 회원번호 수정 프로시저
create or replace procedure procsumember (
    pmember_seq tblSugang.member_seq%type,
    psu_seq tblSugang.sugang_seq%type,
    presult out number
)
is
begin
    update tblSugang set member_seq = pmember_seq where sugang_seq = psu_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procsumember;
/


-- 교육생 회원번호 수정
declare
    vresult number;
begin
    procsumember(2, 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('교육생 회원번호 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교육생 회원번호 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 교육생 개설과정번호 수정 프로시저
create or replace procedure procsucourse (
    pcourse_seq tblSugang.course_seq%type,
    psu_seq tblSugang.sugang_seq%type,
    presult out number
)
is
begin
    update tblSugang set course_seq = pcourse_seq where sugang_seq = psu_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procsucourse;
/


-- 교육생 개설과정번호 수정
declare
    vresult number;
begin
    procsucourse(2, 1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('교육생 개설과정번호 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('교육생 개설과정번호 수정에 실패하셨습니다.');
    end if;
end;

--====================================================================================================================================

-- 교육생 정보 삭제 프로시저
create or replace procedure procsugangbye (
    psugang_seq tblSugang.sugang_seq%type,
    presult out number
)
is
begin
    delete from tblSugang where sugang_seq = psugang_seq;
    presult := 1;
exception
    when others then
        presult := 0;
end procsugangbye;
/


--교육생 삭제
declare
    vresult number;
begin
    procsugangbye(1, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('교육생 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('교육생 삭제에 실패하셨습니다.');
    end if;
end;








--====================================================================================================================================
--회원 정보 출력
--------------------------------------------------------------------------------------------------------------------------------------
create or replace view vwMemberInfo 
as
select
    distinct
    m.m_name as "교육생이름",
    m.m_password as "교육생주민",
    m.m_tel "교육생전화번호",
    m.m_registdate "교육생등록일",
    (select count(*) from tblSugang where member_seq = s.member_seq and (s.progress <> '수강예정' or s.progress <> '중도탈락')) as "수강횟수",
    m.m_major as "교육생전공"
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq;


select * from vwMemberInfo;
--====================================================================================================================================







--====================================================================================================================================
--특정 교육생 선택시 교육생이 수강예정/수강중/수강종료/중도탈락 한 과목정보를 출력
--====================================================================================================================================
create or replace procedure procMemSubInfo (
    pmemseq tblMember.member_seq%type,
    presult out number
)
is
    cncourse_name tblCourseName.course_neme%type;
    cc_start_date tblCourse.c_start_date%type;
    cc_end_date tblCourse.c_end_date%type;
    rroom_name tblRoom.room_name%type;
    pprogress varchar2(100);
    sstop_date varchar2(100);
    cursor vacursor is
    select
            cn.course_neme as "과정명",
            c.c_start_date as "과정 시작",
            c.c_end_date as "과정 종료",
            r.room_name as "강의실",
            s.progress as "수료 및 중도탈락 여부"
        from tblCourse c
            inner join tblCourseName cn
                on c.cname_seq = cn.cname_seq
                    inner join tblRoom r
                        on c.room_seq = r.room_seq
                            inner join tblSugang s
                                on c.course_seq = s.course_seq
                                    inner join tblMember m
                                        on s.member_seq = m.member_seq
            where c.course_seq = (select
                                      s.course_seq
                                  from tblMember m
                                      inner join tblSugang s
                                          on m.member_seq = s.member_seq
                                              where m.member_seq = pmemseq and s.progress = '수강예정')
                  and s.member_seq = pmemseq;
                  
    cursor vbcursor is
    select
            cn.course_neme as "과정명",
            c.c_start_date as "과정 시작",
            c.c_end_date as "과정 종료",
            r.room_name as "강의실",
            s.progress as "수료 및 중도탈락 여부",
            case
                when stop_date is not null then to_char(stop_date)
                when stop_date is null then 'NULL'
            end as "중도탈락날짜"
            
        from tblCourse c
            inner join tblCourseName cn
                on c.cname_seq = cn.cname_seq
                    inner join tblRoom r
                        on c.room_seq = r.room_seq
                            inner join tblSugang s
                                on c.course_seq = s.course_seq
                                    inner join tblMember m
                                        on s.member_seq = m.member_seq
                                            left outer join tblStuStop st
                                                on s.sugang_seq = st.sugang_seq
            where c.course_seq = (select
                                      s.course_seq
                                  from tblMember m
                                      inner join tblSugang s
                                          on m.member_seq = s.member_seq
                                              where m.member_seq = pmemseq and (s.progress = '수강중' or s.progress = '중도탈락'))
                  and s.member_seq = pmemseq;
                  
        cursor vccursor is
        select
            cn.course_neme as "과정명",
            c.c_start_date as "과정 시작",
            c.c_end_date as "과정 종료",
            r.room_name as "강의실",
            s.progress as "중도탈락 여부",
            case
                when stop_date is not null then to_char(stop_date)
                when stop_date is null then 'NULL'
            end as "중도탈락날짜"
        from tblCourse c
            inner join tblCourseName cn
                on c.cname_seq = cn.cname_seq
                    inner join tblRoom r
                        on c.room_seq = r.room_seq
                            inner join tblSugang s
                                on c.course_seq = s.course_seq
                                    inner join tblMember m
                                        on s.member_seq = m.member_seq
                                          left outer join tblStuStop st
                                                on s.sugang_seq = st.sugang_seq
            where c.course_seq = (select
                                      s.course_seq
                                  from tblMember m
                                      inner join tblSugang s
                                          on m.member_seq = s.member_seq
                                              where m.member_seq = pmemseq and (s.progress = '수강종료' or s.progress = '중도탈락'))
                  and s.member_seq = pmemseq;
                  
                  
    vtemp varchar2(100);
                  
begin

    select progress into vtemp from tblSugang where member_seq = pmemseq;
    
    -- 수강 예정인 학생의 과목정보
    if vtemp = '수강예정' then
        
        open vacursor;
            loop
                fetch vacursor into cncourse_name, cc_start_date, cc_end_date, rroom_name, pprogress;
                exit when vacursor%notfound;
                
                            
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line('            과정이름                    과정시작일  과정종료일      강의실      중도탈락');
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line( cncourse_name || '  '||cc_start_date || '    ' ||cc_end_date || '     ' || rroom_name || '           ' || pprogress);
                
            end loop;
            presult := 1;
        close vacursor;

    
    
    -- 수강 중(중도탈락 포함)인 학생의 과목정보
    elsif vtemp in ('수강중', '중도탈락') then
        
       open vbcursor;
        
            loop
            
                fetch vbcursor into cncourse_name, cc_start_date, cc_end_date, rroom_name, pprogress, sstop_date;
            
                exit when vbcursor%notfound;
            
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line('            과정이름                    과정시작일  과정종료일      강의실      수료 및 중도탈락     중도탈락 날짜');
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line( cncourse_name || '  '||cc_start_date || '    ' ||cc_end_date || '     ' || rroom_name || '           ' || pprogress || '            ' || sstop_date);
            end loop;
            
            presult := 1;
            
        close vbcursor;
    
        
    
    
    -- 수강 종료(중도탈락 포함)인 학생의 과목정보
    elsif vtemp in ('수강종료', '중도탈락') then
        
        open vccursor;
            loop
                fetch vccursor into cncourse_name, cc_start_date, cc_end_date, rroom_name, pprogress, sstop_date;
                exit when vccursor%notfound;
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line('            과정이름                    과정시작일  과정종료일      강의실     수료 및 중도탈락     중도탈락 날짜');
                dbms_output.put_line('=========================================================================================================================');
                dbms_output.put_line( cncourse_name || '  '||cc_start_date || '    ' ||cc_end_date || '       ' || rroom_name || '         ' || pprogress || '             ' || sstop_date);
            
            end loop;
            presult := 1;
        close vccursor;
                  
        
    end if;

exception
    when others then
        presult := 0;
         
end procMemSubInfo;
/
--------------------------------------------------------------------------------------------------------------------------------------

declare
    vresult number;

begin
    if vresult = 0 then
        dbms_output.put_line('========================================================');
        dbms_output.put_line('              조회에 실패했습니다.');
        dbms_output.put_line('========================================================');
    end if;

    procMemSubInfo(280, vresult); -- 수강중 = 280, 중도탈락 187
    
end;
/
--====================================================================================================================================



commit;

--====================================================================================================================================
-- 수료 및 중도탈락 처리 (미완성)
--------------------------------------------------------------------------------------------------------------------------------------

create or replace trigger trgStop
    after
    insert or update
    on tblAttendance
    for each row
declare
    badpoint number;
begin
    
    if inserting then
        
        -- 출결정보 추가 후 해당 학생의 결석*지각 점수를 badpoint에 저장
        select 
            sum(case
                when a.attendance_type = '결석' then 3
                when a.attendance_type = '지각' then 1
            end) 
            into 
            badpoint
        from tblAttendance a
            inner join tblSugang s
                on a.sugang_seq = s.sugang_seq
                    inner join tblMember m
                        on s.member_seq = m.member_seq
                where s.sugang_seq = :new.sugang_seq;

        --select * from tblStuStop where sugang_seq = new.sugang_seq;
        
        -- 출결 점수가 15점 이상이면 tblSugang의 progress를 중도탈락으로 변경
        -- 중도탈락 테이블에 해당 학생 추가
        if badpoint >= 15 then
            update tblSugang set progress = '중도탈락' where sugang_seq = :new.sugang_seq;
        
            insert into tblStuStop (stustop_seq, stop_date, sugang_seq) values ((select max(stustop_seq) + 1 from tblStuStop), sysdate, :new.sugang_seq);
        end if;
        
            
    elsif updating then
    
        -- 출결정보 수정 후 해당 학생의 결석*지각 점수를 badpoint에 저장
        select 
            sum(case
                when a.attendance_type = '결석' then 3
                when a.attendance_type = '지각' then 1
            end) 
            into 
            badpoint
        from tblAttendance a
            inner join tblSugang s
                on a.sugang_seq = s.sugang_seq
                    inner join tblMember m
                        on s.member_seq = m.member_seq
                where s.sugang_seq = :new.sugang_seq;
    
        
        -- 출결 점수가 15점 이상이면 tblSugang의 progress를 중도탈락으로 변경
        -- 중도탈락 테이블에 해당 학생 추가
        if badpoint >= 15 then
            update tblSugang set progress = '중도탈락' where sugang_seq = :new.sugang_seq;
        
            insert into tblStuStop (stustop_seq, stop_date, sugang_seq) values ((select max(stustop_seq) + 1 from tblStuStop), sysdate, :new.sugang_seq);
        end if;
        
    end if;


end trgStop;


drop trigger trgstop;


    
update tblAttendance set attendance_type = '결석' where sugang_seq = 275 and attendance_seq = 3929;

insert into tblattendance values (4156, '2022-05-19', null, null, '결석', 275);

select * from tblattendance order by attendance_seq desc;

-- 3 + 1 = 4 11점 남음
commit;
rollback;