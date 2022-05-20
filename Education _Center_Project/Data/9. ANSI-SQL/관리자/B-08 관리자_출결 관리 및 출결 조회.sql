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
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 조퇴,
    (select count(*) from tblattendance where attendance_type = '외출' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 외출,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 병가,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq and to_char(attend_date, 'mm') = '05') as 기타
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
                                    
                                    
   
   
   
   
   
--   
create or replace procedure procattendday (
    pcourse_seq tblSugang.course_seq%type,
    pyear varchar2,
    pmonth varchar2,
    pday varchar2,
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_attend_date tblAttendance.attend_date%type;
    p_attendance_type tblAttendance.attendance_type%type;
    pdate date := to_date(pyear || '-' || pmonth || '-' || pday, 'yyyy-mm-dd');
    
    cursor vcursor is select 
    su.sugang_seq as "수강생 번호",
    m.m_name as "수강생 이름",
    ad.attend_date as "출석일",
    ad.attendance_type as "상태"
from tblSugang su 
    inner join tblAttendance ad 
        on su.sugang_seq = ad.sugang_seq 
            inner join tblMember m 
                on su.member_seq = m.member_seq 
                    where su.course_seq = pcourse_seq and ad.attend_date = pdate -- to_char(attend_date, 'mm') = '05'
                        order by ad.attend_date;
                        --to_char(pyear ||'%'|| pmonth || '-%' || pday, 'yyyy-mm-dd')
                        --(pyear ||'%'|| pmonth || '-%' || pday)
begin
   open vcursor;
   dbms_output.put_line('==================================================================================================');
    dbms_output.put_line('수강생 번호 | 수강생 이름  |    출석일    | 상태');
   loop
      fetch vcursor into p_sugang_seq, p_m_name, p_attend_date, p_attendance_type;
      exit when vcursor%notfound;
        dbms_output.put_line('    ' || p_sugang_seq || ' |      ' || p_m_name || '  | ' || p_attend_date || '    | ' || p_attendance_type);
   end loop;
close vcursor;
   presult := 1;
exception
    when others then
        presult := 0;
end procattendday;


declare
    vresult number;
begin
    procattendday(28, 2022, 04, 12, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;   


        
