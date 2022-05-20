-- 교사 과정 스케줄 조회 프로시저
create or replace procedure proct_Schedule (
    pt_name tblteacher.t_name%type,
    pt_password tblteacher.t_password%type,
    presult out number
)
is
    p_course_seq tblcourse.course_seq%type;
    p_course_neme tblcoursename.course_neme%type;
    p_state varchar2(30);
    
    cursor vcursor is select 
    c.course_seq as "강의번호",
    n.course_neme as "강의 과정명", 
    case when sysdate < c.c_start_date then '강의예정'
    when sysdate between c.c_start_date and c.c_end_date then '강의중'
    when sysdate > c.c_end_date then '강의종료' end as "강의상태"
    from tblCourse c 
        inner join tblcoursename n 
            on c.cname_seq = n.cname_seq 
                where c.teacher_seq = 
                    (select teacher_seq from tblteacher where t_name = pt_name and t_password = pt_password) order by c.c_end_date desc;
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
end proct_Schedule;



-- 내 강의스케줄 조회하기
declare
    vresult number;
begin
    proct_Schedule('최경하', 2532102, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;




-- 특정 강의 선택 해당 강의 내 교육생 출결현황 프로시저
create or replace procedure procattendall (
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
                                    where c.course_seq = pcourse_seq;
begin
	open vcursor;
	dbms_output.put_line('==================================================================================================');
    dbms_output.put_line('수강생 번호 | 수강생 이름  |  정상  | 지각 | 조퇴 | 외출 | 병가 | 기타');
	loop
		fetch vcursor into p_sugang_seq, p_m_name, p_attend_a, p_attend_b, p_attend_c, p_attend_d, p_attend_e, p_attend_f;
		exit when vcursor%notfound;
        dbms_output.put_line('    ' || p_sugang_seq || ' |      ' || p_m_name || '  | ' || p_attend_a || '    | ' || p_attend_b  || '    | ' || p_attend_c 
        || '    | ' || p_attend_d || '    | ' || p_attend_e || '    | ' || p_attend_f);
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procattendall;






-- 특정 강의 선택 해당 강의 내 교육생 출결현황 조회하기
declare
    vresult number;
begin
    procattendall(28, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;




-- 년도(year)로 검색하기 프로시저
create or replace procedure procattendyear (
    pcourse_seq tblSugang.course_seq%type,
    pyear varchar2,
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
                    where su.course_seq = pcourse_seq and to_char(ad.attend_date, 'yyyy-mm-dd') like ('%' || pyear ||'%')
                        order by ad.attend_date;
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
end procattendyear;



-- 년도(year)로 검색하기
declare
    vresult number;
begin
    procattendyear(28, 2022/04, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;






-- 월(month)로 검색하기 프로시저
create or replace procedure procattendmon (
    pcourse_seq tblSugang.course_seq%type,
    pyear varchar2,
    pmonth varchar2,
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
                    where su.course_seq = pcourse_seq and to_char(ad.attend_date, 'yyyy-mm-dd') like (pyear ||'%'|| pmonth || '-%')
                        order by ad.attend_date;
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
end procattendmon;



-- 월(month)로 검색하기
declare
    vresult number;
begin
    procattendmon(28, 2022, 04, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;




-- 일(day)로 검색하기 프로시저
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



-- 일(day)로 검색하기
declare
    vresult number;
begin
    procattendday(28, 2022, 04, 1, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;






-- 학생 개인 출결 조회하기 프로시저
create or replace procedure procstuattend (
    pnum tblAttendance.sugang_seq%type,
    presult out number
)
is
    p_attend_date tblAttendance.attend_date%type;
    p_attendance_type tblAttendance.attendance_type%type;
    
	cursor vcursor is select 
    attend_date as "출석일", attendance_type as "상태" from tblAttendance where sugang_seq = pnum;
begin
	open vcursor;
	dbms_output.put_line('=========================================================================================================');
    dbms_output.put_line(rpad('출석일', 10, ' ') || ' | ' || rpad('상태', 5, ' '));
	loop
		fetch vcursor into p_attend_date, p_attendance_type;
		exit when vcursor%notfound;
        dbms_output.put_line(rpad(p_attend_date, 10, ' ') || ' | ' || rpad(p_attendance_type, 5, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procstuattend;



-- 학생 개인 출결 조회하기
declare
    vresult number;
begin
    procstuattend (184, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
