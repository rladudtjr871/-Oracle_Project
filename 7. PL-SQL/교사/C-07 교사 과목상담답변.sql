-- C-07 교사 과목상담답변 수정본
set serverout on;

--------------------------------------------------------------------------------
-- 1. 강의중인 개설과정 중 질문이 존재하는 교육생 이름 조회
--------------------------------------------------------------------------------

create or replace procedure procTeaStu (
    pteacher_seq tblteacher.teacher_seq%type            -- 교사번호
)
is
    mm_name         tblMember.m_name%type;              -- 교육생이름
    cnourse_neme    tblCourseName.course_neme%type;     -- 개설과정명
    cc_start_date   tblCourse.c_start_date%type;        -- 개설과정시작일
    cc_end_date     tblCourse.c_end_date%type;          -- 개설과정종료일
    
    cursor vcursor is
    
select
    distinct
    
        m.m_name,           -- "교육생이름"
        cn.course_neme,     -- "개설과정명"
        c.c_start_date,     -- "개설과정시작일"
        c.c_end_date        -- "개설과정종료일"
        
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
                                                                
    where sysdate between c.c_start_date and c.c_end_date and t.teacher_seq = pteacher_seq order by m.m_name;
-- 날짜 한개만 조회 + 그 교사만 조회를 하면 된다.(시간 신경 : 부등호 > between 조금 더 느림)
                                                                
begin

    open vcursor;
        
        dbms_output.put_line('============================================================================');
        dbms_output.put_line('교육생이름'||'개설 과정명'||'개설과정시작일'||'개설과정종료일');
        dbms_output.put_line('============================================================================');
        
        loop
            fetch vcursor into mm_name, cnourse_neme, cc_start_date, cc_end_date;
            exit when vcursor%notfound;
            
            dbms_output.put_line(mm_name || cnourse_neme || cc_start_date || cc_end_date);
            
        end loop;
        
    close vcursor;

exception
    when others then
    
        dbms_output.put_line('잘못된 값을 입력했습니다.');
    
end procTeaStu;
/

--------------------------------------------------------------------------------

begin
    procTeaStu(10);
end;
/

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 2. 교육생 이름으로 질문내역 조회
--------------------------------------------------------------------------------

create or replace procedure procQStudentPrint (
    pteacher_seq    tblteacher.teacher_seq%type,            -- 교사 번호
    pm_name         tblmember.m_name%type                   -- 교육생 이름
)
is
    
    mm_name         tblMember.m_name%type;                  -- 교육생이름
    snsubname       tblsubjectname.subname%type;            -- 개설과목명
    qconsult_txt    tblconsult.consult_txt%type;            -- 상담내용
    aanswer_txt     tblanswer.answer_txt%type;              -- 상담답변
    
    cursor vcursor is
    
select
    distinct
        
        m.m_name,               -- "교육생이름"
        sn.subname,             -- "개설과목명"
        q.consult_txt,          -- "상담내용"
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
    
    where sysdate between c.c_start_date and c.c_end_date and a.teacher_seq = pteacher_seq and m.m_name = pm_name;
    
begin

    open vcursor;
        
        dbms_output.put_line('==========================================================================');
        dbms_output.put_line('교육생이름'||'개설 과목명'||'상담내용'||'답변내용');
        dbms_output.put_line('==========================================================================');
        
        loop
            fetch vcursor into mm_name, snsubname, qconsult_txt, aanswer_txt;
            exit when vcursor%notfound;
            
            dbms_output.put_line(mm_name || snsubname || qconsult_txt || aanswer_txt);
            
        end loop;
        
    close vcursor;

exception
    when others then
    
        dbms_output.put_line('잘못된 값을 입력했습니다.');
    
end procQStudentPrint;
/

--------------------------------------------------------------------------------

begin
    procQStudentPrint(10,'노희호');
end;
/

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 3. 답변입력
--------------------------------------------------------------------------------

create or replace procedure procWriteAnswer(
    pteacher_seq    tblteacher.teacher_seq%type,   -- 교사번호    
    pconsult_seq    tblAnswer.consult_seq%type,   -- 질문번호
    panswer_txt     tblAnswer.answer_txt%type     -- 상담내용
)
is
begin

    insert into tblAnswer (answer_seq, answer_txt, teacher_seq, consult_seq)
    
    values((select max(answer_seq) + 1 from tblAnswer), panswer_txt, pteacher_seq, pconsult_seq);
-- 순서 바꾸기 하지 말기
    dbms_output.put_line('답변이 등록 되었습니다.');
    
exception
    when others then
    
    dbms_output.put_line('답변 등록에 실패했습니다.');
    
end procWriteAnswer; 
/

--------------------------------------------------------------------------------

begin
    procWriteAnswer(10, 101, '어떤 질문인가요? 6시 이후에 상담소회의실에서 만납시다.');
end;
/

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 4. 답변 수정하기(굳이 수강번호 와 상담내용 번호 안넣어도 되는지)
--------------------------------------------------------------------------------

create or replace procedure procAnswerUpdate (
    pconsult_seq    tblAnswer.consult_seq%type,    -- 질문번호
    panswer_txt     tblAnswer.answer_txt%type,     -- 상담내용
    presult out number
)
is
begin

    update tblAnswer set answer_txt = panswer_txt where consult_seq = pconsult_seq;
    
        presult := 1;
        
exception
    when others then
    
        presult := 0;
        
end procAnswerUpdate;
/

--------------------------------------------------------------------------------

declare
    vresult number;
begin
    procAnswerUpdate(101, '지금 바로 소회의실 3번으로 들어오세요.', vresult);
    
    if vresult = 1 then
        dbms_output.put_line('답변이 수정되었습니다.');
    else
        dbms_output.put_line('답변 수정에 실패하셨습니다.');
    end if;
end;
/

--------------------------------------------------------------------------------

select * from tblAnswer where answer_seq = 100;

rollback;

--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 5. 답변 삭제하기
--------------------------------------------------------------------------------

create or replace procedure procAnswerDel (
    panswer_seq tblAnswer.answer_seq%type,
    presult out number
)
is
begin

    delete tblAnswer where answer_seq = panswer_seq;
    
        presult := 1;
    
exception
    when others then
    
        presult := 0;
        
end procAnswerDel;
/

--------------------------------------------------------------------------------

declare
    vresult number;
begin
    procAnswerDel(101, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('답변 삭제를 완료하였습니다.');
    else
        dbms_output.put_line('답변 삭제를 실패하였습니다.');
    end if;
end;
/

--------------------------------------------------------------------------------

select * from tblAnswer where answer_seq = 101;

rollback;

--------------------------------------------------------------------------------
