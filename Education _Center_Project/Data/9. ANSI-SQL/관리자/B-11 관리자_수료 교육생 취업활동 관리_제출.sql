-- B-11 관리자 - 수료 교육생 취업활동 관리

-- 수료 교육생 취업활동 관리 등록

-- insert해야하는 수료 교육생 목록 출력(개설과정번호로 출력)
select sugang_seq, complete_date, c.course_seq from tblsugang s
                                    inner join tblcourse c
                                        on s.course_seq = c.course_seq
                                    where sugang_seq in (select sugang_seq from tblsugang where progress = '수강종료') and c.course_seq = 25;
                                    
-- select 목록을 insert에 차례대로 등록해야함
-- insert into tblemploye (employe_seq, ent_viewdate, sugang_seq) values (1, add_months('complete_date', 6),sugang_seq);
-- tblJobAct는 둘중 선택
-- insert into tblJobAct (jobact_seq, sugang_seq) values(1, 1);
-- insert into tblJobAct (jobact_seq, jobact_date, sugang_seq) values(1, '취업활동내역', 1);
insert into tblemploye (employe_seq, ent_viewdate, sugang_seq) values (1, add_months('20/09/01', 6),1);
insert into tblJobAct (jobact_seq, sugang_seq) values(1, 1);
insert into tblJobAct (jobact_seq, jobact_date, sugang_seq) values(1, '이력서', 1);

-- 수료 교육생 취업활동 관리 전체 조회
select 
    m.m_name as 수료생이름,
    s.complete_date as 수료일,
    cn.course_neme as 개설과정명,
    e.lnsurance_have as 고용보험등록,
    e.ent_viewdate as 협력기업조회가능일,
    j.jobact_date as 취업활동내역
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblEmploye e
                on s.sugang_seq = e.sugang_seq
                    inner join tblJobAct j
                        on s.sugang_seq = j.sugang_seq
                            inner join tblCourse c
                                on s.course_seq = c.course_seq
                                    inner join tblCourseName cn
                                        on c.cname_seq = cn.cname_seq;
                                        
-- 수료 교육생 취업활동 관리 특정 학생 조회
select 
    m.m_name as 수료생이름,
    s.complete_date as 수료일,
    cn.course_neme as 개설과정명,
    e.lnsurance_have as 고용보험등록,
    e.ent_viewdate as 협력기업조회가능일,
    j.jobact_date as 취업활동내역
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblEmploye e
                on s.sugang_seq = e.sugang_seq
                    inner join tblJobAct j
                        on s.sugang_seq = j.sugang_seq
                            inner join tblCourse c
                                on s.course_seq = c.course_seq
                                    inner join tblCourseName cn
                                        on c.cname_seq = cn.cname_seq
        where s.sugang_seq = 3;


-- 수료 교육생 취업관리 수정(고용보험)
update tblEmploye set lnsurance_have = 'Y' where sugang_seq = 1;
update tblEmploye set lnsurance_have = 'N' where sugang_seq = 2;                                   


-- 수료 교육생 취업관리 수정(취업활동내역)
update tblJobAct set jobact_date = '자기소개서' where sugang_seq = 3;


-- 수료 교육생 취업관리 삭제
--날짜 삭제(수료부터 6개월이 지난 학생 삭제)
-- select sugang_seq from tblemploye where ent_viewdate < sysdate; -- 삭제할 수료생 찾기
-- delete tbljobact where sugang_seq in (select sugang_seq from tblemploye where ent_viewdate < sysdate);
delete tblemploye where ent_viewdate < sysdate;

-- 지정 삭제(특정 학생을 선택하여 삭제)
-- delete tbljobact where sugang_seq = 1;
delete tblemploye where sugang_seq = 1;

