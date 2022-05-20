--D_08_2 본인상담내역조회

create or replace procedure procMyConsult(
    psugang_num number

)
is  
    vsubname    tblSubjectName.subname%type;
    vcounsult   tblConsult.consult_txt%type;
    vanswer     tblAnswer.answer_txt%type;
    vtname      tblTeacher.t_name%type;
    
    cursor vcursor
    is
        select 
            sj.subname ,
            c.consult_txt ,
            a.answer_txt ,
            t.t_name
            
        from tblConsult c
            left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
                    left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                        left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                            left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                     where c.sugang_seq = psugang_num; --번호 입력


begin
    
    
    
    open vcursor;
    loop
    
    fetch vcursor into vsubname, vcounsult, vanswer, vtname; 
    exit when vcursor%notfound;
        
        if
            length(vtname) > 0 then vanswer := vanswer;        
        else
            vanswer := 'null';
            vtname := 'null';
            
        end if;
        
    
    
        dbms_output.put_line('=================================================================');
        dbms_output.put_line('과목명 : ' || vsubname);
        dbms_output.put_line('-----------------------------------------------------------------');
        dbms_output.put_line('< 질문 > ' );
        dbms_output.put_line(vcounsult);
        dbms_output.put_line(' ');
        dbms_output.put_line('< 답변 >');
        dbms_output.put_line('교사명 : ' || vtname);
        dbms_output.put_line(vanswer);
        dbms_output.put_line('=================================================================');
        dbms_output.put_line(' ');
        
    end loop;
    close vcursor;
end procMyConsult;
/




-- 실행

begin
    procMyConsult(180);
end;


