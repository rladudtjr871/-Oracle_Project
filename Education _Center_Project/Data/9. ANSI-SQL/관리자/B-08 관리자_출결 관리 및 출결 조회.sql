-- B-08 관리자_출결 관리 및 출결 조회.sql

-- 출결 현황 조회(입력/출력)                      
select 
    distinct
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 조퇴,
    (select count(*) from tblattendance where attendance_type = '외출' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 외출,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 병가,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq and to_char(attend_date, 'yy') = '22') as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    order by m.m_name;    
                               
select 
    distinct
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 조퇴,
    (select count(*) from tblattendance where attendance_type = '외출' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 외출,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 병가,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '04') as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    order by m.m_name;   
                                        
select 
    distinct
    m.m_name,
    a.attend_date,
    a.attendance_type
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    where a.attend_date = '22-05-05'
                                        order by m.m_name; 
       
       

-- 특정 개설 과정 선택(입력/출력)
select 
    distinct
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq) as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq) as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq) as 조퇴,
    (select count(*) from tblattendance where attendance_type = '외출' and sugang_seq = s.sugang_seq) as 외출,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq) as 병가,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq) as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    where c.course_seq = 25;

-- 특정인원 출결 현황 조회
select 
    distinct
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq) as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq) as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq) as 조퇴,
    (select count(*) from tblattendance where attendance_type = '외출' and sugang_seq = s.sugang_seq) as 외출,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq) as 병가,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq) as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    where c.course_seq = 25 and s.sugang_seq = 185;
                                    
                                    
        
