-- B-01 관리자 계정 로그인.sql

-- 관리자 로그인
    select * from tblAdmin;
    select count(*) as cnt from tblAdmin where id = 'admin1' and password = 2503;