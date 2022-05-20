-- 관리자 _ 과목 상담 관리.sql

-- 특정 과목 상담 내역 조회 view 생성
create or replace procedure procSubConsult(
    psubname tblSubjectName.subname%type
)
is
    vconsult_seq     tblconsult.consult_seq%type;
    vsubname         tblSubjectName.subname%type;
    vcourse          tblCourseName.course_neme%type;
    vconsult         tblConsult.consult_txt%type;
    vm_name          tblmember.m_name%type;
    vanswer          tblAnswer.answer_txt%type;
    vteacher         tblTeacher.t_name%type;
    
    cursor vcursor 
    is
select 
    c.consult_seq,
    sj.subname ,
    cn.course_neme,
    c.consult_txt,
    m.m_name,
    a.answer_txt,
    t.t_name 
from tblConsult c
    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
        left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
            left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
                left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
                    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
                        left outer join tblCourse c on cs.course_seq = c.course_seq
                            left outer join tblCourseName cn on c.cname_seq = cn.cname_seq
                                inner join tblsugang s on c.course_seq = s.course_seq
                                    inner join tblmember m on s.member_seq = m.member_seq 
                 where sj.subname = psubname
                    order by c.course_seq desc; --번호 입력
        

begin 
    dbms_output.put_line('=========================================================================================================================================================================');
    dbms_output.put_line(rpad('상담번호', 12, ' ') || '| ' ||  
                                rpad('과정명', 20, ' ') || '| ' || 
                                rpad('과목명', 10, ' ') || '| ' ||
                                rpad('상담내용', 40, ' ') || '    | ' || 
                                rpad('교육생명', 15, ' ') || '| ' || 
                                rpad('답변', 40, ' ') || '    | ' || '강사명');
    dbms_output.put_line('=========================================================================================================================================================================');
    dbms_output.put_line(' ');
    
    open vcursor;
    loop
             
        fetch vcursor into vconsult_seq, vsubname, vcourse, vconsult, vm_name, vanswer, vteacher;
        exit when vcursor%notFound;
        
         if
            length(vteacher) > 0 then vanswer := vanswer;        
        else
            vanswer := 'null';
            vteacher := 'null';
                
        end if;
            
        dbms_output.put_line(   rpad(vconsult_seq, 12, ' ') || '| ' ||  
                                rpad(vcourse, 20, ' ') || '| ' || 
                                rpad(vsubname, 10, ' ') || '| ' ||
                                rpad(vconsult, 40, ' ') || '... | ' || 
                                rpad(vm_name, 15, ' ') || '| ' || 
                                rpad(vanswer, 40, ' ') || '... | ' || vteacher); 
        
        dbms_output.put_line(' ');
    
    end loop;
    dbms_output.put_line('=========================================================================================================================================================================');
    close vcursor;

end procSubConsult;

--실행
begin
    procSubConsult('Java');
end;



-- 전체 상담 내역 조회 view 생성
create or replace view vwConsult
as
select 
    c.consult_seq,
    sj.subname ,
    cn.course_neme,
    c.consult_txt,
    m.m_name,
    a.answer_txt,
    t.t_name 
from tblConsult c
    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
    left outer join tblCSub cs on c.csub_seq = cs.csub_seq 
    left outer join tblSubjectName sj on cs.subname_seq = sj.subname_seq
    left outer join tblTeacher t on a.teacher_seq = t.teacher_seq
    left outer join tblAnswer a on c.consult_seq = a.consult_seq 
    left outer join tblCourse c on cs.course_seq = c.course_seq
    left outer join tblCourseName cn on c.cname_seq = cn.cname_seq
    inner join tblsugang s on c.course_seq = s.course_seq
    inner join tblmember m on s.member_seq = m.member_seq
        order by c.course_seq desc; 
             
-- 전체 상담 내역 조회 view 출력            
select * from vwconsult;
                
             
             