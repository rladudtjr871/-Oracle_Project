--D_00 학생 로그인 성공화면

-- 회원기본정보 : 이름, 주번뒷자리, 전화번호, 등록일, 수강과정명, 과정기간, 강의실


select 
    m.m_name as 이름 , 
    m.m_password as 비밀번호, 
    m.m_tel as 전화번호, 
    m.m_registdate as 등록일자,
    cn.course_neme as 과정번호,
    c.c_start_date || ' ~ ' ||  c.c_end_date as 과정기간 ,
    r.room_name as 강의실,
    t.t_name as 강사명
    
from tblMember m 
    inner join tblSugang s
        on m.member_seq = s.member_seq
            inner join tblCourse c
                on s.course_seq = c.course_seq
                    inner join tblRoom r
                        on c.room_seq = r.room_seq
                            inner join tblCourseName cn
                                on c.cname_seq = cn.cname_seq
                                    inner join tblTeacher t
                                        on c.teacher_seq = t.teacher_seq
                                            where s.sugang_seq = 180; --번호는 입력가능!

 
    