-- B-03 교사 계정 관리.sql


----------------- 교사 정보 입력 -----------------

-- 교사 이름, 주민번호 뒷자리, 전화번호 입력
    insert into tblteacher (teacher_seq, t_name, t_password, t_tel) values ((select max(teacher_seq) + 1 from tblteacher), '교사명', 주민등록번호뒷자리, 전화번호);
-- 교사의 강의 가능 과목 입력
    insert into tblTeacherSub (tsubject_seq, teacher_seq, subname_seq) values ((select max(tsubject_seq) + 1 from tblTeacherSub)
                                                                            ,(select teacher_seq from tblteacher where t_name = '교사명')
                                                                            ,(select subname_seq from tblSubjectName where subname = '과목명'));
                        
----------------- 교사 정보 전체 출력 -----------------




-- 교사의 개인 정보 출력
    select 
        t.t_name as "교사명", 
        t.t_password as "주민등록번호 뒷자리", 
        t.t_tel as "전화번호"
    from tblteacher t
    order by t.t_name asc;


-- 교사의 강의 가능 과목 출력

    select 
        t.t_name as "교사명",
        n.subname as "강의 가능 과목"
    from tblteacher t
        inner join tblTeacherSub s
            on t.teacher_seq = s.teacher_seq
                inner join tblSubjectName n
                    on s.subname_seq = n.subname_seq
                        order by t.t_name asc;


----------------- 특정 교사 정보 출력 -----------------


-- 특정 교사의 배정된 개설 과목 출력

select 
    sj.subname as "배정된 개설 과목명",
    cs.csstart_date "개설 과목 시작날짜",
    cs.csend_date "개설 과목 종료날짜"
from tblCSub cs
    inner join tblSubjectname sj 
        on cs.subname_seq = sj.subname_seq
            inner join tblCourse c 
                on cs.course_seq = c.course_seq
                    inner join tblteacher t
                        on c.teacher_seq = t.teacher_seq
                            where t.t_name = 교사이름;


-- 특정 교사의 과정 정보 , 강의실명, 강의 진행 상태 출력 

    select 
        cn.course_neme as "과정명", 
        c.c_start_date as "개설과정시작날짜", 
        c.c_end_date as "개설과정끝날짜",
        r.room_name as "강의실명",
        
        case 
            when c_start_date > sysdate then '강의 예정'
            when c_start_date < sysdate and c_end_date > sysdate then '강의중'
            when c_end_date < sysdate then '강의종료'
        end as "강의 진행 상태"
    from tblteacher t
        inner join tblCourse c
            on t.teacher_seq = c.teacher_seq
                inner join tblCourseName cn
                    on cn.cname_seq = c.cname_seq
                        inner join tblRoom r
                            on c.room_seq = r.room_seq
                                 where t.t_name = 교사이름;


-- 특정 교사의 수업하는 교재명 출력



    select
        tb.name
    from tblteacher t
        inner join tblTeacherSub ts
            on t.teacher_seq = ts.teacher_seq
                inner join tblSubjectName sn
                    on sn.subname_seq = ts.subname_seq                       
                        inner join tblSubjectTxt st             -- 과목에 쓰이는 교재
                                on st.subname_seq = sn.subname_seq
                                    inner join tblTextBook tb   --교재
                                        on tb.txtbook_seq = st.txtbook_seq
                                             where t.t_name = 교사이름;
            
        





----------------- 교사 정보 수정 -----------------

-- 교사 이름 수정
    update tblteacher set t_name = '교사명' where teacher_seq = 교사번호;
-- 교사 주민등록번호뒷자리 수정
    update tblteacher set t_password = 주민등록번호뒷자리 where teacher_seq = 교사번호;
-- 교사 전화번호 수정
    update tblteacher set t_tel = '전화번호' where teacher_seq = 교사번호;
-- 교사의 강의 가능 과목 수정    >  교사가 강의 가능한 과목을 다른 과목으로 수정하고 싶을 때, 
--                                  과목명 테이블에서 수정하고 싶은 과목명의 과목명번호로 교사 강의 목록 테이블의 과목명번호를 수정해줌 
    update tblTeacherSub set subname_seq = (select subname_seq from tblSubjectName where subname = '과목명') where tsubject_seq = 교사강의목록번호;
    
    
----------------- 교사 정보 삭제 -----------------   
    
    delete from tblteacher where teacher_seq = 교사번호;
    
    -- 특정 교사의 특정 과목 삭제 
    delete from tblTeacherSub where teacher_seq = 교사번호, subname_seq = 과목명번호;
    
    -- 특정 교사 삭제
    delete from tblTeacherSub where teacher_seq = 교사번호;