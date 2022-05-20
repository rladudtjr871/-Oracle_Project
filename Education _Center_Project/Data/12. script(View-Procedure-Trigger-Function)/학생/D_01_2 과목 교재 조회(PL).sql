--D_01.2 과목 교재 조회


create or replace procedure procSubtext(
    psugang_num number
    
)
is
    vsubname    tblSubjectName.subname%type;
    vtitle      tbltextbook.name%type;
    vauthor     tblTextBook.author%type;
    vpublisher  tblPublisher.name%type;
    
    cursor vcursor 
    is
    select 
        sn.subname,
        txt.name,
        txt.author,
        pb.name
    
    from tblSugang s
        inner join tblCourse c on s.course_seq = c.course_seq --과정
            inner join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
                    inner join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                      inner join tblsubjecttxt stx on sn.subname_seq = stx.subname_seq --과목교재
                        inner join tblTextBook txt on stx.txtbook_seq = txt.txtbook_seq -- 교재
                            inner join tblPublisher pb on txt.publisher_seq = pb.publisher_seq -- 출판사
                                
    where s.sugang_seq = psugang_num and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = psugang_num) order by cs.csub_seq ;


begin
    
    dbms_output.put_line('=========<< 추천도서 목록 >>============================================');
    dbms_output.put_line('과목명   | 도서제목                                | 글쓴이      | 출판사 ');
    dbms_output.put_line('========================================================================');

    open vcursor;
    loop       
        fetch vcursor into vsubname, vtitle, vauthor ,vpublisher;
        exit when vcursor%notfound;
        
        dbms_output.put_line(rpad(vsubname, 7, ' ') || '  | ' ||
                               rpad(vtitle, 35, ' ') || '...  | ' ||
                               rpad(vauthor, 10, ' ') || '  | ' ||
                               vpublisher);
        dbms_output.put_line('');
    
    
    end loop;
    close vcursor;
    
end procSubtext;
/



set serverout on;
-- 실행

begin
    procSubtext(180);
end;



