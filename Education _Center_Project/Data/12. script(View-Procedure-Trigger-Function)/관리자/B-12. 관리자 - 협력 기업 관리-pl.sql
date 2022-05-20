-- B-12. 관리자 - 협력 기업 관리.sql PL/SQL

-- 협력 기업 등록
create or replace procedure procAddEnterprise(
    pent_name in tblenterprise.ent_name%type,
    pent_people in tblenterprise.ent_people%type,
    pent_type in tblenterprise.ent_type%type,
    pent_sector in tblenterprise.ent_sector%type,
    pent_recuit in tblenterprise.ent_recuit%type,
    prseult out number 
)
is
begin
    
    if pent_name is null or pent_type is null or pent_recuit is null or pent_sector is null then -- 기업명, 구인형태, 업종, 모집부분 미입력 시 실패 out = 3
        prseult := 2;
    elsif pent_people is null then -- 인원 수 미지정 기본값 0으로 out = 2
        insert into tblenterprise (enterprise_seq, ent_name, ent_people, ent_type, ent_sector, ent_recuit) 
            values ((select max(enterprise_seq)+1 from tblenterprise), pent_name, 0, pent_type, pent_sector, pent_recuit);
        prseult := 3;
    else -- 모든 컬럼값 입력시 insert 성공 out = 1
        insert into tblenterprise (enterprise_seq, ent_name, ent_people, ent_type, ent_sector, ent_recuit) 
                values ((select max(enterprise_seq)+1 from tblenterprise), pent_name, pent_people, pent_type, pent_sector, pent_recuit);
        prseult := 1;
    end if;
        
exception
    when others then
        prseult := 0; -- 실패 out = 0
end procAddEnterprise;


select * from tblenterprise;

set serverout on;

declare
    vresult number;
begin
    
    -- procAddEnterprise('테스트기업', 2, '정규직', 'SI', '웹개발', vresult);
    procAddEnterprise('테스트기업2', null, '정규직', 'OP', '웹개발', vresult);
    if vresult = 1 then 
        dbms_output.put_line('입력이 성공했습니다.');
    elsif vresult = 2 then 
        dbms_output.put_line('기본값이 적용된 입력이 성공했습니다.');
    elsif vresult = 3 then 
        dbms_output.put_line('입력이 실패했습니다. <기업명, 구인형태, 업종, 모집부분은 필수입력사항입니다.>');
    else 
        dbms_output.put_line('입력에 실패했습니다.');
    end if;  
    
end;

-- 협력 기업 검색 조회 

create or replace procedure procViewEnterprise(
    pinput in varchar2,
    pcursor out sys_refcursor 
)
is
begin

    open pcursor
    for
    select * from tblEnterprise where ent_type like '%'||pinput||'%' or ent_recuit like '%'||pinput||'%' or ent_sector like '%'||pinput||'%';
    
end;


declare
    vcursor sys_refcursor; 
    vrow tblEnterprise%rowtype;
begin
    --procViewEnterprise('SI', vcursor); 
    --procViewEnterprise('정규직', vcursor); 
    procViewEnterprise('웹개발', vcursor); 
    dbms_output.put_line('===============================================================================================');  
    dbms_output.put_line(rpad('기업명 ', 24, ' ') || ' | ' || rpad('구인인원 ', 14, ' ') || ' | ' || rpad('구인형태 ', 16, ' ') || ' | ' || rpad('업종 ', 12, ' ') || ' | ' || rpad('모집분야 ', 10, ' '));  
    dbms_output.put_line('==============================================================================================='); 
    loop
        
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        
        dbms_output.put_line ( rpad(vrow.ent_name, 24, ' ')  || ' | ' || rpad(vrow.ent_people, 14, ' ') || ' | ' || rpad(vrow.ent_type, 16, ' ')  || ' | ' || rpad(vrow.ent_sector, 12, ' ') || ' | ' || rpad(vrow.ent_recuit, 10, ' '));
        
    end loop;
    dbms_output.put_line('===============================================================================================');  
end;

select * from tblenterprise;

-- 협력 기업 전체 조회 
create or replace view vwtblEnterprise
as
select 
    ent_name as 기업명, 
    ent_people as 구인인원,
    ent_type as 구인형태,
    ent_sector as 업종,
    ent_recuit as 모집부분
from tblenterprise;

select * from vwtblEnterprise;

-- 협력 기업 수정













-- 협력 기업 삭제

create or replace procedure procDelEnterprise(
    pseq in number,
    presult out number
)
is
begin
    delete from tblenterprise where enterprise_seq = pseq;
    presult := 1;
exception
    when others then
        presult := 0;
end;


declare
    vresult number;
begin

    procDelEnterprise(53, vresult);
    if(vresult = 1) then
        dbms_output.put_line('삭제가 성공했습니다.');
    else 
        dbms_output.put_line('삭제에 실패했습니다.');
    end if;
    
end;




