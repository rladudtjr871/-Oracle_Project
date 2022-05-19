-- C-03 교사 - 배점입출력

-- 교사 로그인
select * from tblTeacher where t_password = 2142021;

-- 배점 입출력 출력
-- 과목번호/과정명/과정시작일/과정종료일/강의실/과목명/과목시작일/과목종료일/교재명/출결/필기배점/실기배점

select 
    cs.csub_seq as 과목번호,
    c.c_start_date as 과정시작일,
    c.c_end_date as 과정종료일,
    r.room_name as 강의실,
    sn.subname as 과목명,
    cs.csstart_date as 과목시작일,
    cs.csend_date as 과목종료일,
    sp.attend_point as 출결배점,
    sp.pilgi_point as 필기배점,
    sp.silgi_point as 실기배점
from tblCourse c
        inner join tblRoom r
            on c.room_seq = r.room_seq
                inner join tblCourseName cn
                    on c.cname_seq = cn.cname_seq
                        inner join tblCSub cs
                            on c.course_seq = cs.course_seq
                                inner join tblSubjectName sn
                                    on cs.subname_seq = sn.subname_seq
                                        left outer join tblSubtPoint sp
                                            on cs.csub_seq = sp.csub_seq
            where c.teacher_seq = (select teacher_seq from tblTeacher where t_password = 2142021) and cs.csend_date < sysdate and sysdate < c.c_end_date
                order by cs.csstart_date;

-- 교재명 출력
select
    distinct
    tb.name as 교재명,
    sn.subname
from tblCourse c
    inner join tblCSub cs
        on c.course_seq = cs.course_seq
            inner join tblSubjectName sn
                on cs.subname_seq = sn.subname_seq
                    inner join tblSubjectTxt st
                        on sn.subname_seq = st.subname_seq
                            inner join tblTextBook tb
                                on st.txtbook_seq = tb.txtbook_seq;


-- 과목번호 선택
select 
    sp.attend_point as 출결배점,
    sp.pilgi_point as  필기배점,
    sp.silgi_point as 실기배점,
    td.test_date as 시험날짜,
    tn.test_type as 유형,
    tn.test as 시험문제
from tblCSub cs 
    left outer join tblSubtPoint sp
        on cs.csub_seq = sp.csub_seq
            inner join tblSubjectName sn
                on cs.subname_seq = sn.subname_seq
                    left outer join tbltestdate td
                        on cs.csub_seq = td.csub_seq
                            left outer join tblTest t
                                on td.testnum_seq = t.testnum_seq
                                    left outer join tblTestName tn
                                        on t.testname_seq = tn.testname_seq
                 where cs.csub_seq = 152; 


-- 특정과목 선택 시 출결/필기/실기 배점 입력
--                              !배점 100점 실패 시 안되는 프로시저 필요!
select * from tblsubtpoint;
insert into tblSubtPoint (subpoint_seq, attend_point, pilgi_point, silgi_point, teacher_seq, csub_seq) values (37, 20, 30, 50, 3, 152);

    
-- 문제 등록하는 법
-- insert into tblTestName(testname_seq, test, test_type, subname_seq) values (시험문제번호pk, 시험문제, 유형, 과목명번호fk);
-- insert into tblTest(testnum_seq, teacher_seq, testname_seq) values(교사가정한시험문제번호pk, 교사번호fk, 시험문제번호fk);
-- insert into tblTestDate(testdate_seq, test_date, testnum_seq, csub_seq) values(시험날짜번호pk, 시험날짜, 교사가정한시험문제번호, 개설과정내과목번호);

-- 1. TestName 있는 문제 등록
-- testName에 있는 내용 > test > testDate에 연결
insert into tblTest(testnum_seq, teacher_seq, testname_seq) values(73, 3, 5);
insert into tblTestDate(testdate_seq, test_date, testnum_seq, csub_seq) values(73, '2022-03-21', 73, 152);


-- 2. 새로운 시험문제 등록
insert into tblTestName(testname_seq, test, test_type, subname_seq) values(77, 'Java실기문제 추가', '실기', 3);
insert into tblTest(testnum_seq, teacher_seq, testname_seq) values(74, 3, 77);
insert into tblTestDate(testdate_seq, test_date, testnum_seq, csub_seq) values(74, '2022-03-22', 74, 152);







