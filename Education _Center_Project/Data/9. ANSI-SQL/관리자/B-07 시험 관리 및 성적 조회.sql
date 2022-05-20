-- B-07. 관리자 시험 관리 및 성적 관리


--특정 개설 과정 선택(과정번호)
--특정 개설 과정에 등록된 개설 과목정보(기간, 과목명)  & ( 성적등록여부/ 시험문제파일등록여부) 확인

select
    distinct
    sn.subname as "과목명",
    cs.csstart_date as "과목 시작일",
    cs.csend_date as "과목 종료일",
    case
        when tn.test_type in ('필기', '실기') then 'Y'
        else 'N'
    end as "시험 등록 여부",
    case
        when attend_score is null or pilgi_score is null or silgi_score is null then 'N'
        else 'Y'
    end as "성적 등록 여부"
--    *
from tblCourse c
    inner join tblCourseName cn
        on c.cname_seq = cn.cname_seq
            inner join tblCSub cs
                on c.course_seq = cs.course_seq
                    inner join tblSubjectName sn
                        on cs.subname_seq = sn.subname_seq
                          left outer join tblScore sc
                                on cs.csub_seq = sc.csub_seq
                                    left outer join tblTestDate td
                                        on cs.csub_seq = td.csub_seq
                                            left outer join tblTest t
                                                on td.testnum_seq = t.testnum_seq
                                                    left outer join tblTestName tn
                                                        on t.testname_seq = tn.testname_seq --and tn.subname_seq = cs.subname_seq
                                                    where c.course_seq = 1; --1번 혹은 25번




select * from tblCourse;      -- 개설과정
select * from tblCourseName;  -- 과정명
select * from tblCSub;        --과정 내 과목
select * from tblsubjectname; --과목명
select * from tblScore;       --성적
select * from tblSugang;
select * from tblTestDate;
select * from tblTest;
select * from tblTestName;

desc tblScore;

select * from tblScore;       --성적








desc tblCourseName;

-- 성적 정보 출력시 개설 과목별 출력

select
    cn.course_neme,
    sn.subname as "과목명"
from tblCourse c
    inner join tblCourseName cn
        on c.cname_seq = cn.cname_seq
            inner join tblCSub cs
                on c.course_seq = cs.course_seq
                    inner join tblSubjectName sn
                        on cs.subname_seq = sn.subname_seq
                          left outer join tblScore sc
                                on cs.csub_seq = sc.csub_seq
                                    inner join tblRoom r
                                        on c.room_seq = r.room_seq;

-- 과정명 과정기간 강의실명 과목명 교사명
select
    distinct
    cn.course_neme,
    c.c_start_date,
    c.c_end_date,
    r.room_name,
    sn.subname,
    t.t_name
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on s.course_seq = c.course_seq
                    inner join tblCourseName cn
                        on c.cname_seq = cn.cname_seq
                            inner join tblCSub cs
                                on c.course_seq = cs.course_seq
                                    inner join tblSubjectName sn
                                        on cs.subname_seq = sn.subname_seq
                                            inner join tblRoom r
                                                on c.room_seq = r.room_seq
                                                    inner join tblTeacher t
                                                        on c.teacher_seq = t.teacher_seq
        where c.course_seq = 1;


--교재명
select
    sn.subname,
    tb.name
from tblSubjectName sn
    inner join tblCSub cs
        on sn.subname_seq = cs.subname_seq
            inner join tblCourse c
                on c.course_seq = cs.course_seq
                    inner join tblSubjectTxt st
                        on sn.subname_seq = st.subname_seq
                            inner join tblTextBook tb
                                on tb.txtbook_seq = st.txtbook_seq
                    where c.course_seq = 1;



--그 과정의 과목을 수강한 모든 교육생들의 성적 정보
select
    distinct
    s.sugang_seq,
    m.m_name,
    sn.subname,
    cs.csstart_date,
    cs.csend_date,
    --t.t_name,
    sc.attend_score,
    sc.pilgi_score,
    sc.silgi_score
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on s.course_seq = c.course_seq
                    inner join tblCourseName cn
                        on c.cname_seq = cn.cname_seq
                            inner join tblCSub cs
                                on c.course_seq = cs.course_seq
                                    inner join tblSubjectName sn
                                        on cs.subname_seq = sn.subname_seq
                                            inner join tblRoom r
                                                on c.room_seq = r.room_seq
                                                    inner join tblTeacher t
                                                        on c.teacher_seq = t.teacher_seq
                                                            inner join tblScore sc
                                                                on sc.csub_seq = cs.csub_seq and s.sugang_seq = sc.sugang_seq
        where c.course_seq = 1
            order by s.sugang_seq;





-- 회원 개인별 출력
-- 회원정보 / 와 해당 회원이 수강한 모든 과목에 대한 정보(과목명, 과목기간, 교사명, 출결, 필기, 실기) 출력

select 
    distinct
    m.m_name as "회원이름",
    m.m_password as "주민번호 뒷자리",
    cn.course_neme as "개설과정명",
    c.c_start_date as "과정시작",
    c.c_end_date "과정종료",
    r.room_name as "강의실",
    sn.subname as "개설과목명",
    cs.csstart_date as "개설 과목 시작",
    cs.csend_date as "개설 과목 종료",
    sc.attend_score as "출석 점수",
    sc.pilgi_score as "필기 점수",
    sc.silgi_score as "실기 점수"
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on s.course_seq = c.course_seq
                    inner join tblCourseName cn
                        on c.cname_seq = cn.cname_seq
                            inner join tblCSub cs
                                on c.course_seq = cs.course_seq
                                    inner join tblSubjectName sn
                                        on cs.subname_seq = sn.subname_seq
                                            inner join tblRoom r
                                                on c.room_seq = r.room_seq
                                                    inner join tblTeacher t
                                                        on c.teacher_seq = t.teacher_seq
                                                            inner join tblSubjectTxt st
                                                                on sn.subname_seq = st.subname_seq
                                                                    inner join tblScore sc
                                                                        on s.sugang_seq = sc.sugang_seq and cs.csub_seq = sc.csub_seq
                                  where s.sugang_seq = 1;
                                                                        



--======================================================================================================================================================================================================















-- 회원 개인별 성적 정보 출력

-- 1. 회원번호로 검색할 경우 수강 번호를 알아내는 쿼리 (수강번호로 검색할거면 안해도 된다.)
select s.sugang_seq from tblMember m inner join tblSugang s on m.member_seq = s.member_seq where m.member_seq = 1;

-- 2. 수강번호로 해당 회원의 정보와 수강 과정을 출력 (교육생 개인별 출력시 교육생 이름, 주민번호 뒷잘, 개설 과정명 /)
select
    m.member_seq,
    m.m_name,
    m.m_password,
    cn.course_neme
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on c.course_seq = s.course_seq
                    inner join tblCourseName cn
                        on cn.cname_seq = c.cname_seq
    where s.sugang_seq = 1;



-- 3. 위 회원이 듣는 개설 과정 정보
select
    cn.course_neme,
    c.c_start_date,
    c.c_end_date,
    t.t_name,
    r.room_name
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on c.course_seq = s.course_seq
                    inner join tblCourseName cn
                        on cn.cname_seq = c.cname_seq
                            inner join tblRoom r
                                on r.room_seq = c.room_seq
                                    inner join tblTeacher t
                                        on c.teacher_seq = t.teacher_seq
    where s.sugang_seq = 1;



-- 4. 해당 회원이 듣는 과정의 과목에 대한 성적 정보
select
    distinct
    sn.subname as "개설과목명",
    cs.csstart_date as "개설 과목 시작",
    cs.csend_date as "개설 과목 종료",
    sc.attend_score as "출석 점수",
    sc.pilgi_score as "필기 점수",
    sc.silgi_score as "실기 점수"
from tblMember m
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on c.course_seq = s.course_seq
                    inner join tblCSub cs
                        on c.course_seq = cs.course_seq
                            inner join tblScore sc
                                on cs.csub_seq = sc.csub_seq and sc.sugang_seq = s.sugang_seq
                                    inner join tblSubjectName sn
                                        on cs.subname_seq = sn.subname_seq
                                            where s.sugang_seq = 1
                                                order by sn.subname;







select
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
                                            where su.sugang_seq = 1
                                                order by su.sugang_seq; 








