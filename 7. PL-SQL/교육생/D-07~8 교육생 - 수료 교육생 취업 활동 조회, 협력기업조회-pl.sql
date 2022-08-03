-- D-07~8 교육생 - 수료 교육생 취업 활동 조회, 협력기업조회.sql plsql

-- 전체 학생 취업활동 조회
set serverout on;
-- 전체 학생 취업활동 조회 view 생성
create or replace view vwJobAct
as
select
    m.m_name as 수료생명,
    s.complete_date as 수료일,
    cn.course_neme as 개설과정명,
    j.jobact_date as 취업활동내역
from tblsugang s
    inner join tblmember m
    on s.member_seq = m.member_seq
    inner join tblcourse c
    on s.course_seq = c.course_seq
    inner join tblcoursename cn
    on c.cname_seq = cn.cname_seq
    inner join tbljobact j
    on s.sugang_seq = j.sugang_seq;
                                 
-- 전체 학생 취업활동 조회 view 출력
select * from vwjobact;                                

select * from tbljobact;
-- 교육생 취업활동 조회 출력
create or replace procedure procUpdateJobAct(
    
    -- 교육생 로그인
    ppw tblmember.m_password%type

)
is
    vsugang_seq number;
    pjobact tbljobact.jobact_date%type;
begin
    select sugang_seq into vsugang_seq from tblsugang s inner join tblmember m on s.member_seq = m.member_seq where m.m_password = ppw;
    
    select jobact_date into pjobact from tbljobact where sugang_seq = vsugang_seq;

    dbms_output.put_line('취업활동 내역: ' || pjobact);

end;


begin
    procUpdateJobAct(2379107);
end;


-- 교육생 취업활동 내역 입력

create or replace procedure procUpdateJobAct(
    
    -- 교육생 로그인
    ppw tblmember.m_password%type,
    pjobact tbljobact.jobact_date%type
)
is
    vsugang_seq number;
begin
    select sugang_seq into vsugang_seq from tblsugang s inner join tblmember m on s.member_seq = m.member_seq where m.m_password = ppw;

    update tbljobact set jobact_date = pjobact where sugang_seq = vsugang_seq;
end;

begin
    procUpdateJobAct(2379107, '자기소개서');
end;

-- D-08 교육생 - 협력 기업 조회

-- tblEmploye에 ent_viewdate날짜가 sysdate보다 이후면 조회가능
-- 수료일에서 6개월이 지나면 조회불가능

-- 협력 기업 검색 조회

declare
    vcursor sys_refcursor; 
    vrow tblEnterprise%rowtype;
    vdate tblsugang.complete_date%type;
begin
    --procViewEnterprise('SI', vcursor); 
    --procViewEnterprise('정규직', vcursor); 
    
    select complete_date into vdate from tblsugang where sugang_seq = 181;
    
    --if(vdate > to_date('22-05-10', 'yy-mm-dd')) then -- 출력하려면 사용할 if문
    if(vdate > sysdate) then
        procViewEnterprise('웹개발', vcursor); 
        dbms_output.put_line('==============================================================================================================================================================');  
        dbms_output.put_line(rpad('기업명 ', 22) || rpad('구인인원 ', 14) || rpad(' 구인형태 ', 16) || rpad(' 업종 ', 12) || rpad('  모집분야 ', 10));  
        dbms_output.put_line('=============================================================================================================================================================='); 
        loop
            
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            
            dbms_output.put_line ( rpad(vrow.ent_name, 20)  || ' | ' || rpad(vrow.ent_people, 12) || ' | ' || rpad(vrow.ent_type, 12)  || ' | ' || rpad(vrow.ent_sector, 10) || ' | ' || rpad(vrow.ent_recuit, 10));
            
        end loop;
        dbms_output.put_line('==============================================================================================================================================================');  
    else
        dbms_output.put_line('더 이상 기업을 조회할 수 없습니다.');
    end if;
    
end;

-- 협력 기업 전체 조회

declare
    vcursor sys_refcursor; 
    vrow tblEnterprise%rowtype;
    vdate tblsugang.complete_date%type;
begin

    select complete_date into vdate from tblsugang where sugang_seq = 181;
    
    --if(vdate > to_date('22-05-10', 'yy-mm-dd')) then -- 출력하려면 사용할 if문
    if(vdate > sysdate) then
        
        procViewEnterprise(null, vcursor); 
        dbms_output.put_line('==============================================================================================================================================================');  
        dbms_output.put_line(rpad('기업명 ', 22) || rpad('구인인원 ', 14) || rpad(' 구인형태 ', 16) || rpad(' 업종 ', 12) || rpad('  모집분야 ', 10));  
        dbms_output.put_line('=============================================================================================================================================================='); 
        loop
            
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            
            dbms_output.put_line ( rpad(vrow.ent_name, 20)  || ' | ' || rpad(vrow.ent_people, 12) || ' | ' || rpad(vrow.ent_type, 12)  || ' | ' || rpad(vrow.ent_sector, 10) || ' | ' || rpad(vrow.ent_recuit, 10));
            
        end loop;
        dbms_output.put_line('==============================================================================================================================================================');  
    else
        dbms_output.put_line('더 이상 기업을 조회할 수 없습니다.');
    end if;
    
end;



