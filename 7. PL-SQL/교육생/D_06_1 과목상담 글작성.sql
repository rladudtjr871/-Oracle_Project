-- D08_과목상담 글작성
--------------------------------------------------------------------------------
-- 1. 상담 등록
--------------------------------------------------------------------------------

create or replace procedure procWriteConsult(
    psugang_num     tblsugang.sugang_seq%type,
    psubname        tblSubjectName.subname%type,
    pconsult        tblConsult.consult_txt%type
)
is
    vcsub_seq number;       -- 과목번호
begin
    select  
        cs.csub_seq         -- 개설과정과목번호
    
    into
        vcsub_seq
        
    from tblCourse c
        inner join tblSugang s 
            on c.course_seq = s.course_seq 
                inner join tblCSub cs 
                    on c.course_seq = cs.course_seq
                        inner join tblSubjectName sn 
                            on cs.subname_seq = sn.subname_seq
                
    where s.sugang_seq = psugang_num and sn.subname = psubname;
                    
    
    insert into tblConsult (consult_seq, consult_txt, csub_seq, sugang_seq) 
        values((select max(consult_seq)+1 from tblConsult), pconsult, vcsub_seq, psugang_num);	

    dbms_output.put_line('작성완료');
    
    procMyConsult(psugang_num);

    
    exception 
    when others then 
        dbms_output.put_line('작성실패');

               
end procWriteConsult; 
/
--------------------------------------------------------------------------------

begin
    procWriteConsult(197, 'Java', '새로운상담질문입니다!!!');
end;
/

--------------------------------------------------------------------------------

select * from tblConsult where sugang_seq = 197;

rollback;

--------------------------------------------------------------------------------