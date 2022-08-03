-- 내 종료된 과목 조회 프로시저
create or replace procedure proct_endcs (
    pt_name tblteacher.t_name%type,
    pt_password tblteacher.t_password%type,
    presult out number
)
is
    pcsub_seq tblCSub.csub_seq%type;
    psubname tblSubjectname.subname%type;
    pstate varchar2(30);
    
    cursor vcursor is select 
    cs.csub_seq as "과목번호",
    sj.subname as "과목명",
    case 
        when cs.csend_date < sysdate then '진행 종료'
    end as "진행 상태"
from tblCSub cs 
    inner join tblCourse c 
        on cs.course_seq = c.course_seq 
            inner join tblSubjectname sj 
                on cs.subname_seq = sj.subname_seq 
                    where cs.csend_date < sysdate and c.teacher_seq = 
                        (select teacher_seq from tblteacher where t_name = pt_name and t_password = pt_password)
                            order by cs.csstart_date asc;
begin
    open vcursor;
	dbms_output.put_line('=======================================================================================================================');
    dbms_output.put_line('과목번호  |  ' || '        과목명         |  ' || '진행 상태');
	loop
		fetch vcursor into pcsub_seq, psubname, pstate;
		exit when vcursor%notfound;
        dbms_output.put_line('    ' || rpad(pcsub_seq, 6, ' ')  || '|     ' ||  rpad(psubname, 20, ' ') || '|  ' ||  rpad(pstate, 10, ' '));
	end loop;
close vcursor;
    presult := 1;
exception
    when others then
        presult := 0;
end proct_endcs;



-- 내 종료된 과목 조회하기
declare
    vresult number;
begin
    proct_endcs('최경하', 2532102, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;







-- 종료된 과목리스트 조회하기 프로시저
create or replace procedure procendCSub_a (
    pcsub_seq tblCSub.csub_seq%type,
    pt_name tblteacher.t_name%type,
    pt_password tblteacher.t_password%type,
    presult out number
)
is
    p_csub_seq tblCSub.csub_seq%type;
    p_course_neme tblcoursename.course_neme%type;
    p_c_start_date tblcourse.c_start_date%type;
    p_c_end_date tblcourse.c_end_date%type;
    p_room_name tblroom.room_name%type;
    p_subname  tblsubjectname.subname%type;
    p_csstart_date tblCSub.csstart_date%type;
    p_csend_date tblCSub.csend_date%type;
    p_attend_point tblsubtpoint.attend_point%type;
    p_pilgi_point tblsubtpoint.pilgi_point%type;
    p_silgi_point tblsubtpoint.silgi_point%type;
    p_check varchar2(5);
    
    cursor vcursor is select 
    distinct 
    cs.csub_seq as "개설과목번호",
    cn.course_neme as "개설과정명",
    c.c_start_date as "과정시작일",
    c.c_end_date as "과정종료일",
    r.room_name as "강의실명",
    sj.subname as "개설과목명",
    cs.csstart_date as "과목시작일",
    cs.csend_date as "과목종료일",
    sp.attend_point as "출결 배점",
    sp.pilgi_point as "필기 배점",
    sp.silgi_point as "실기 배점",
    (case when s.silgi_score is not null then 'Y' else 'N' end) as "성적등록여부"
from tblCSub cs
    left outer join tblCourse c 
        on cs.course_seq = c.course_seq
            left outer join tblCourseName cn 
                on c.cname_seq = cn.cname_seq
                    left outer join tblRoom r 
                        on c.room_seq = r.room_seq
                            left outer join tblSubjectName sj 
                                on cs.subname_seq = sj.subname_seq
                                    left outer join tblSubjectTxt st 
                                        on sj.subname_seq = st.subname_seq
                                            left outer join tblTextBook tb 
                                                on st.txtbook_seq = tb.txtbook_seq
                                                    left outer join tblSugang su 
                                                        on c.course_seq = su.course_seq
                                                            left outer join tblSubtPoint sp 
                                                                on sp.csub_seq = cs.csub_seq
                                                                    left outer join tblScore s 
                                                                        on cs.csub_seq = s.csub_seq
                                                                            where cs.csub_seq = pcsub_seq and c.teacher_seq = 
                                                                                (select teacher_seq from tblteacher where t_name = pt_name and t_password = pt_password);
begin
    open vcursor;
	dbms_output.put_line('===================================================================================================');
    dbms_output.put_line('개설과목번호 | ' || '                           개설과정명                           | '
    || ' 과정시작일 |' || ' 과정종료일 |' || ' 강의실명 |' || '         개설과목명         |' || '  과목시작일   |' 
    || '  과목종료일   |' || '  출결 배점  |' || '  필기 배점  |' || '  실기 배점  |');
	loop
		fetch vcursor into p_csub_seq, p_course_neme, p_c_start_date, p_c_end_date, p_room_name, p_subname, p_csstart_date, p_csend_date, p_attend_point, p_pilgi_point, p_silgi_point, p_check;
		exit when vcursor%notfound;
        dbms_output.put_line('    ' || rpad(p_csub_seq, 5, ' ') || '    |   '
        || rpad(p_course_neme, 60, ' ')  || '  | '
        || rpad(p_c_start_date, 10, ' ')  || ' | '
        || rpad(p_c_end_date, 10, ' ')  || ' | '
        || rpad(p_room_name, 10, ' ')  || '  | '
        || rpad(p_subname, 20, ' ') || '  |   '
        || rpad(p_csstart_date, 10, ' ')  || '  |   '
        || rpad(p_csend_date, 10, ' ')  || '  |   '
        || rpad(p_attend_point, 10, ' ')  || '  |   '
        || rpad(p_pilgi_point, 10, ' ')  || '  |   '
        || rpad(p_silgi_point, 10, ' ')  || '  |   '
        || rpad(p_check, 5, ' '));
	end loop;
close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end procendCSub_a;




-- 종료된 과목리스트 조회하기
declare
    vresult number;
begin
    procendCSub_a(142, '최경숙', 2532102, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;





-- 내 종료된 과목 > 과목선택 > 회원정보 조회하기 프로시저
create or replace procedure proccslist_a (
    pnum tblCsub.csub_seq%type,
    presult out number
)
is
    p_sugang_seq tblSugang.sugang_seq%type;
    p_m_name tblMember.m_name%type;
    p_m_tel tblMember.m_tel%type;
    p_progress tblSugang.progress%type;
    p_stop_date tblStustop.stop_date%type;
    p_attend_score tblScore.attend_score%type;
    p_pilgi_score tblScore.pilgi_score%type;
    p_silgi_score tblScore.silgi_score%type;
    
	cursor vcursor is select
    su.sugang_seq as "수강생 번호",
    m.m_name as "수강생 이름",
    m.m_tel as "전화번호",
    su.progress as "수강상태",
    ss.stop_date as "중도탈락일",
    s.attend_score as "출결점수",
    s.pilgi_score as "필기점수",
    s.silgi_score as "실기점수"
from tblMember m
    inner join tblSugang su
        on m.member_seq = su.member_seq
            left outer join tblStustop ss
                on su.sugang_seq = ss.sugang_seq
                    inner join tblCourse c 
                        on su.course_seq = c.course_seq 
                            inner join tblCsub cs 
                                on c.course_seq = cs.course_seq 
                                    left outer join tblScore s 
                                        on cs.csub_seq = s.csub_seq 
                                            where cs.csub_seq = pnum
                                                order by su.sugang_seq; 
begin
    open vcursor;
        dbms_output.put_line('============================================================================================================');
        dbms_output.put_line('수강생번호 | ' || ' 수강생이름 | '
    || ' 전화번호 |' || ' 수강상태 |' || ' 중도탈락일 |' || '  출결 점수  |' || '  필기 점수  |' || '  실기 점수  |');
        loop
            fetch vcursor into p_sugang_seq, p_m_name, p_m_tel, p_progress, p_stop_date, p_attend_score, p_pilgi_score, p_silgi_score;
            exit when vcursor%notfound;
            dbms_output.put_line('   ' || rpad(p_sugang_seq, 5, ' ') || ' | ' 
            || rpad(p_m_name, 10, ' ') || ' | ' 
            || rpad(p_m_tel, 15, ' ') || ' | ' 
            || rpad(p_progress, 10, ' ') || ' | ' 
            || rpad(p_stop_date, 10, ' ') || ' | ' 
            || rpad(p_attend_score, 5, ' ') || ' | ' 
            || rpad(p_pilgi_score, 5, ' ') || ' | ' 
            || rpad(p_silgi_score, 5, ' ') || ' | ' 
            );
        end loop;
    close vcursor;
	presult := 1;
exception
    when others then
        presult := 0;
end proccslist_a;



-- 내 종료된 과목 > 과목선택 > 회원정보 조회하기
declare
    vresult number;
begin
    proccslist_a (143, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;



-- 학생 성적 입력 프로시저
create or replace procedure procsung_a (
    psugang_seq tblScore.sugang_seq%type,
    p_attend tblScore.attend_score%type,
    p_pilgi tblscore.pilgi_score%type,
    p_silgi tblscore.silgi_score%type,
    p_csubnum tblscore.csub_seq%type,
    presult out number
)
is
begin
    insert into tblScore values ((select max(score_seq)+1 from tblScore), p_attend, p_pilgi, p_silgi, p_csubnum, (select sugang_seq from tblSugang where sugang_seq = psugang_seq));
    presult := 1;
exception
    when others then
        presult := 0;
end procsung_a;



-- 학생 성적 입력하기
declare
    vresult number;
begin
    procsung_a(5, 20, 30, 50, 1, vresult); -- 수강생번호, 출석점수, 필기점수, 실기점수, 강의과목번호
    if vresult = 1 then
        dbms_output.put_line('성적 등록에 성공하셨습니다.');
    else
        dbms_output.put_line('성적 등록에 실패하셨습니다.');
    end if;
end;


-- 들어갔는지 확인
select * from tblScore where sugang_seq = 5;