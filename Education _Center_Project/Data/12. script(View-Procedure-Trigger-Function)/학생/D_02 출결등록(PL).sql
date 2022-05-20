--D_02 출결등록



-- 출석 시 

create or replace procedure procAttendIn(
    psugang_num number
)
is
    vprogress tblSugang.progress%type;
begin

    select progress into vprogress from tblSugang where sugang_seq = psugang_num;
    
    
    if 
        vprogress = '수강중'
    
    then
        insert into tblAttendance(attendance_seq, attend_date, in_time, out_time, attendance_type, sugang_seq) 
            values ((select max(attendance_seq) from tblAttendance) + 1
                    , sysdate, to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'), null, '결석', psugang_num);
        dbms_output.put_line('출석처리가 완료되었습니다.');        
            
    else
        dbms_output.put_line('수강중이지 않은 학생은 출석할 수 없습니다');
    
    end if;

    exception 
    when others then 
        dbms_output.put_line('오류발생!!!');
    
    
end;
/



-- 실행
begin
    procAttendIn(182);
end;
/





--------------------------------------------------------------------------------------------------

-- 퇴실시


create or replace procedure procAttendOut(
    psugang_num number
)
is
     vprogress tblSugang.progress%type;
     vin_time date;
     vbaddate number;
begin

    select progress into vprogress from tblSugang where sugang_seq = psugang_num;
    select in_time into vin_time from tblAttendance where attendance_seq = (select max(attendance_seq) from tblattendance);
    
    
    if 
        vprogress = '수강중' and 
        to_date(vIn_time, 'hh24:mi:ss') < to_date('09:10:00', 'hh24:mi:ss') 
       
    then
    
        update tblAttendance
        set
        out_time =  to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'), 
        attendance_type = '정상'
        where attendance_seq = (select max(attendance_seq) from tblAttendance);
        dbms_output.put_line('정상출결 완료');
       
    elsif
        vprogress = '수강중' and 
        to_date(vIn_time, 'hh24:mi:ss') >= to_date('09:10:00', 'hh24:mi:ss') 
        
    then
        update tblAttendance
        set
        out_time =  to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'), 
        attendance_type = '지각'
        where attendance_seq = (select max(attendance_seq) from tblAttendance);
        dbms_output.put_line('지각처리');
        
    else
    
        dbms_output.put_line('수강중이지 않은 학생은 출석할 수 없습니다');
    
    end if;
        
    
----결석, 지각점수 15점 이상 자동 중도탈락
    select 
        count(case when attendance_type = '지각' then 1 end) +
        count(case when attendance_type = '결석' then 1 end)*3 
    into    
        vbaddate
    from tblAttendance
         where sugang_seq = psugang_num;
    
    if 
        vbaddate >= 15
    then
        update tblSugang
        set
          progress = '중도탈락'  
        where sugang_seq = psugang_num;  
        
        insert into tblStustop values((select max(stustop_seq)+1 from tblStustop), sysdate, psugang_num);
        dbms_output.put_line('결석, 지각 횟수 누적으로 자동 중도탈락 처리됩니다');
        
    end if;
    
    exception 
    when others then 
        dbms_output.put_line('오류발생!!!');
    
end procAttendOut;
/







-- 출석실행
begin
    procAttendIn(201);
end;
/


--퇴실
begin
    procAttendOut(201);
end;
/

select * from tblAttendance where sugang_seq = 201;
select * from tblSugang where sugang_seq = 201;
select * from tblStustop;

rollback;


