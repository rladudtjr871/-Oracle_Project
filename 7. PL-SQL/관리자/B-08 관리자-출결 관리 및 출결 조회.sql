-- B-08 관리자_출결 관리 및 출결 조회-pl수정

set serveroutput on;

-- 강의 상태 조회 
create or replace procedure procViewCourseState (
    presult out number
)
is
    p_course_seq tblcourse.course_seq%type;
    p_course_neme tblcoursename.course_neme%type;
    p_state varchar2(30);
    
    cursor vcursor 
    is 
    select 
        c.course_seq as "강의번호",
        n.course_neme as "강의 과정명",
        case 
            when sysdate < c.c_start_date then '강의예정'
            when sysdate between c.c_start_date and c.c_end_date then '강의중'
            when sysdate > c.c_end_date then '강의종료' 
        end as "강의상태"
    from tblCourse c 
        inner join tblcoursename n 
            on c.cname_seq = n.cname_seq 
                order by c.course_seq desc;
begin
    open vcursor;
        dbms_output.put_line('======================================================================================');
        dbms_output.put_line('강의번호 | ' ||  '                         강의 과정명                         | ' || ' 강의 상태');
        loop
            fetch vcursor into p_course_seq, p_course_neme, p_state;
            exit when vcursor%notfound;
            dbms_output.put_line('   ' ||rpad(p_course_seq, 5, ' ') || ' | ' ||  rpad(p_course_neme, 60, ' ')  || ' |   ' || rpad(p_state, 10, ' '));
        end loop;
        dbms_output.put_line('======================================================================================');
    close vcursor;
    presult := 1;
exception
    when others then
        presult := 0;
end procViewCourseState;


---

-- 강의 상태 조회
declare
    vresult number;
begin
    procViewCourseState(vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/

-- 특정 개설 과정 출결 전체 조회 
create or replace procedure procCourseAttendAll (
    pcourse_seq tblSugang.course_seq%type,
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_attend_a number;
    p_attend_b number;
    p_attend_c number;
    p_attend_d number;
    p_attend_e number;
    p_attend_f number;
    
    cursor vcursor is select 
    distinct s.sugang_seq,
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq) as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq) as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq) as 조퇴,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq) as 병가,
    (select count(*) from tblattendance where attendance_type = '결석' and sugang_seq = s.sugang_seq) as 결석,
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
                                    where c.course_seq = pcourse_seq
                                        order by s.sugang_seq;
begin
	open vcursor;
	dbms_output.put_line('==================================================================================================');
    dbms_output.put_line(rpad('교육생 번호', 12, ' ') || '|' || rpad('교육생 이름', 12, ' ')  ||  '|' ||
                         rpad('정상', 4, ' ')  || '|' || rpad('지각', 4, ' ') || '|' || rpad('조퇴', 4, ' ') || '|' ||
                         rpad('병가', 4, ' ')  || '|' || rpad('결석', 4, ' ') || '|' || rpad('기타', 4, ' '));
	loop
		fetch vcursor into p_sugang_seq, p_m_name, p_attend_a, p_attend_b, p_attend_c, p_attend_d, p_attend_e, p_attend_f;
		exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_sugang_seq, 12, ' ') || '|' || rpad(p_m_name, 12, ' ')  ||  '|' ||
                         lpad(p_attend_a, 4, ' ')  || '|' || lpad(p_attend_b, 4, ' ') || '|' || lpad(p_attend_c, 4, ' ') || '|' || lpad(p_attend_d, 4, ' ') || '|' || 
                         lpad(p_attend_e, 4, ' ')  || '|' || lpad(p_attend_f, 4, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procCourseAttendAll;
/
-- 
declare
    vresult number;
begin
    procCourseAttendAll(25, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/



-- 특정 개설 과정 연도 조회
create or replace procedure procCourseAttendYear (
    pcourse_seq tblSugang.course_seq%type,
    pyear       varchar2,
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_attend_a number;
    p_attend_b number;
    p_attend_c number;
    p_attend_d number;
    p_attend_e number;
    p_attend_f number;
    
    cursor vcursor is select 
    distinct s.sugang_seq,
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 조퇴,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 병가,
    (select count(*) from tblattendance where attendance_type = '결석' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 결석,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq and a.attend_date like (pyear || '/%')) as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    where c.course_seq = pcourse_seq
                                        order by s.sugang_seq;
begin
	open vcursor;
	dbms_output.put_line('==================================================================================================');
    dbms_output.put_line(rpad('교육생 번호', 12, ' ') || '|' || rpad('교육생 이름', 12, ' ')  ||  '|' ||
                         rpad('정상', 4, ' ')  || '|' || rpad('지각', 4, ' ') || '|' || rpad('조퇴', 4, ' ') || '|' || 
                         rpad('병가', 4, ' ')  || '|' || rpad('결석', 4, ' ') || '|' || rpad('기타', 4, ' '));
	loop
		fetch vcursor into p_sugang_seq, p_m_name, p_attend_a, p_attend_b, p_attend_c, p_attend_d, p_attend_e, p_attend_f;
		exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_sugang_seq, 12, ' ') || '|' || rpad(p_m_name, 12, ' ')  ||  '|' ||
                         lpad(p_attend_a, 4, ' ')  || '|' || lpad(p_attend_b, 4, ' ') || '|' || lpad(p_attend_c, 4, ' ') || '|' || lpad(p_attend_d, 4, ' ') || '|' || 
                         lpad(p_attend_e, 4, ' ')  || '|' || lpad(p_attend_f, 4, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procCourseAttendYear;
/
-- 
declare
    vresult number;
begin
    procCourseAttendYear(25, '22', vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/

-- 특정 개설 과정 월 조회
create or replace procedure procCourseAttendMonth (
    pcourse_seq tblSugang.course_seq%type,
    pYearMonth  varchar2,
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_attend_a number;
    p_attend_b number;
    p_attend_c number;
    p_attend_d number;
    p_attend_e number;
    p_attend_f number;
    
    cursor vcursor is select 
    distinct s.sugang_seq,
    m.m_name,
    (select count(*) from tblattendance where attendance_type = '정상' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 정상,
    (select count(*) from tblattendance where attendance_type = '지각' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 지각,
    (select count(*) from tblattendance where attendance_type = '조퇴' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 조퇴,
    (select count(*) from tblattendance where attendance_type = '병가' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 병가,
    (select count(*) from tblattendance where attendance_type = '결석' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 결석,
    (select count(*) from tblattendance where attendance_type = '기타' and sugang_seq = s.sugang_seq and attend_date like (pYearMonth || '%')) as 기타
from tblcourse c
    inner join tblcoursename cn
        on c.cname_seq = cn.cname_seq
            inner join tblsugang s
                on c.course_seq = s.course_seq
                    inner join tblmember m
                        on s.member_seq = m.member_seq
                            inner join tblattendance a
                                on s.sugang_seq = a.sugang_seq
                                    where c.course_seq = pcourse_seq
                                        order by s.sugang_seq;
begin
	open vcursor;
	dbms_output.put_line('==================================================================================================');
    dbms_output.put_line(rpad('교육생 번호', 12, ' ') || '|' || rpad('교육생 이름', 12, ' ')  ||  '|' ||
                         rpad('정상', 4, ' ')  || '|' || rpad('지각', 4, ' ') || '|' || rpad('조퇴', 4, ' ') || '|' ||
                         rpad('병가', 4, ' ')  || '|' || rpad('결석', 4, ' ') || '|' || rpad('기타', 4, ' '));
	loop
		fetch vcursor into p_sugang_seq, p_m_name, p_attend_a, p_attend_b, p_attend_c, p_attend_d, p_attend_e, p_attend_f;
		exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_sugang_seq, 12, ' ') || '|' || rpad(p_m_name, 12, ' ')  ||  '|' ||
                         lpad(p_attend_a, 4, ' ')  || '|' || lpad(p_attend_b, 4, ' ') || '|' || lpad(p_attend_c, 4, ' ') || '|' || lpad(p_attend_d, 4, ' ') || '|' || 
                         lpad(p_attend_e, 4, ' ')  || '|' || lpad(p_attend_f, 4, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procCourseAttendMonth;
/
-- 
declare
    vresult number;
begin
    procCourseAttendMonth(25, '22/04', vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/


-- 특정 개설 과정 일 조회
create or replace procedure procCourseAttendDay (
    pcourse_seq tblSugang.course_seq%type,
    pdate varchar2, 
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_attend_date tblAttendance.attend_date%type;
    p_attendance_type tblAttendance.attendance_type%type;
    
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
                    where su.course_seq = pcourse_seq and ad.attend_date = pdate
                        order by ad.attend_date;
begin
   open vcursor;
   dbms_output.put_line('==================================================================================================');
    dbms_output.put_line(rpad('교육생 번호', 12, ' ') || '|' || rpad('교육생 이름', 12, ' ')  ||  '|' || rpad('출석일', 10, ' ')  || '|' || rpad('상태', 4, ' '));
   loop
      fetch vcursor into p_sugang_seq, p_m_name, p_attend_date, p_attendance_type;
      exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_sugang_seq, 12, ' ') || '|' || rpad(p_m_name, 12, ' ')  ||  '|' || rpad(p_attend_date, 10, ' ')  || '|' || rpad(p_attendance_type, 4, ' '));
   end loop;
close vcursor;
   presult := 1;
exception
    when others then
        presult := 0;
end procCourseAttendDay;
/
declare
    vresult number;
begin
    procCourseAttendDay(25, '22/03/04', vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/


-- 특정 교육생 출결 조회
create or replace procedure procCourseStuAttend (
    pnum tblAttendance.sugang_seq%type,
    presult out number
)
is
    p_m_name tblmember.m_name%type;
    p_attend_date tblAttendance.attend_date%type;
    p_attendance_type tblAttendance.attendance_type%type;
	cursor vcursor 
    is 
    select
        m.m_name,
        a.attend_date, 
        a.attendance_type 
    from tblcourse c
    inner join tblsugang s
        on c.course_seq = s.course_seq
            inner join tblmember m
                on s.member_seq = m.member_seq
                    inner join tblattendance a
                        on s.sugang_seq = a.sugang_seq
                            where a.sugang_seq = pnum;
begin
	open vcursor;
	dbms_output.put_line('=========================================================================================================');
    dbms_output.put_line(rpad('교육생 이름', 12, ' ') || ' | ' || rpad('출석일', 10, ' ') || ' | ' || rpad('상태', 4, ' '));
	loop
		fetch vcursor into p_m_name, p_attend_date, p_attendance_type;
		exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_m_name, 12, ' ') || ' | ' || rpad(p_attend_date, 10, ' ') || ' | ' || rpad(p_attendance_type, 4, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procCourseStuAttend;
/


-- 학생 개인 출결 조회하기
declare
    vresult number;
begin
    procCourseStuAttend(182, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
/