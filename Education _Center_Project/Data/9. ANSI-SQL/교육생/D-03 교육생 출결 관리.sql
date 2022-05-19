--D-03 교육생 출결 관리 및 출결 조회  


-- D_03_1 출결 현황 조회 

-- 날짜별 조회
select attend_date, attendance_type from tblAttendance where sugang_seq = 182 and attend_date = TO_DATE('2022-03-01' , 'yyyy/mm/dd');

-- 월별 조회 
select attend_date, attendance_type from tblAttendance where sugang_seq = 180 and to_char(attend_date, 'mm') = '03';

-- 연도별 조회 
select attend_date, attendance_type from tblAttendance where sugang_seq = 180 and to_char(attend_date, 'YYYY') = '2022';




