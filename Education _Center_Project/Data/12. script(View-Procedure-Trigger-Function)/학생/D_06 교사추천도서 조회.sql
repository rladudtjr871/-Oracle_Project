--D_06 교사추천도서 조회 

--교사이름 입력하면 추천도서 조회 가능
create or replace procedure procTecherRecBook(

    pt_name tblTeacher.t_name%type
)
is
    vbookname   tblTeachRec.rec_name%type;
    vpname      tblPublisher.name%type;
    vtname      tblTeacher.t_name%type;
    vsubname    tblSubjectName.subname%type;
    vcname      tblCourseName.course_neme%type;

    cursor vcursor
    is
    select distinct
        
        tr.rec_name, -- 책제목,
        p.name, -- 출판사,
        t.t_name, -- 교사명,
        sn.subname, -- 과목명,
        cn.course_neme -- 과정명
        
    from tblTeachRec tr
        inner join tblTeacher t on tr.teacher_seq = t.teacher_seq 
            inner join tblPublisher p on tr.publisher_seq = p.publisher_seq
                inner join tblCourse c on t.teacher_seq = c.teacher_seq
                    inner join tblCourseName cn on c.cname_seq = cn.cname_seq
                        inner join tblSubjectName sn on tr.subname_seq = sn.subname_seq
    
    where t.t_name = pt_name order by cn.course_neme, sn.subname; --교사이름 입력
      

begin

    dbms_output.put_line(rpad('교사명', 8, ' ') || ' | ' || 
                        rpad('과정명', 15, ' ') || ' | ' || 
                        rpad('과목명', 7, ' ') || ' | ' || 
                        rpad('추천도서명', 30, ' ') || ' | ' ||
                        '출판사');
    
    dbms_output.put_line('===============================================================================================');
    
    open vcursor;
    loop
        fetch vcursor into vbookname, vpname, vtname, vsubname, vcname;
        exit when vcursor%notfound;
        
        dbms_output.put_line(' ');
        dbms_output.put_line(rpad(vtname, 8, ' ') || ' | ' || 
                    rpad(vcname, 15, ' ') || ' | ' || 
                    rpad(vsubname, 7, ' ') || ' | ' || 
                    rpad(vbookname, 30, ' ') || ' | ' ||
                    vpname);
        
    end loop;
    close vcursor;
end procTecherRecBook;
/


begin
    procTecherRecBook('송유주');
end;
/




---------------------------------------------------------------------------------------------------------

--2. 과목별로 추천도서 조회하기

create or replace procedure procSubRecBook (
    psubname tblSubjectName.subname%type
)
is
    vbookname   tblTeachRec.rec_name%type;
    vpname      tblPublisher.name%type;
    vtname      tblTeacher.t_name%type;
    vsubname    tblSubjectName.subname%type;
    vcname      tblCourseName.course_neme%type;


    cursor vcursor
    is
    select distinct
        
        tr.rec_name, -- 책제목,
        p.name, -- 출판사,
        t.t_name, -- 교사명,
        sn.subname, -- 과목명,
        cn.course_neme -- 과정명
        
    from tblTeachRec tr
        inner join tblTeacher t on tr.teacher_seq = t.teacher_seq 
            inner join tblPublisher p on tr.publisher_seq = p.publisher_seq
                inner join tblCourse c on t.teacher_seq = c.teacher_seq
                    inner join tblCourseName cn on c.cname_seq = cn.cname_seq
                        inner join tblSubjectName sn on tr.subname_seq = sn.subname_seq
    
    where sn.subname = psubname order by cn.course_neme, sn.subname; --교사이름 입력
      
begin

    dbms_output.put_line(
                        rpad('과목명', 7, ' ') || ' | ' ||
                        rpad('교사명', 8, ' ') || ' | ' || 
                        rpad('과정명', 15, ' ') || ' | ' || 
                        rpad('추천도서명', 30, ' ') || ' | ' ||
                        '출판사');
    
    dbms_output.put_line('===============================================================================================');
    
    open vcursor;
    loop
        fetch vcursor into vbookname, vpname, vtname, vsubname, vcname;
        exit when vcursor%notfound;
        
        dbms_output.put_line(' ');
        dbms_output.put_line( 
                    rpad(vsubname, 7, ' ') || ' | ' ||
                    rpad(vtname, 8, ' ') || ' | ' ||
                    rpad(vcname, 15, ' ') || ' | ' || 
                    rpad(vbookname, 30, ' ') || ' | ' ||
                    vpname);
        
    end loop;
    close vcursor;
end procSubRecBook;
/


--실행
begin
    procSubRecBook('Oracle');
end;
/














