--D_08_3 과목상담내역조회

create or replace procedure procSubConsult(
    psubname tblSubjectName.subname%type
)
is
    vsubname         tblSubjectName.subname%type;
    vcourse          tblCourseName.course_neme%type;
    vconsult         tblConsult.consult_txt%type;
    vanswer          tblAnswer.answer_txt%type;
    vteacher         tblTeacher.t_name%type;
    
    cursor vcursor 
    is
    select 
        sj.subname ,
        cn.course_neme,
        c.consult_txt,
        a.answer_txt,
        t.t_name 
        
    from tblConsult c
        left outer join tblAnswer a on c.consult_seq = a.consult_seq 
            left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
                left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                    left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                        left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                            left outer join tblCourse cr on cs.course_seq = cr.course_seq
                                left outer join tblCourseName cn on cr.cname_seq = cn.cname_seq
                 where sj.subname = psubname; --번호 입력
        

begin 

    dbms_output.put_line(rpad('과목명', 10, ' ') || '| ' || 
                                rpad('과정명', 20, ' ') || '| ' || 
                                rpad('상담내용', 40, ' ') || '    | ' || 
                                rpad('답변', 40, ' ') || '    | ' || '강사명');
    dbms_output.put_line('=============================================================================================================');
    dbms_output.put_line(' ');
    
    open vcursor;
    loop
             
        fetch vcursor into vsubname, vcourse, vconsult, vanswer, vteacher;
        exit when vcursor%notFound;
        
         if
            length(vteacher) > 0 
        then vanswer := vanswer;        
        else
            vanswer := 'null';
            vteacher := 'null';
                
        end if;
            
        dbms_output.put_line(rpad(vsubname, 10, ' ') || '| ' || 
                                rpad(vcourse, 20, ' ') || '| ' || 
                                rpad(vconsult, 40, ' ') || '... | ' || 
                                rpad(vanswer, 40, ' ') || '... | ' || vteacher); 
        dbms_output.put_line(' ');
    
    end loop;
    close vcursor;

end procSubConsult;
/


--실행
begin
    procSubConsult('Java');
end;
/




