--D_02 출결등록

-- 출석할때 
insert into tblAttendance(attendance_seq, attend_date, in_time, out_time, attendance_type, sugang_seq) 
        values (시퀀스, sysdate, to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'), to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss')	, '결석', 183);
        
ROLLBACK;




-- 퇴실할때 (입실시간이 9시 10분 이전인 경우)
update tblAttendance
    set 
    out_time = to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'),
    attendance_type = '정상' 
    
where to_char(attend_date, 'yyyy/mm/dd') = to_char(sysdate, 'yyyy/mm/dd') and  sugang_seq = 183; 




-- 퇴실할 때 (입실시간이 9시 10분 이후일 경우) 
update tblAttendance
    set 
    out_time = to_date(sysdate , 'yyyy-mm-dd hh24:mi:ss'),
    attendance_type = '지각' 
    
where to_char(attend_date, 'yyyy/mm/dd') = to_char(sysdate, 'yyyy/mm/dd') and  sugang_seq = 수강번호; 


