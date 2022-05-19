-- D-07~8 교육생 - 수료 교육생 취업 활동 조회, 협력기업조회

-- 교육생 로그인 전제

-- 전체 학생 취업활동 조회
select
    m.m_name as 수료생명,
    s.complete_date as 수료일,
    cn.course_neme as 개설과정명,
    j.jobact_date as 취업활동내역
from tblsugang s
    inner join tblmember m
        on s.member_seq = m.member_seq
            inner join tblcourse c
                on s.course_seq = c.course_seq
                    inner join tblcoursename cn
                        on c.cname_seq = cn.cname_seq
                            inner join tbljobact j
                                on s.sugang_seq = j.sugang_seq;
         
-- 본인 학생 취업활동 조회
select
    m.m_name as 수료생명,
    s.complete_date as 수료일,
    cn.course_neme as 개설과정명,
    j.jobact_date as 취업활동내역
from tblsugang s
    inner join tblmember m
        on s.member_seq = m.member_seq
            inner join tblcourse c
                on s.course_seq = c.course_seq
                    inner join tblcoursename cn
                        on c.cname_seq = cn.cname_seq
                            inner join tbljobact j
                                on s.sugang_seq = j.sugang_seq
                                    where s.sugang_seq = 1;
                               
-- 취업활동내역 입력/수정
update tbljobact set jobact_date = '자기소개서' where sugang_seq = 1;


-- D-08 교육생 - 협력 기업 조회

select 
    ent_name as 기업명, 
    ent_people as 구인인원,
    ent_type as 구인형태,
    ent_sector as 업종,
    ent_recuit as 모집부분
from tblenterprise;

