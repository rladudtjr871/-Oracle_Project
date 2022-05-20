--D_06_교사추천도서 전체조회 
-- 교사이름으로 조회 시 해당 교사가 추천한 도서의 이름을 자동으로 보여준다 


-- 교사이름으로 추천도서 조회하기 
select distinct
    
    tr.rec_name as 책제목,
    p.name as 출판사,
    t.t_name as 교사명,
    sn.subname as 과목명,
    cn.course_neme as 과정명
    
    
from tblTeachRec tr
    inner join tblTeacher t on tr.teacher_seq = t.teacher_seq 
        inner join tblPublisher p on tr.publisher_seq = p.publisher_seq
            inner join tblCourse c on t.teacher_seq = c.teacher_seq
                inner join tblCourseName cn on c.cname_seq = cn.cname_seq
                    inner join tblSubjectName sn on tr.subname_seq = sn.subname_seq

where t.t_name = '송유주' order by 과정명, 과목명; --교사이름 입력






-- 2 과목별로 추천도서 조회하기

select distinct
    
    tr.rec_name as 책제목,
    p.name as 출판사,
    t.t_name as 교사명,
    sn.subname as 과목명,
    cn.course_neme as 과정명
    
    
from tblTeachRec tr
    inner join tblTeacher t on tr.teacher_seq = t.teacher_seq 
        inner join tblPublisher p on tr.publisher_seq = p.publisher_seq
            inner join tblCourse c on t.teacher_seq = c.teacher_seq
                inner join tblCourseName cn on c.cname_seq = cn.cname_seq
                    inner join tblSubjectName sn on tr.subname_seq = sn.subname_seq

where sn.subname = 'Oracle' order by 과정명, 교사명 ; 
