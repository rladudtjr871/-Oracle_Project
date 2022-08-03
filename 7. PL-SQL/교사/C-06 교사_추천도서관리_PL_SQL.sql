-- 과목관련 교재 전체 조회 뷰
create or replace view vwtblTextBook
as
select 
    distinct sn.subname_seq as "과목번호",
    sn.subname as "과목명",
    tb.name as "교재명"
from tblSubjectName sn
    inner join tblSubjectTxt st 
        on st.subname_seq = sn.subname_seq
            inner join tblTextBook tb 
                on st.txtbook_seq = tb.txtbook_seq
                    order by sn.subname_seq;


-- 과목관련 교재 전체 조회하기
select * from vwtblTextBook;



-- 내 강의스케줄 조회하기 프로시저
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
    proct_Schedule('최경숙', 2532102, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;





-- 내 강의스케줄 강의 선택 조회하기 프로시저
create or replace procedure proct_csub (
    pt_name tblteacher.t_name%type,
    pt_password tblteacher.t_password%type,
    p_course_seq tblCourse.course_seq%type,
    presult out number
)
is
    psubname_seq tblCSub.subname_seq%type;
    pcourse_neme tblCourseName.course_neme%type;
    pc_start_date tblCourse.c_start_date%type;
    pc_end_date tblCourse.c_end_date%type;
    psubname tblSubjectName.subname%type;
    pcsstart_date tblCSub.csstart_date%type;
    pcsend_date tblCSub.csend_date%type;
    proom_name tblRoom.room_name%type;
    pcount number;
    
    cursor vcursor is select 
    distinct s.subname_seq as "과목번호",
    n.course_neme as "과정명",
    c.c_start_date as "과정시작일",
    c.c_end_date as "과정종료일", 
    sj.subname as "과목명",
    s.csstart_date as "과목시작일",
    s.csend_date as "과목종료일",
    r.room_name "강의실명",
    (select count(*) from tblSugang where course_seq = p_course_seq) as "수강 인원"
from tblCourse c 
    inner join tblCourseName n 
        on c.cname_seq = n.cname_seq 
        inner join tblCSub s 
            on c.course_seq = s.course_seq 
                inner join tblSubjectName sj 
                    on s.subname_seq = sj.subname_seq 
                        inner join tblRoom r 
                            on c.room_seq = r.room_seq
                                inner join tblSubjectTxt st 
                                    on sj.subname_seq = st.subname_seq
                                        where c.course_seq = p_course_seq and c.teacher_seq = 
                                            (select teacher_seq from tblteacher where t_name = pt_name and t_password = pt_password)
                                                order by s.csstart_date asc;
begin
    open vcursor;
        dbms_output.put_line('=================================================================================================================================================================================');
        dbms_output.put_line('과목번호 | ' || '                            과정명                           | ' || '과정시작일  | ' || '과정종료일  | ' || '      과목명        | ' || '과목시작일  | ' || '과목종료일  | ' || '   강의실명   | ' || '수강인원');
        loop
            fetch vcursor into psubname_seq, pcourse_neme, pc_start_date, pc_end_date, psubname, pcsstart_date, pcsend_date, proom_name, pcount;
            exit when vcursor%notfound;
            dbms_output.put_line('   ' || rpad(psubname_seq, 5, ' ') || ' | ' || rpad(pcourse_neme, 60, ' ') || ' |  ' || rpad(pc_start_date, 10, ' ')
            || ' |  ' || rpad(pc_end_date, 10, ' ') || ' |  ' || rpad(psubname, 18, ' ') || ' |  ' || 
            rpad(pcsstart_date, 10, ' ') || ' |  ' || rpad(pcsend_date, 10, ' ') || ' |    ' || rpad(proom_name, 10, ' ') || ' |    ' || rpad(pcount, 3, ' '));
        end loop;
        dbms_output.put_line('=================================================================================================================================================================================');
    close vcursor;
    presult := 1;
exception
    when others then
        presult := 0;
end proct_csub;


-- 내 강의스케줄 강의 선택 조회하기
declare
    vresult number;
begin
    proct_csub('최경숙', 2532102, 25, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;



-- 과목 번호 선택(과정 수강 수강생) 프로시저
create or replace procedure proct_csa (
    p_subname_seq tblCSub.subname_seq%type,
    p_course_seq tblCourse.course_seq%type,
    presult out number
)
is
    p_name tblMember.m_name%type;
    p_tel tblMember.m_tel%type;
    p_registdate tblMember.m_registdate%type;
    p_progress tblSugang.progress%type;
    
    cursor vcursor is select 
    m.m_name "교육생 이름",
    m.m_tel "전화번호",
    m.m_registdate "등록일",
    su.progress "수강상태"
from tblCSub cs 
    inner join tblCourse c 
        on cs.course_seq = c.course_seq 
            inner join tblSugang su 
                on c.course_seq = su.course_seq 
                    inner join tblMember m 
                        on su.member_seq = m.member_seq
                            where cs.subname_seq = p_subname_seq and c.course_seq = p_course_seq;
begin
    open vcursor;
    dbms_output.put_line('=================================================================================================================================================================================');
    dbms_output.put_line('교육생 이름' || ' |    ' || '전화번호' || '   |    ' || '등록일' || '   |   ' || '수강상태');
        loop
            fetch vcursor into p_name, p_tel, p_registdate, p_progress;
            exit when vcursor%notfound;
            dbms_output.put_line('   ' || p_name || '  |  ' || p_tel || '  |  ' || p_registdate || '   |   ' || p_progress);
        end loop;
    close vcursor;
    presult := 1;
exception
    when others then
        presult := 0;
end proct_csa;


-- 과목 번호 선택(과정 수강 수강생) 조회하기
declare
    vresult number;
begin
    proct_csa(9, 25, vresult);
    if vresult = 1 then
        dbms_output.put_line('조회 종료');
    else
        dbms_output.put_line('예상치 못한 오류가 발생했습니다.');
    end if;
end;
