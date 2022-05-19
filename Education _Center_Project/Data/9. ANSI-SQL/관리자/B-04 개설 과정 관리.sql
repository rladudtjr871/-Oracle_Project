-- B-04 개설 과정 관리.sql


----------------- 개설정보 등록(입력) -----------------   
    insert into tblCourse (course_seq, c_start_date, c_end_date, cname_seq, teacher_seq, room_seq) values ((select max(course_seq) + 1 from tblCourse),'개설과정시작날짜', '개설과정끝날짜', 과정명번호, 교사번호, 강의실번호 );
   
   
   
----------------- 개설정보 출력 -----------------    

   select
        cn.course_neme as "개설 과정명",
        c.c_start_date as "개설과정 시작날짜",
        c.c_end_date as "개설과정 종료날짜",
        r.room_name as "강의실명",
        t.t_name as "교사명",
        case when c.course_seq in (select distinct course_seq from tblCSub) then 'Y'
             else 'N' 
        end as "개설과목 등록여부",
        (select count(*) from tblSugang where course_seq = c.course_seq) as "수강 인원"
    from tblCourse c
        inner join tblCourseName cn
            on c.cname_seq = cn.cname_seq
                inner join tblRoom r
                    on c.room_seq = r.room_seq
                        inner join tblteacher t
                            on c.teacher_seq = t.teacher_seq
                                order by c.c_start_date desc, cn.course_neme desc;
   
   
   
----------------- 특정 개설 과정 선택해서 출력 -----------------  

    
/    

-- 선택한 특정 개설 과정의 교사 출력
    select 
        t.t_name as "교사명"
    from tblCourse c 
         inner join tblteacher t
            on t.teacher_seq = c.teacher_seq
                where c.course_seq = 개설과정번호;
    
    
    
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
                                        
-- 선택한 특정 개설 과정의 교육생 출력
    select 
        m.m_name as "교육생명",
        m.m_password as "주민번호 뒷자리",
        m.m_tel as "교육생전화번호",
        m.m_registdate as "교육생등록일",
        m.m_major as "전공여부",
        case
            when s.progress = '수강종료' then '수료'
            when s.progress = '중도탈락' then '중도탈락'
        end as "수료 및 중도 탈락"
    from tblCourse c     
        inner join tblSugang s
            on s.course_seq = c.course_seq
                inner join tblMember m
                    on s.member_seq = m.member_seq
                        where c.course_seq = 개설과정번호;


                        
----------------- 개설 과정 정보 수정 -----------------  

    
    
    -- 과정명 수정
    update tblCourse set cname_seq = 변경개설과정명번호 where course_seq = 개설과정번호;
    -- 과정 시작 날짜 수정
    update tblCourse set c_start_date = '변경 과정 시작 날짜' where course_seq = 개설과정번호;
    -- 과정 끝 날짜 수정
    update tblCourse set c_end_date = '변경 과정 끝 날짜' where course_seq = 개설과정번호;
    -- 강의실 정보 수정
    update tblCourse set room_seq = 변경강의실번호 where course_seq = 개설과정번호;
    
    
----------------- 개설 과정 정보 삭제 -----------------    

    delete from tblCourse where course_seq = 개설과정번호;




----------------- 수료날짜 지정 -----------------  

-- 특정 개설 과정이 수료한 경우 등록된 교육생 전체 수료날짜 지정(중도탈락자는 제외)


-- 테스트용 업데이트
update tblsugang set complete_date = null where complete_date = '22/02/01';

-- 수료일 미정 출력
select 
    c.course_seq,
    c.c_start_date,
    c.c_end_date,
    s.sugang_seq, 
    s.complete_date,
    s.progress
from tblcourse c
    inner join tblsugang s
        on c.course_seq = s.course_seq
            where c.c_end_date < sysdate and s.complete_date is null;
            
            
            
-- 수료일 업데이트

update tblsugang sg set complete_date = (select c.c_end_date from tblcourse c inner join tblsugang s on c.course_seq = s.course_seq    
                                                where c.c_end_date < sysdate and s.sugang_seq = sg.sugang_seq and s.progress <> '중도탈락');
                                                                                     

-- 테스트용
select * from tblsugang;    
update tblsugang set progress = '중도탈락' where sugang_seq = 180;
update tblsugang set progress = '중도탈락' where sugang_seq = 80;
update tblsugang set progress = '중도탈락' where sugang_seq = 150;