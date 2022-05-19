-- D_04 교육생 출결 통계

select * from tblAttendance;

--D_04_1 전체 통계 

select  
    count(case when attendance_type = '정상' then 1 end) as 정상,
    count(case when attendance_type = '지각' then 1 end) as 지각,
    count(case when attendance_type = '결석' then 1 end) as 결석,
    count(case when attendance_type = '조퇴' then 1 end) as 조퇴,
    count(case when attendance_type = '병가' then 1 end) as 병가,
    count(case when attendance_type = '기타' then 1 end) as 기타    
    
from tblAttendance a where a.sugang_seq = 180;



-- D_04_2  과정 진행률 보기 

select 
    cn.course_neme as 과정명,
       round(
       (select max(a.attend_date) - min(a.attend_date) from tblAttendance a where sugang_seq = 182) / (c.c_end_date - c.c_start_date)
       ,2 ) * 100 || '%' as 진행률
        
from tblCourse c 
    inner join tblSugang s on c.course_seq = s.course_seq
        inner join tblCourseName cn on c.cname_seq = cn.cname_seq
            where s.sugang_seq = 182; 



--D-04_2 월간 통계 
select   
    
    to_char(attend_date, 'mm') || '월' as 월,
    count(case when attendance_type = '정상' then 1 end) as 정상,
    count(case when attendance_type = '지각' then 1 end) as 지각,
    count(case when attendance_type = '결석' then 1 end) as 결석,
    count(case when attendance_type = '조퇴' then 1 end) as 조퇴,
    count(case when attendance_type = '병가' then 1 end) as 병가,
    count(case when attendance_type = '기타' then 1 end) as 기타,
    
    case when to_char(attend_date, 'mm') = '05' then '현재 월은 조회되지 않습니다' 
    else (
    round(
    count(case when attendance_type = '정상' then 1 end)/
    (count(case when attendance_type = '정상' then 1 end) +
    count(case when attendance_type = '지각' then 1 end) +
    count(case when attendance_type = '결석' then 1 end) +
    count(case when attendance_type = '조퇴' then 1 end) +
    count(case when attendance_type = '병가' then 1 end) +
    count(case when attendance_type = '기타' then 1 end)), 2) * 100 || '%') end as 월간출석률
    
      
from tblAttendance where sugang_seq= 219 group by to_char(attend_date, 'mm') order by 월;










