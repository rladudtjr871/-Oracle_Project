-- 과목상담이 서브쿼리 안되는 이유

-- psubname

-- csub_seq

-- select subname_seq from tblSubjectName where subname = 'Java'

select csub_seq from tblConsult where csub_seq = (select csub_seq from tblCsub where subname_seq = 3);


select csub_seq from tblConsult where csub_seq = 1;