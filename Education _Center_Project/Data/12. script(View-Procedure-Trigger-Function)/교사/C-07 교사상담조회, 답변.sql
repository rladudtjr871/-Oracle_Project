--C_07교사상담조회, 



-- C_07_01 교사가 진행중인(진행한) 과정에 대한 학생들의 질문과 답변 볼 수 있다.
create or replace procedure procTeacherConsult(
    pteachereq number -- 교사번호 입력 
)
is
  
    vsubname         tblSubjectName.subname%type;
    vcourse          tblCourseName.course_neme%type;
    vconsult         tblConsult.consult_txt%type;
    vanswer          tblAnswer.answer_txt%type;
    vteacher         tblTeacher.t_name%type;
    vconseq          number;
    
    cursor vcursor 
    is
    select 
        sj.subname ,
        cn.course_neme,
        c.consult_txt,
        a.answer_txt,
        t.t_name,
        c.consult_seq
        
    from tblConsult c
        left outer join tblAnswer a on c.consult_seq = a.consult_seq 
            left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
                left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                    left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                        left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                            left outer join tblCourse cr on cs.course_seq = cr.course_seq
                                left outer join tblCourseName cn on cr.cname_seq = cn.cname_seq
                 where cr.course_seq in (select crs.course_seq from tblCourse crs where crs.teacher_seq = pteachereq); --번호 입력

begin 

    dbms_output.put_line(rpad('질문번호', 4, ' ') || '| ' || 
                                rpad('과목명', 10, ' ') || '| ' || 
                                rpad('과정명', 20, ' ') || '| ' || 
                                rpad('상담내용', 40, ' ') || '    | ' || 
                                rpad('답변', 40, ' '));
    dbms_output.put_line('=============================================================================================================');
    dbms_output.put_line(' ');
    
    open vcursor;
    loop
             
        fetch vcursor into vsubname, vcourse, vconsult, vanswer, vteacher, vconseq;
        exit when vcursor%notFound;
        
         if
            length(vanswer) > 0 
        then vanswer := vanswer;        
        else
            vanswer := 'null';
            vteacher := 'null';
                
        end if;
            
        dbms_output.put_line(rpad(vconseq, 4, ' ') || '| ' || 
                                rpad(vsubname, 10, ' ') || '| ' || 
                                rpad(vcourse, 20, ' ') || '| ' || 
                                rpad(vconsult, 40, ' ') || '... | ' || 
                                rpad(vanswer, 40, ' ') || '... | '); 
        dbms_output.put_line(' ');
    
    end loop;
    close vcursor;

end procTeacherConsult;
/






--------- 실행

begin
    procTeacherConsult(8);
end;
/


begin
    procTeacherConsult(9);  -- 질문이 있고 답변 없는것도 표시됨 
end;
/



----------------------------------------------------------
-- C_07_02 답변 없는 상담내용에 대해 답변 입력하기

create or replace procedure procWriteAnswer(
    
    pteachereq number, -- 교사번호 입력 
    pconsultseq number,  -- 질문번호
    panswer tblAnswer.answer_txt%type -- 답변내용
)
is
begin
    
    insert into tblAnswer (answer_seq, answer_txt, teacher_seq,  consult_seq ) 
        values(	(select max(answer_seq) from tblAnswer)+1,  panswer, pteachereq, pconsultseq);
        
    dbms_output.put_line('답변 입력 완료');
    
    exception
        when others then
    dbms_output.put_line('오류발생!!');
    
end procWriteAnswer;
/




-- 실행
begin
    procWriteAnswer(9, 101, '새롭게 입력한 답변');
end;
/

-- 확인
begin
    procTeacherConsult(9); 
end;
/

