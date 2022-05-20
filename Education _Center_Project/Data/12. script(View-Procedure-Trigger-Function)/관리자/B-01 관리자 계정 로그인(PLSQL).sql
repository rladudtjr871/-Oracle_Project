

-- B-01 관리자 계정 로그인(PL/SQL).sql

create or replace procedure procALogin(
    pid tbladmin.id%type,
    ppassword tbladmin.password%type
)
is
    vrow tblAdmin%rowtype;
    cursor vcursor is
        select * into vrow from tblAdmin;
    vnum number;
begin
    vnum := 0;
    open vcursor;
        loop
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            if vrow.id = pid and vrow.password = ppassword
                then vnum := 1;
            end if;
        end loop;
    close vcursor;
    
    if vnum = 1 then
        dbms_output.put_line('관리자로 로그인 성공하였습니다.');
    else
        dbms_output.put_line('관리자로 로그인 실패하였습니다.');
    end if;
    
end procALogin;



------------------------------------------------
--로그인

begin
    procALogin('admin1', '2503');
end;


















