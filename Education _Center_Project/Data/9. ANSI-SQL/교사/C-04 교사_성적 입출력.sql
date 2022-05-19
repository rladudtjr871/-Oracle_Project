-- 내 개설과정 강의종료 과목
select 
    cs.csub_seq as "과목번호",
    sj.subname as "과목명",
    case 
        when cs.csend_date < sysdate then '진행 종료'
    end as "진행 상태"
from tblCSub cs 
    inner join tblCourse c 
        on cs.course_seq = c.course_seq 
            inner join tblSubjectname sj 
                on cs.subname_seq = sj.subname_seq 
                    where cs.csend_date < sysdate and c.teacher_seq = 
                        (select teacher_seq from tblteacher where t_name = '최경하' and t_password = 2532102)
                            order by cs.csstart_date asc;
                




-- 개설과목 선택
select 
    distinct cs.csub_seq as "개설과목번호",
    cn.course_neme as "개설과정명",
    c.c_start_date as "과정시작일",
    c.c_end_date as "과정종료일",
    r.room_name as "강의실명",
    sj.subname as "개설과목명",
    cs.csstart_date as "과목시작일",
    cs.csend_date as "과목종료일",
    sp.attend_point as "출결 배점",
    sp.pilgi_point as "필기 배점",
    sp.silgi_point as "실기 배점",
    (case when s.silgi_score is not null then 'Y' else 'N' end) as 성적등록여부
from tblCSub cs
    left outer join tblCourse c 
        on cs.course_seq = c.course_seq
            left outer join tblCourseName cn 
                on c.cname_seq = cn.cname_seq
                    left outer join tblRoom r 
                        on c.room_seq = r.room_seq
                            left outer join tblSubjectName sj 
                                on cs.subname_seq = sj.subname_seq
                                    left outer join tblSubjectTxt st 
                                        on sj.subname_seq = st.subname_seq
                                            left outer join tblTextBook tb 
                                                on st.txtbook_seq = tb.txtbook_seq
                                                    left outer join tblSugang su 
                                                        on c.course_seq = su.course_seq
                                                            left outer join tblSubtPoint sp 
                                                                on sp.csub_seq = cs.csub_seq
                                                                    left outer join tblScore s 
                                                                        on cs.csub_seq = s.csub_seq
                                                                            where cs.csub_seq = 142 and c.teacher_seq = 
                                                                                (select teacher_seq from tblteacher where t_name = '최경하' and t_password = 2532102);



-- 과목에 따른 교재 출력 > 내 스케줄 강의선택 시 출력되어야함 but 중복이 너무 많아서 따로처리
select 
    distinct sn.subname_seq as "과목번호",
    sn.subname as "과목명",
    tb.name as "교재명"
from tblSubjectName sn
    inner join tblSubjectTxt st 
        on st.subname_seq = sn.subname_seq
            inner join tblTextBook tb 
                on st.txtbook_seq = tb.txtbook_seq
                    order by sn.subname_seq;


    

-- 특정 과목 번호 선택
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
                                            where cs.csub_seq = 143
                                                order by su.sugang_seq; 
                    
                    


-- 수강생 번호 선택 > 시험 점수 등록
insert into tblScore values ((select max(score_seq)+1 from tblScore), 20, 30, 50, 1, (select sugang_seq from tblSugang where sugang_seq = 5));


