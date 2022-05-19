-- 작성된 추천 도서 조회
select 
    tr.book_seq as "추천도서번호",
    tr.rec_name as "추천도서명", 
    p.name as "출판사", 
    tr.book_date as "등록일", 
    t.t_name as "등록 교사", 
    sn.subname as "연관 과목명" 
from tblTeachRec tr 
    inner join tblTeacher t 
        on tr.teacher_seq = t.teacher_seq 
            inner join tblSubjectName sn 
                on tr.subname_seq = sn.subname_seq
                    inner join tblPublisher p 
                        on tr.publisher_seq = p.publisher_seq
                            order by tr.book_seq;




-- 추천 도서 등록

-- 출판사가 존재하는지 확인
select name from tblPublisher where name = '제이펍';

-- 존재하지 않는다면 출판사 추가
insert into tblPublisher values ((select max(publisher_seq) +1 from tblPublisher), '출판사명');



-- 출판사 유무 처리후 삽입
insert into tblTeachRec 
    values ((select max(book_seq) + 1 from tblTeachRec),
        (select teacher_seq from tblteacher where t_name = '최경하' and t_password = 2532102), -- 교사번호 입력
        '책제목', sysdate, 
        (select subname_seq from tblsubjectname where subname = 'Java'), -- 과목번호 가져오기
        (select publisher_seq from tblpublisher where name = '제이펍')); -- 출판사 번호 가져오기


-- 추천도서 수정하기
update tblTeachRec set rec_name = '변경할 값' where book_seq = 1; -- 도서번호 1의 도서명 수정하기

update tblTeachRec set subname_seq = (select subname_seq from tblsubjectname where subname = '변경할 과목명') where book_seq = 1; -- 연관과목 변경하기

update tblTeachRec set publisher_seq = (select publisher_seq from tblpublisher where name = '제이펍') where book_seq = 1; -- 출판사 변경하기


-- 추천도서 삭제하기
delete tblTeachRec where book_seq = 1;