--D_05 훈련비 확인 기능



create or replace procedure procPay(
    psugang_num number
)
is
    vmonth  varchar2(20);
    vnormal number;
    vlate   number;
    vabsent number;
    valrey  number;
    vsick   number;
    velse   number;
    vpay    varchar2(30);
    
    cursor vcursor
    is
    select   
    
        to_char(attend_date, 'mm'),
        count(case when attendance_type = '정상' then 1 end),
        count(case when attendance_type = '지각' then 1 end),
        count(case when attendance_type = '결석' then 1 end),
        count(case when attendance_type = '조퇴' then 1 end),
        count(case when attendance_type = '병가' then 1 end),
        count(case when attendance_type = '기타' then 1 end)
             
    from tblAttendance where sugang_seq= psugang_num group by to_char(attend_date, 'mm') order by to_char(attend_date, 'mm');

    
begin
    
    dbms_output.put_line('====================================================');
    dbms_output.put_line('          훈련비 지급내역');
    dbms_output.put_line('====================================================');
    dbms_output.put_line('월  | 정상 | 지각 | 결석 | 조퇴 | 병결 | 기타 | 지급액');
    dbms_output.put_line('----------------------------------------------------');

    
    open vcursor;
    loop
        fetch vcursor into vmonth, vnormal, vlate, vabsent, valrey, vsick, velse;
        exit when vcursor%notfound;
        
        if
            vlate + vabsent*3 >= 9 
        then
            vpay := '지급불가';
        elsif     
            vmonth = to_char(sysdate, 'mm') 
        then
            vpay := '다음달 1일에 지급';
        else
            vpay := 116000 - (floor((vlate + vabsent*3)/3)*5000);
        end if;
        
        
        dbms_output.put_line(vmonth || '  | ' ||
                            lpad(vnormal, 3, ' ') || '  | ' ||
                            lpad(vlate, 3, ' ')  || '  | ' ||
                            lpad(vabsent, 3, ' ') || '  | ' ||
                            lpad(valrey, 3, ' ') || '  | ' ||
                            lpad(vsick, 3, ' ') || '  | ' ||
                            lpad(velse, 3, ' ') || '  | ' ||
                            vpay );
        
    
    end loop;
    close vcursor;
    
end procPay;
/


begin
    procPay(201);
end;
/



