-- B-05 개설 과목 관리.sql



----------------- 개설 과목 정보 전체 출력 ----------------- 




    select distinct
        cn.course_neme as "과정명",
        c.c_start_date as "과정 시작 날짜",
        c.c_end_date as "과정 종료 날짜",
        sn.subname as "과목명", 
        cs.csstart_date as "과목 시작 날짜",
        cs.csend_date as "과목 종료 날짜",          
        tb.name as "교재명",
        t.t_name as "교사명"
        
    from tblCSub cs
        inner join tblCourse c
            on cs.course_seq = c.course_seq
                inner join tblCourseName cn
                    on c.cname_seq = cn.cname_seq
                        inner join tblSubjectName sn
                            on sn.subname_seq = cs.subname_seq 
                                inner join tblSubjectTxt st
                                        on st.subname_seq = sn.subname_seq
                                            inner join tblTextBook tb
                                                on tb.txtbook_seq = st.txtbook_seq
                                                    inner join tblteacher t
                                                        on t.teacher_seq = c.teacher_seq;

-- 현재 개설된 과정 정보
/    
    select distinct
        cn.course_neme as "과정명",
        c.c_start_date as "과정 시작 날짜",
        c.c_end_date as "과정 종료 날짜",
        t.t_name as "교사명"
    from tblCSub cs
        inner join tblCourse c
            on cs.course_seq = c.course_seq
                inner join tblCourseName cn
                    on c.cname_seq = cn.cname_seq
                        inner join tblteacher t
                            on t.teacher_seq = c.teacher_seq
                                order by c.c_start_date desc;
                                
-- 개설된 과정의 과목 정보
/ 
    select distinct
        c.course_seq "과정번호",
        sn.subname as "과목명", 
        cs.csstart_date as "과목 시작 날짜",
        cs.csend_date as "과목 종료 날짜"          
    from tblCourse c
        inner join tblCSub cs
            on c.course_seq = cs.course_seq
                 inner join tblSubjectName sn
                    on sn.subname_seq = cs.subname_seq 
                        inner join tblSubjectTxt st
                                on st.subname_seq = sn.subname_seq
                                    inner join tblTextBook tb
                                        on tb.txtbook_seq = st.txtbook_seq
                                            inner join tblCourse c
                                                on cs.course_seq = c.course_seq
                                                    order by c.course_seq asc;

    
-- 개설 과목 정보의 교재명 출력
    
    select distinct
        sn.subname as "과목명", 
        tb.name as "교재명"
        from tblCSub cs                                 --개설 과정 내 과목명(동적)
            inner join tblSubjectName sn                    --과목명
                on sn.subname_seq = cs.subname_seq 
                    inner join tblSubjectTxt st             -- 과목에 쓰이는 교재
                            on st.subname_seq = sn.subname_seq
                                inner join tblTextBook tb   --교재
                                    on tb.txtbook_seq = st.txtbook_seq
                                        order by sn.subname asc;


----------------- 선택한 개설 과정에 대한 개설 과목 정보 출력 ----------------- 
  

-- 선택한 개설 과정의 과정명, 과정 시작 날짜, 과정 종료 날짜, 교사명, 강의실명 출력

    select distinct
        cn.course_neme as "과정명",
        c.c_start_date as "과정 시작 날짜",
        c.c_end_date as "과정 종료 날짜",
        t.t_name as "교사명",
        r.room_name as "강의실명"
    from tblCSub cs
        inner join tblCourse c
            on cs.course_seq = c.course_seq
                inner join tblCourseName cn
                    on c.cname_seq = cn.cname_seq
                        inner join tblteacher t
                            on t.teacher_seq = c.teacher_seq
                                inner join tblRoom r
                                    on c.room_seq = r.room_seq
                                        where c.course_seq = 1
                                            order by c.c_start_date desc;




-- 선택한 특정 개설 과정의 과목 출력

    select 
        sn.subname as "과목명",
        cs.csstart_date as "과목 시작일",
        cs.csend_date as "과목 종료일"
    from tblCourse c
        inner join tblCSub cs 
            on c.course_seq = cs.course_seq 
                inner join tblSubjectName sn
                    on sn.subname_seq = cs.subname_seq
                        where c.course_seq = 개설과정번호;    
                



-- 선택한 특정 개설 과정의 과목교재 출력

    select distinct
    sn.subname as "과목명", 
    tb.name as "교재명"    
    from tblCSub cs                                 --개설 과정 내 과목명(동적)
        inner join tblSubjectName sn                    --과목명
            on sn.subname_seq = cs.subname_seq 
                inner join tblSubjectTxt st             -- 과목에 쓰이는 교재
                        on st.subname_seq = sn.subname_seq
                            inner join tblTextBook tb   --교재
                                on tb.txtbook_seq = st.txtbook_seq
                                    where cs.course_seq = 개설과정번호
                                        order by sn.subname asc;






----------------- 개설 과목 정보 수정 ----------------- 

--개설과목 일정 변경
    update tblCSub set csstart_date = '변경시작날짜', csend_date = '변경종료날짜' where csub_seq = 개설과정내과목번호;  

--개설과목 과목 변경
    update tblCSub set sbuname_seq = 과목명번호 where csub_seq = 개설과정내과목번호;  
    

----------------- 개설 과목 정보 삭제 -----------------

    delete from tblCSub where csub_seq = 개설과정내과목번호;
