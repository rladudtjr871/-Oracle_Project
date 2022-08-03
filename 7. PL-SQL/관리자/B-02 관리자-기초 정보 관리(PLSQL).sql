
-- B-02 관리자 기초 정보 관리(PL/SQL).sql


----------------- 기초 정보 입력 ------------------


-- 1. 과정명 입력

    create or replace procedure procCourseNameAdd (
        pcname tblCourseName.course_neme%type,
        presult out number
    )
    is
    
    begin
        insert into tblCourseName (cname_seq, course_neme)
            values ((select max(cname_seq) + 1 from tblCourseName),
                    pcname);
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end procCourseNameAdd;    
                


--******************************************************************************
    declare
        vresult number;
    begin
        procCourseNameAdd('추가 과정명', vresult);
        if vresult = 1 then
            dbms_output.put_line('과정명 등록에 성공하였습니다.');
        else
            dbms_output.put_line('과정명 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************




-- 2. 과목명 입력
    create or replace procedure procSubAdd(
        pname tblsubjectname.subname%type,
        psubselect tblsubjectname.subname_subject%type,
        presult out number
    )
    is
    
    begin
         insert into tblSubjectName (subname_seq, subname, subname_subject) values 
                ((select max(subname_seq) + 1 from tblSubjectName), pname, psubselect);
            
        presult := 1;            
    exception
        when others then
            presult := 0;
    end;
    

--******************************************************************************
    declare
        vresult number;
    begin
        procSubAdd('추가 과목명','선택', vresult);
        if vresult = 1 then
            dbms_output.put_line('과목명 등록에 성공하였습니다.');
        else
            dbms_output.put_line('과목명 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************    



-- 강의실명 입력

    create or replace procedure procRoomAdd(
        prname tblroom.room_name%type,
        prnum tblroom.room_personel%type,
        presult out number
    )
    is
    begin
        insert into tblRoom (room_seq, room_name, room_personel) 
                values ((select max(room_seq) + 1 from tblRoom), prname, prnum);
    
    presult := 1;            
    exception
        when others then
            presult := 0;
    end;
    

--******************************************************************************
    declare
        vresult number;
    begin
        procRoomAdd('추가 강의실',30, vresult);
        if vresult = 1 then
            dbms_output.put_line('강의실 등록에 성공하였습니다.');
        else
            dbms_output.put_line('강의실 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************    


--4. 교재명 입력
    create or replace procedure procBookAdd (
        pname tbltextbook.name%type,
        pauthor tbltextbook.author%type,
        pseq tbltextbook.publisher_seq%type,
        presult out number
    )
    is
    begin
     insert into tblTextBook (txtbook_seq, name, author, publisher_seq) values ((select max(txtbook_seq) + 1 from tblTextBook), pname, pauthor, pseq);
     
    presult := 1;            
    exception
        when others then
            presult := 0;
    end;
    

--******************************************************************************
    declare
        vresult number;
    begin
        procBookAdd('추가 교재','지은이',1, vresult);
        if vresult = 1 then
            dbms_output.put_line('교재 등록에 성공하였습니다.');
        else
            dbms_output.put_line('교재 등록에 실패하셨습니다.');
        end if;
    end;
--******************************************************************************    








----------------- 기초 정보 수정 -----------------


-- 1. 과정명 수정
    create or replace procedure procCourseNameup (
        pcname_seq tblCourseName.cname_seq%type,
        pcourse_neme tblCourseName.course_neme%type,
        presult out number
    )
    is
    begin
    
        update tblCourseName set course_neme = pcourse_neme where cname_seq = pcname_seq;
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end procCourseNameup;


--******************************************************************************
    declare
        vresult number;
    begin
        procCourseNameup(8, '프론트엔드 혼합 개발자 양성과정', vresult); -- 변경할 번호, 변경내용
        if vresult = 1 then
            dbms_output.put_line('과정명 수정에 성공하셨습니다.');
        else
            dbms_output.put_line('과정명 수정에 실패하였습니다.');
        end if;
    end;
--******************************************************************************


-- 2. 과목 수정
create or replace procedure procSubjectNameup (
    psubname_seq tblSubjectName.subname_seq%type,
    psubname tblSubjectName.subname%type,
    psubname_subject tblSubjectName.subname_subject%type,
    presult out number
)
is
begin

    update tblSubjectName set subname = psubname, subname_subject = psubname_subject where subname_seq = psubname_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procSubjectNameup;



--******************************************************************************
declare
    vresult number;
begin
    procSubjectNameup(1, '테스트', '공통', vresult); -- 변경할 번호, 변경이름, 공통/선택
    if vresult = 1 then
        dbms_output.put_line('과목 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('과목 수정에 실패하였습니다.');
    end if;
end;

--******************************************************************************

-- 3. 강의실 수정
create or replace procedure procRoomup (
    proom_seq tblRoom.room_seq%type,
    proom_name tblRoom.room_name%type,
    proom_personel tblRoom.room_personel%type,
    presult out number
)
is
begin

    update tblRoom set room_name = proom_name, room_personel = proom_personel where room_seq = proom_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procRoomup;



--******************************************************************************
declare
    vresult number;
begin
    procRoomup(1, '1강의실', 28, vresult); -- 변경할 강의실 번호, 변경할 내용, 변경 정원
    if vresult = 1 then
        dbms_output.put_line('강의실 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('강의실 수정에 실패하였습니다.');
    end if;
end;
--******************************************************************************

-- 4-1. 교재 도서명 수정
create or replace procedure proctbltextbookup1 (
    p_txtbook_seq tbltextbook.txtbook_seq%type,
    pname tbltextbook.name%type,
    presult out number
)
is
begin
        update tbltextbook set name = pname where txtbook_seq = p_txtbook_seq; -- 도서번호 1의 도서명 수정하기
        presult := 1;
exception
    when others then
        presult := 0;
end proctbltextbookup1;

select * from tbltextbook;


--******************************************************************************

declare
    vresult number;
begin
    proctbltextbookup1(1, '테스트' ,vresult);
    
    if vresult = 1 then
        dbms_output.put_line('도서명 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('도서명 수정에 실패하셨습니다.');
    end if;
end;

--******************************************************************************



-- 4-2.교재 지은이 수정
create or replace procedure proctbltextbookup2 (
    p_txtbook_seq tbltextbook.txtbook_seq%type,
    pauthor tbltextbook.author%type,
    presult out number
)
is
begin
        update tbltextbook set author = pauthor where txtbook_seq = p_txtbook_seq; -- 교재 지은이 변경하기
        presult := 1;
exception
    when others then
        presult := 0;
end proctbltextbookup2;



--******************************************************************************

declare
    vresult number;
begin
    proctbltextbookup2(1, '작자미상', vresult);
    
    if vresult = 1 then
        dbms_output.put_line('지은이 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('지은이 수정에 실패하셨습니다.');
    end if;
end;

--******************************************************************************



-- 4-3. 교재 출판사 수정
create or replace procedure proctbltextbookup3 (
    p_txtbook_seq tbltextbook.txtbook_seq%type,
    p_publisher tblpublisher.name%type,
    presult out number
)
is
begin
        update tbltextbook set publisher_seq = (select publisher_seq from tblpublisher where name = p_publisher) where txtbook_seq = p_txtbook_seq; -- 출판사 변경하기
        presult := 1;
exception
    when others then
        presult := 0;
end proctbltextbookup3;



--******************************************************************************

declare
    vresult number;
begin
    proctbltextbookup3(1,'비제이퍼블릭', vresult);
    
    if vresult = 1 then
        dbms_output.put_line('출판사 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('출판사 수정에 실패하셨습니다.');
    end if;
end;

--******************************************************************************







----------------- 기초 정보 출력 -----------------

-- 과정명 출력 뷰 생성

create or replace view vwCNameBasic
as
select
    cname_seq as "번호",
    course_neme as "과정명"
from tblCourseName;


--******************************************************************************

select * from vwCNameBasic;

--******************************************************************************


-- 과목명 출력 뷰 생성

create or replace view vwSubNameBasic
as
select
    subname_seq as "번호",
    subname as "과목명",
    subname_subject as "과목종료"
    
from tblSubjectName;


--******************************************************************************

select * from vwSubNameBasic;

--******************************************************************************


-- 강의실명 출력 뷰 생성

create or replace view vwRoomBasic
as
select
    room_seq as "번호",
    room_name as "강의실명",
    room_personel as "수강인원"
from tblRoom;


--******************************************************************************

select * from vwRoomBasic;

--******************************************************************************





-- 교재명 출력 뷰 생성

create or replace view vwBookBasic
as
select
    b.txtbook_seq as "번호",
    b.name as "교재명",
    b.author as "지은이",
    (select name from tblPublisher where publisher_seq = b.publisher_seq) as "출판사명"
from tblTextBook b;


--******************************************************************************

select * from vwBookBasic;

--******************************************************************************

                                                        
-- 과정명에 대한 과목명 출력
    
    create or replace view vwCourseSubBasic
    as
    select 
        cn.course_neme as "과정명",
        sn.subname as "과목명"
    from tblCSub cs
        inner join tblCourse c
            on cs.course_seq = c.course_seq
                 inner join tblCourseName cn
                            on c.cname_seq = cn.cname_seq
                                inner join tblSubjectName sn
                                    on sn.subname_seq = cs.subname_seq;
                                    
--******************************************************************************

select * from vwCourseSubBasic;

--******************************************************************************


-- 과목명에 대한 교재명 출력
create or replace view vwSubBookBasic
as
select 
    sn.subname as "과목명", 
    tb.name as "교재명"
from tblCSub cs
inner join tblSubjectName sn
    on sn.subname_seq = cs.subname_seq 
        inner join tblSubjectTxt st
                on st.subname_seq = sn.subname_seq
                    inner join tblTextBook tb
                        on tb.txtbook_seq = st.txtbook_seq;
                        
                        
                                    
--******************************************************************************

select * from vwSubBookBasic;

--******************************************************************************
                        
                        
----------------- 기초 정보 삭제 -----------------


-- 1. 과정명 삭제
create or replace procedure procCourseNamede (
    pcname_seq tblCourseName.cname_seq%type,
    presult out number
)
is
begin

    delete from tblCourseName where cname_seq = pcname_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procCourseNamede;



--******************************************************************************
declare
    vresult number;
begin
    procCourseNamede(8, vresult); -- 삭제할 내용
    if vresult = 1 then
        dbms_output.put_line('과정명 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('과정명 삭제에 실패하였습니다.');
    end if;
end;

--******************************************************************************

-- 2. 과목 삭제
    create or replace procedure tblSubjectNamede (
        psubname_seq tblSubjectName.subname_seq%type,
        presult out number
    )
    is
    begin
    
        delete from tblSubjectName where subname_seq = psubname_seq;
        presult := 1;
        
    exception
        when others then
            presult := 0;
    end tblSubjectNamede;


--******************************************************************************
    declare
        vresult number;
    begin
        tblSubjectNamede(8, vresult); -- 삭제할 내용
        if vresult = 1 then
            dbms_output.put_line('과목 삭제에 성공하셨습니다.');
        else
            dbms_output.put_line('과목 삭제에 실패하였습니다.');
        end if;
    end;
--******************************************************************************

-- 3. 강의실 삭제

create or replace procedure procRoomde (
    proom_seq tblRoom.room_seq%type,
    presult out number
)
is
begin

    delete from tblRoom where room_seq = proom_seq;
    presult := 1;
    
exception
    when others then
        presult := 0;
end procRoomde;


--******************************************************************************
declare
    vresult number;
begin
    procRoomde(1, vresult); -- 삭제 강의실 번호
    if vresult = 1 then
        dbms_output.put_line('강의실 수정에 성공하셨습니다.');
    else
        dbms_output.put_line('강의실 수정에 실패하였습니다.');
    end if;
end;
--******************************************************************************



-- 4. 교재 삭제하기 프로시저
create or replace procedure proctbltextbookde (
    pnum number,
    presult out number
)
is
begin
    delete tbltextbook where txtbook_seq = pnum;
exception
    when others then
        presult := 0;
end proctbltextbookde;


--******************************************************************************
declare
    vresult number;
begin
    proctbltextbookde(151, vresult);
    if vresult = 1 then
        dbms_output.put_line('교재 삭제에 성공하셨습니다.');
    else
        dbms_output.put_line('교재 삭제에 실패하셨습니다.');
    end if;
end;
--******************************************************************************