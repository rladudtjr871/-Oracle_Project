-- 내 개설과정 강의 스케줄 조회
select 
    c.course_seq as "강의번호",
    n.course_neme as "강의 과정명", 
    case when sysdate < c.c_start_date then '강의예정'
    when sysdate between c.c_start_date and c.c_end_date then '강의중'
    when sysdate > c.c_end_date then '강의종료' end as "강의상태"
from tblCourse c inner join tblcoursename n on c.cname_seq = n.cname_seq where c.teacher_seq = 
    (select teacher_seq from tblteacher where t_name = '최경하' and t_password = 2532102) order by c.c_end_date desc; 
    




-- 내 스케줄 내 개설과정번호 선택
select 
    distinct s.subname_seq as "과목번호",
    n.course_neme as "과정명",
    c.c_start_date as "과정시작일",
    c.c_end_date as "과정종료일", 
    sj.subname as "과목명",
    s.csstart_date as "과목시작일",
    s.csend_date as "과목종료일",
    r.room_name "강의실명",
    (select count(*) from tblSugang where course_seq = 25) as "수강 인원"
from tblCourse c 
    inner join tblCourseName n on c.cname_seq = n.cname_seq 
        inner join tblCSub s on c.course_seq = s.course_seq 
            inner join tblSubjectName sj on s.subname_seq = sj.subname_seq 
                inner join tblRoom r on c.room_seq = r.room_seq
                    inner join tblSubjectTxt st on sj.subname_seq = st.subname_seq
        where c.course_seq = 25;
        
        


-- 과목에 따른 교재 출력 > 내 스케줄 강의선택 시 출력되어야함 but 중복이 너무 많아서 따로처리
select 
    distinct sn.subname_seq as "과목번호",
    sn.subname as "과목명",
    tb.name as "교재명"
from tblSubjectName sn
    inner join tblSubjectTxt st on st.subname_seq = sn.subname_seq
        inner join tblTextBook tb on st.txtbook_seq = tb.txtbook_seq
            order by sn.subname_seq;

        
        

-- 내 스케줄 내 개설과정선택 과목 선택
select 
    m.m_name "교육생 이름",
    m.m_tel "전화번호",
    m.m_registdate "등록일",
    su.progress "수강상태"
from tblCSub cs 
    inner join tblCourse c on cs.course_seq = c.course_seq 
        inner join tblSugang su on c.course_seq = su.course_seq 
            inner join tblMember m on su.member_seq = m.member_seq
    where cs.subname_seq = 9 and c.course_seq = 1;