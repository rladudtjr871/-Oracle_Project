--D_01_3 과목별 시험일자 조회(PL)


create or replace procedure procSubTestdate(
    psugang_num number
)
is
    vsubname    tblSubjectName.subname%type;
    vtestdate   tblTestDate.test_date%type;
    
    cursor vcursor
    is
    select 
        sn.subname,
        td.test_date 
 
    from tblSugang s
        inner join tblCourse c on s.course_seq = c.course_seq --과정
            inner join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
                left outer join tblTestDate td on cs.csub_seq = td.csub_seq -- 과목별 시험 
                    inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                            
        where s.sugang_seq = psugang_num 
            and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = psugang_num) 
                order by td.test_date ;

begin
    
    dbms_output.put_line('과목명 |   시험일자');
    dbms_output.put_line('====================');
    
    open vcursor;
    loop
    
        fetch  vcursor into vsubname, vtestdate;
        exit when vcursor%notfound;
        
        dbms_output.put_line(rpad(vsubname, 7, ' ') ||'|  ' || vtestdate);
    
    
    end loop;
    close vcursor;
end;
/


--------------------

begin
    procSubTestdate(180);
end;
/