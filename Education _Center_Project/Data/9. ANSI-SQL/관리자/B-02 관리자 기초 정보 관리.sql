-- B-02 관리자 기초 정보 관리.sql

-- 기초 정보 등록 및 관리(교사 계정 관리 및 개설 과정, 개설 과목에 사용)

    select * from tblCourseName;

----------------- 기초 정보 입력 ------------------

--과정명 입력
    insert into tblCourseName (cname_seq, course_neme) values ((select max(cname_seq) + 1 from tblCourseName), '추가 과정명');
--과목명 입력
    insert into tblSubjectName (subname_seq, subname, subname_subject) values ((select max(subname_seq) + 1 from tblSubjectName), '추가 과목명', '선택');
--강의실명 입력
    insert into tblRoom (room_seq, room_name, room_personel) values ((select max(room_seq) + 1 from tblRoom), '추가 강의실', 수용인원);
--교재명 입력
    insert into tblTextBook (txtbook_seq, name, author, publisher_seq) values ((select max(txtbook_seq) + 1 from tblTextBook), '추가 교재명', '지은이명', (select 
                                                                                                                                                        case when name = '출판사명' then publisher_seq
                                                                                                                                                        case when name = '출판사명' is null then (insert 출판사테이블에 새로 추가)
                                                                                                                                                        from tblPublisher 
                                                                                                                                                            where name = '출판사명'));

----------------- 기초 정보 수정 -----------------

--과정명 수정
    update tblCourseName set course_neme = '수정할 과정명' where cname_seq = 과정번호;
--과목명 수정
    update tblSubjectName set subname = '수정할 과목명', subname_subject = '공통' where subname_seq = 과목번호;
--강의실명 수정
    update tblRoom set room_name = '수정할 강의실명', room_personel = 26 where room_seq = 강의실번호;
--교재명 수정
    update tblTextBook set name = '수정할 교재이름', publisher = '수정할 출판사' where txtbook_seq = 교재번호;



----------------- 기초 정보 출력 -----------------

--과정명 출력
    select * from tblCourseName;
--과목명 출력
    select * from tblSubjectName;
--강의실명 출력
    select * from tblRoom;
--교재명 출력
    select * from tblTextBook;

----------------- 기초 정보 삭제 -----------------

--과정명 삭제
    delete from tblCourseName where cname_seq = 과정번호;
--과목명 삭제
    delete from tblSubjectName where subname_seq = 과목번호;
    delete from tblSubjectName where subname = '과목명'; 
--강의실명 삭제
    delete from tblRoom where room_seq = 강의실번호;
    delete from tblRoom where room_name = '강의실명';
--교재명 삭제
    delete from tblTextBook where txtbook_seq = 교재번호;