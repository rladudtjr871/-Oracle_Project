-- D_01 성적조회 기능

--1. 과목 성적 조회 

select 
    sn.subname as 과목명,
    sp.attend_point as 출결배점,
    sp.pilgi_point as 필기배점,
    sp.silgi_point as 실기배점,
    sc.attend_score as 출결점수,
    sc.pilgi_score as 필기점수,
    sc.silgi_score as 실기점수,
    sc.silgi_score + sc.pilgi_score + sc.attend_score as 총점
    
from tblSugang s
    inner join tblCourse c on s.course_seq = c.course_seq --과정
         join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
                left outer join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                        left outer join tblSubtPoint sp on cs.csub_seq = sp.csub_seq -- 강좌 배점 
                            left outer join tblScore sc on s.sugang_seq = sc.sugang_seq and cs.csub_seq = sc.csub_seq-- 시험 점수 -- 수정필요!!!
                            
where sc.sugang_seq = 180 and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = 180) order by cs.csub_seq;
                    





--2. 과목 교재 조회

select 
    sn.subname,
    txt.name as 교재명,
    txt.author as 작가,
    pb.name as 출판사
    
from tblSugang s
    inner join tblCourse c on s.course_seq = c.course_seq --과정
        inner join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
                inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                  inner join tblsubjecttxt stx on sn.subname_seq = stx.subname_seq --과목교재
                    inner join tblTextBook txt on stx.txtbook_seq = txt.txtbook_seq -- 교재
                        inner join tblPublisher pb on txt.publisher_seq = pb.publisher_seq -- 출판사
                            
where s.sugang_seq = 183 and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = 183) order by cs.csub_seq ;





--3. 과목 시험일자 조회 
select 
    sn.subname,
    td.test_date as 시험일
 
from tblSugang s
    inner join tblCourse c on s.course_seq = c.course_seq --과정
        inner join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
            left outer join tblTestDate td on cs.csub_seq = td.csub_seq -- 과목별 시험 
                inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                            
where s.sugang_seq = 185 and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = 185) order by td.test_date ;





















