-- B-10. 관리자 - 과목상담 조회

set serverout on;

--------------------------------------------------------------------------------
-- 1. 모든 교육생 상담내역 조회(최신 날짜 순 + 이름 순)
--------------------------------------------------------------------------------

create or replace view vwAllStuCon
as
select
    distinct
    
    m.m_name as "교육생이름",
    cn.course_neme as "과정명",
    c.c_start_date as "시작일",
    c.c_end_date as "종료일",
    sn.subname as "과목명",
    q.consult_txt as "상담내용",
    t.t_name as "교사명",
    a.answer_txt as "상담답변"
    
from tblConsult q
    inner join tblAnswer a
        on q.consult_seq = a.consult_seq
            inner join tblCsub cs
                on q.csub_seq = cs.csub_seq
                    inner join tblsubjectname sn
                        on cs.subname_seq = sn.subname_seq
                            inner join tblCourse c
                                on cs.course_seq = c.course_seq
                                    inner join tblcoursename cn
                                         on c.cname_seq = cn.cname_seq
                                            inner join tblTeacher t
                                                on a.teacher_seq = t.teacher_seq
                                                    inner join tblSugang s
                                                        on q.sugang_seq = s.sugang_seq
                                                            inner join tblMember m
                                                                on s.member_seq = m.member_seq
                                                                
    where q.csub_seq = cs.csub_seq order by c.c_start_date desc;

--------------------------------------------------------------------------------

select * from vwAllStuCon;

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 2. 현재 진행 중인 과정들의 질문 조회
--------------------------------------------------------------------------------

create or replace view vwIngStuCon
as
select
    distinct
        
        cn.course_neme as "개설과정명",
        c.c_start_date as "개설과정시작일",
        c.c_end_date as "개설과정종료일",
        sn.subname as "개설과목명",
        m.m_name as"교육생이름",
        q.consult_txt as "상담내용",
        a.answer_txt as "답변내용"
        
from tblConsult q
    inner join tblAnswer a
        on q.consult_seq = a.consult_seq
            inner join tblCsub cs
                on q.csub_seq = cs.csub_seq
                    inner join tblsubjectname sn
                        on cs.subname_seq = sn.subname_seq
                            inner join tblCourse c
                                on cs.course_seq = c.course_seq
                                    inner join tblcoursename cn
                                         on c.cname_seq = cn.cname_seq
                                            inner join tblTeacher t
                                                on a.teacher_seq = t.teacher_seq
                                                    inner join tblSugang s
                                                        on q.sugang_seq = s.sugang_seq
                                                            inner join tblMember m
                                                                on s.member_seq = m.member_seq
                                                                
    where sysdate between c.c_start_date and c.c_end_date and q.csub_seq = cs.csub_seq order by m.m_name;
    
--------------------------------------------------------------------------------

select * from vwIngStuCon;

--------------------------------------------------------------------------------
-- B-10. 관리자 - 과목상담 조회
        
--------------------------------------------------------------------------------
-- 2. 특정 과목 상담 내역 출력(날짜 상관 X) (완)
--------------------------------------------------------------------------------
create or replace procedure procSubAnswer(
    psubname        tblSubjectname.subname%type         -- 과목명
)
is
    mm_name         tblMember.m_name%type;              -- 교육생이름
    cncourse_neme    tblCourseName.course_neme%type;    -- 개설과정명
    snsubname       tblsubjectname.subname%type;        -- 개설과목명
    qconsult_txt    tblconsult.consult_txt%type;        -- 상담내용
    tt_name         tblTeacher.t_name%type;             -- 교사명
    aanswer_txt     tblanswer.answer_txt%type;          -- 상담답변
    
    cursor vcursor is
    
select
    distinct
    
    m.m_name,               -- "교육생이름"
    cn.course_neme,         -- "과정명"
    sn.subname,             -- "과목명"
    q.consult_txt,          -- "상담내용"
    t.t_name,               -- "교사명"
    a.answer_txt            -- "상담답변"
    
from tblConsult q
    inner join tblAnswer a
        on q.consult_seq = a.consult_seq
            inner join tblCsub cs
                on q.csub_seq = cs.csub_seq
                    inner join tblsubjectname sn
                        on cs.subname_seq = sn.subname_seq
                            inner join tblCourse c
                                on cs.course_seq = c.course_seq
                                    inner join tblcoursename cn
                                         on c.cname_seq = cn.cname_seq
                                            inner join tblTeacher t
                                                on a.teacher_seq = t.teacher_seq
                                                    inner join tblSugang s
                                                        on q.sugang_seq = s.sugang_seq
                                                            inner join tblMember m
                                                                on s.member_seq = m.member_seq
                                                                
    where upper(sn.subname) like '%' || upper(psubname) || '%' and q.csub_seq = cs.csub_seq
    order by cn.course_neme;
    
begin
    
    open vcursor;
    
        dbms_output.put_line('========================================================================');
        dbms_output.put_line('교육생이름'||'개설과정명'||'개설과목명'||'상담내용'||'교사명'||'상담답변');
        dbms_output.put_line('========================================================================');
        
        loop
            fetch vcursor into mm_name, cncourse_neme, snsubname, qconsult_txt, tt_name, aanswer_txt;
            exit when vcursor%notfound;
            
            dbms_output.put_line(mm_name || cncourse_neme || snsubname || qconsult_txt || tt_name || aanswer_txt);
        
        end loop;
        
    close vcursor;
    
exception
    when others then
    
        dbms_output.put_line('잘못된 값을 입력했습니다.');
        
end procSubAnswer;
/

--------------------------------------------------------------------------------

begin
    procSubAnswer('java');
end;
/

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 3. 특정 교사의 특정 과목 상담내역(날짜 상관 X) (완)
--------------------------------------------------------------------------------

create or replace procedure procBTeaStu (
    pt_name         tblteacher.t_name%type,             -- 교사명
    psubname        tblSubjectname.subname%type         -- 과목명
    
)
is
    tt_name         tblteacher.t_name%type;             -- 교사명
    cncourse_neme   tblCourseName.course_neme%type;     -- 개설과정명
    cc_start_date   tblCourse.c_start_date%type;        -- 개설과정시작일
    cc_end_date     tblCourse.c_end_date%type;          -- 개설과정종료일
    snsubname       tblsubjectname.subname%type;        -- 개설과목명
    mm_name         tblMember.m_name%type;              -- 교육생이름
    qconsult_txt    tblconsult.consult_txt%type;        -- 상담내용
    aanswer_txt     tblanswer.answer_txt%type;          -- 상담답변
    
    cursor vcursor is
    
select
    distinct
        
        t.t_name,           -- "교사명"
        cn.course_neme,     -- "개설과정명"
        c.c_start_date,     -- "개설과정시작일"
        c.c_end_date,       -- "개설과정종료일"
        sn.subname,         -- "개설과목명"
        m.m_name,           -- "교육생이름"
        q.consult_txt,      -- "상담내용"
        a.answer_txt        -- "상담답변"
        
from tblConsult q
    inner join tblAnswer a
        on q.consult_seq = a.consult_seq
            inner join tblCsub cs
                on q.csub_seq = cs.csub_seq
                    inner join tblsubjectname sn
                        on cs.subname_seq = sn.subname_seq
                            inner join tblCourse c
                                on cs.course_seq = c.course_seq
                                    inner join tblcoursename cn
                                         on c.cname_seq = cn.cname_seq
                                            inner join tblTeacher t
                                                on a.teacher_seq = t.teacher_seq
                                                    inner join tblSugang s
                                                        on q.sugang_seq = s.sugang_seq
                                                            inner join tblMember m
                                                                on s.member_seq = m.member_seq
                                                                
    where upper(sn.subname) like '%' || upper(psubname) || '%' and t.t_name = pt_name and q.csub_seq = cs.csub_seq order by c.c_start_date desc;
                                                                
begin

    open vcursor;
        
        dbms_output.put_line('========================================================================');
        dbms_output.put_line('교사명'||'개설과정명'||'개설과정시작일'||'개설과정종료일'||'개설과목명'||'교육생이름'||'상담내용'||'상담답변');
        dbms_output.put_line('========================================================================');
        
        loop
            fetch vcursor into tt_name, cncourse_neme, cc_start_date, cc_end_date, snsubname, mm_name, qconsult_txt, aanswer_txt;
            exit when vcursor%notfound;
            
            dbms_output.put_line(tt_name || cncourse_neme || cc_start_date || cc_end_date || snsubname || mm_name || qconsult_txt || aanswer_txt);
            
        end loop;
        
    close vcursor;

exception
    when others then
    
        dbms_output.put_line('잘못된 값을 입력했습니다.');
    
end procBTeaStu;
/

--------------------------------------------------------------------------------

begin
    procBTeaStu('최경하', 'java');
end;
/

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 4. 답변 수정(완)
--------------------------------------------------------------------------------
create or replace procedure procBAnswerUpdate (
    panswer_seq tblAnswer.answer_seq%type,          -- 답변번호
    panswer_txt tblAnswer.answer_txt%type,          -- 상담내용
    presult out number
)
is
--    vcnt tblanswer.answer_txt%type;
begin

--    select answer_txt into vcnt from tblAnswer where answer_seq = panswer_seq;
--    if vcnt like '%매니저%' then
--        update tblAnswer set answer_txt = panswer_txt where answer_seq = panswer_seq;
--    else
--        null;
--    end if;

    if panswer_txt like '%매니저%' then
    
        update tblAnswer set answer_txt = panswer_txt where answer_seq = panswer_seq;
        
    end if;
    
        presult := 1;
        
exception
    when others then
    
        presult := 0;
        
end procBAnswerUpdate;
/

--------------------------------------------------------------------------------

declare
    vresult number;
begin
    procBAnswerUpdate(2, '매니저 입니다. admin1234로 카톡주세요.', vresult);

    if vresult = 1 then
        dbms_output.put_line('답변 수정을 완료하였습니다.');
    else
        dbms_output.put_line('답변 수정에 실패하셨습니다.');
    end if;
end;
/

--------------------------------------------------------------------------------

select * from tblAnswer where answer_seq =2;

rollback;

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 5. 답변 삭제(완)
--------------------------------------------------------------------------------

create or replace procedure procBAnswerDelete (
    pnum number,
    presult out number
)
is
begin

    delete tblAnswer where answer_seq = pnum;
    
        presult := 1;
    
exception
    when others then
    
        presult := 0;
        
end procBAnswerDelete;
/

--------------------------------------------------------------------------------

declare
    vresult number;
begin
    procBAnswerDelete(2, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('답변삭제를 완료했습니다.');
    else
        dbms_output.put_line('답변삭제에 실패했습니다.');
    end if;
end;
/

--------------------------------------------------------------------------------

select * from tblAnswer where answer_seq = 2;
select * from tblConsult where consult_seq = 2;

rollback;

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 6. 상담내용을 통해 내용 & 답변 삭제(기간을 주고 싶음 - 완(?))
--------------------------------------------------------------------------------

create or replace procedure procBQandArDelete (
    pconsult    tblconsult.consult_seq%type,
    presult     out number
)
is
begin

    delete tblAnswer where consult_seq = pconsult;
    delete tblConsult where consult_seq = pconsult;
        
        presult := 1;
        
exception
    when others then
    
        presult := 0;
        
end procBQandArDelete;
/

--------------------------------------------------------------------------------