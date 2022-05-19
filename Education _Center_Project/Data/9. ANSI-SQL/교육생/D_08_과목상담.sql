--D_08_과목상담

--1. 상담 신청하기
-- 수강중인 학생이 과목을 선택한 후 상담내용을 작성한다. 


insert into tblConsult (consult_seq, consult_txt, csub_seq, sugang_seq) 
    values(500, '상담내용'	
            , (select  
                    cs.csub_seq --과목과정번호  
                from tblCourse c
                    inner join tblSugang s on c.course_seq = s.course_seq 
                        inner join tblCSub cs on c.course_seq = cs.course_seq
                            inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq 
                                where s.sugang_seq = 180 and sn.subname = 'Java') 
            , 180);



--2. 본인상담 내역조회 
select 
    sj.subname as 과목,
    c.consult_txt as 질문,
    a.answer_txt as 답변,
    t.t_name as 강사명
    
from tblConsult c
    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
        left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
            left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
             where c.sugang_seq = 180; --번호 입력






-- 3. 과목상담내역조회 

select 
    sj.subname as 과목,
    cn.course_neme as 과정,
    c.consult_txt as 질문,
    a.answer_txt as 답변,
    t.t_name as 강사명
    
from tblConsult c
    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
        left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
            left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                        left outer join tblCourse c on cs.course_seq = c.course_seq
                            left outer join tblCourseName cn on c.cname_seq = cn.cname_seq
             where sj.subname = 'Java'; --번호 입력




ROLLBACK;


















-- 참고
select  
    cs.csub_seq --과목과정번호  
from tblCourse c
    inner join tblSugang s on c.course_seq = s.course_seq 
        inner join tblCSub cs on c.course_seq = cs.course_seq
            inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq where s.sugang_seq = 180 and sn.subname = 'Java'; -- 과목입력
            
            




select * from tblSubjectTxt;




