--D_01_ 성적조회 기능


create or replace procedure procSubScore(
    psugang_num number
)
is
    vsubname tblSubjectName.subname%type;
    vattend_point number;
    vpilgi_point number;
    vsilgi_point number;
    vattend_score number;
    vpilgi_score number;
    vsilgi_score number;
    vtotal_score number;
    
    cursor vcursor 
    is
     select 
        sn.subname , --과목명
        sp.attend_point, --출결배점
        sp.pilgi_point, -- 필기배점
        sp.silgi_point, -- 실기배점
        sc.attend_score, --출결점수
        sc.pilgi_score, -- 필기점수
        sc.silgi_score, -- 실기점수
        sc.silgi_score + sc.pilgi_score + sc.attend_score --총점
        
    from tblSugang s
        inner join tblCourse c on s.course_seq = c.course_seq --과정
             join tblCsub cs on c.course_seq = cs.course_seq --과정내 과목
                    left outer join tblSubjectName sn on cs.subname_seq = sn.subname_seq --과목명
                            left outer join tblSubtPoint sp on cs.csub_seq = sp.csub_seq -- 강좌 배점 
                                left outer join tblScore sc on s.sugang_seq = sc.sugang_seq and cs.csub_seq = sc.csub_seq-- 시험 점수
                                
    where sc.sugang_seq = psugang_num 
        and cs.csend_date < (select max(a.attend_date) from tblAttendance a where a.sugang_seq = psugang_num) 
            order by cs.csub_seq;

    
begin
    
    dbms_output.put_line('과목명      | 출결배점 | 필기배점 | 실기배점 | 출결점수 | 필기점수 | 실기점수 | 총점');
    dbms_output.put_line('============================================================================================');
    
    open vcursor;
    loop
        fetch vcursor into vsubname, vattend_point, vpilgi_point, vsilgi_point, vattend_score, vpilgi_score, vsilgi_score, vtotal_score;
        exit when vcursor%notfound;
        
        dbms_output.put_line('▶' || rpad(vsubname, 8, ' ') ||'   |      '|| 
                            vattend_point ||'  |      '|| 
                            vpilgi_point ||'  |      '|| 
                            vsilgi_point ||'  |      '|| 
                            vattend_score ||'  |      '||
                            vpilgi_score ||'  |      '||
                            vsilgi_score ||'  | '||
                            '총점: ' || vtotal_score || '점');
       
        dbms_output.put_line('');
    
    end loop;
    close vcursor;

end procSubScore;
/


-------------------------------------
--실행

set serverout on;

begin 
    procSubScore(180); 
end;
/







