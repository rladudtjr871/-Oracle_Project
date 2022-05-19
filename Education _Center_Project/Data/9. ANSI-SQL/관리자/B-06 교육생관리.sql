-- B-06. 관리자 교육생 관리

-- 회원 입력
insert into tblMember (member_seq, m_name, m_password, m_tel, m_registdate, m_major)
    values ((select max(member_seq) + 1 from tblMember), '홍당무', '1568752', '010-8295-0601', sysdate, '비전공');



--회원 정보 수정

--회원이름 수정
update tblMember set m_name = pm_name where member_seq = 회원번호;

--회원 주민등록번호 뒷자리 수정
update tblMember set m_password = pm_password where member_seq = 회원번호;

--회원 전화번호 수정
update tblMember set m_tel = pm_tel where member_seq = 회원번호;

--회원 등록일 수정
update tblMember set m_registdate = pm_registdate where member_seq = 회원번호;

--회원 전공여부 수정
update tblMember set m_major = pm_major where member_seq = 회원번호;




--회원 정보 삭제
delete from tblMember where member_seq = 회원번호;




--회원 정보 출력
select
    distinct
    m.m_name,
    m.m_password,
    m.m_tel,
    m.m_registdate,
    (select count(*) from tblSugang where member_seq = s.member_seq and (s.progress <> '수강예정' or s.progress <> '중도탈락')) as "수강횟수"
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq;

 
 
-- select 
--    distinct
--    m.m_name,
--    (select count(*) from tblsugang where member_seq = s.member_seq and (s.progress <> '수강예정' and s.progress <> '중도탈락')) as 수강횟수
--from tblmember m
--    inner join tblsugang s
--        on m.member_seq = s.member_seq;
 
 
------------------------------------------------------------------------------------------------------------------------------------------------------
-- 특정 교육생 선택??

-- 수강 예정
select
    cn.course_neme as "과정명",
    c.c_start_date as "과정 시작",
    c.c_end_date as "과정 종료",
    r.room_name as "강의실",
    s.progress as "수료 및 중도탈락 여부"
from tblCourse c
    inner join tblCourseName cn
        on c.cname_seq = cn.cname_seq
            inner join tblRoom r
                on c.room_seq = r.room_seq
                    inner join tblSugang s
                        on c.course_seq = s.course_seq
                            inner join tblMember m
                                on s.member_seq = m.member_seq
    where c.course_seq = (select
                              s.course_seq
                          from tblMember m
                              inner join tblSugang s
                                  on m.member_seq = s.member_seq
                                      where m.member_seq = 학생번호 and s.progress = '수강예정')
          and s.member_seq = 학생번호;



select * from tblsugang;
select * from tblCourse;


--select * from tblmember m inner join tblsugang s on m.member_seq = s.member_seq;
--select * from tblSugang;
--select * from tblstustop;

-- 수강 중 ??
--이게 수강예정/수강중/수강종료/중도탈락인지에 따라 다른 쿼리를 실행(select progress from tblSugang where member_seq = 학생번호);

select
    cn.course_neme as "과정명",
    c.c_start_date as "과정 시작",
    c.c_end_date as "과정 종료",
    r.room_name as "강의실",
    case
        when s.progress = '중도탈락' then 'Y'
        when s.progress <> '중도탈락' then 'N'
    end as "중도탈락 여부",
    case
        when stop_date is not null then 'Y'
        when stop_date is null then 'N'
    end as "중도탈락날짜"
from tblCourse c
    inner join tblCourseName cn
        on c.cname_seq = cn.cname_seq
            inner join tblRoom r
                on c.room_seq = r.room_seq
                    inner join tblSugang s
                        on c.course_seq = s.course_seq
                            inner join tblMember m
                                on s.member_seq = m.member_seq
                                    left outer join tblStuStop st
                                        on s.sugang_seq = st.sugang_seq
    where c.course_seq = (select
                              s.course_seq
                          from tblMember m
                              inner join tblSugang s
                                  on m.member_seq = s.member_seq
                                      where m.member_seq = 280 and (s.progress = '수강중' or s.progress = '중도탈락'))
          and s.member_seq = 280;


-- 수강 했던 ??
-- 중도탈락이 수강테이블에 있어서 수강중 수강종료가 구분이 안된다.
select
    cn.course_neme as "과정명",
    c.c_start_date as "과정 시작",
    c.c_end_date as "과정 종료",
    r.room_name as "강의실",
    case
        when s.progress = '중도탈락' then 'Y'
        when s.progress <> '중도탈락' then 'N'
    end as "중도탈락 여부",
    stop_date as "중도탈락 날짜"
from tblCourse c
    inner join tblCourseName cn
        on c.cname_seq = cn.cname_seq
            inner join tblRoom r
                on c.room_seq = r.room_seq
                    inner join tblSugang s
                        on c.course_seq = s.course_seq
                            inner join tblMember m
                                on s.member_seq = m.member_seq
                                  left outer join tblStuStop st
                                        on s.sugang_seq = st.sugang_seq
    where c.course_seq = (select
                              s.course_seq
                          from tblMember m
                              inner join tblSugang s
                                  on m.member_seq = s.member_seq
                                      where m.member_seq = 학생번호 and (s.progress = '수강종료' or s.progress = '중도탈락'))
          and s.member_seq = 학생번호;


-- 수료 (필요없어짐)
-- 출석일 고려
-- 조기취업 x
-- update tblSugang set complete_date = pcomplete_date, progress = pcomplete_date where course_seq = 과정번호; 


select * from tblAttendance;
select * from tblSugang;
select * from tblCourse;


-- 중도탈락 (결석 5회 > 결석 = 3점 지각 = 1점  >  총 15점이상이면 중도탈락)
-- 수강테이블에 중도탈락 처리

-- 1. 해당 학생의 (지각 + 결석) 점수가 15점인경우
select 
    sum(case
        when attendance_type = '결석' then 3
        when attendance_type = '지각' then 1
    end)
from tblAttendance a
    inner join tblSugang s
        on a.sugang_seq = s.sugang_seq
            inner join tblMember m
                on s.member_seq = m.member_seq
    where m.member_seq = 학생번호; --member_seq를 변수로 받기 (ex)200)


-- 2.
update tblSugang set progress = '중도탈락' where sugang_seq = 학생번호; --sugang_seq를 변수로 받기

-- 3. 중도탈락테이블에 추가
    --중도탈락인지 검증도
    --수강테이블에서 중도탈락일 경우 1을 반환
select
    case
        when progress = '중도탈락' then 1
    end "중도탈락이면 1"
from tblSugang;


--4.
insert into tblStustop(stustop_seq, stop_date, sugang_seq) values ((select (max(stustop_seq) + 1) from tblStustop), 중도탈락날짜, (select sugang_seq from tblSugang where member_seq = 학생번호));



--select * from tblmember;
--select * from tblSugang;
--select * from tblstustop;
--select * from tblAttendance;
--delete tblattendance where sugang_seq = 200;

commit;
rollback;




