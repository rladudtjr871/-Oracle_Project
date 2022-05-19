-- B-12. 관리자 - 협력 기업 관리

-- 협력 기업 등록
insert into tblenterprise (enterprise_seq, ent_name, ent_people, ent_type, ent_sector, ent_recuit) values (51, '테스트기업', 2, '정규직', 'SI', '백엔드/서버개발');

-- 협력 기업 조회
select 
    ent_name as 기업명, 
    ent_people as 구인인원,
    ent_type as 구인형태,
    ent_sector as 업종,
    ent_recuit as 모집부분
from tblenterprise;

-- 협력 기업 수정
update tblenterprise set ent_people = 0 where enterprise_seq = 51;
update tblenterprise set ent_type = '계약직' where enterprise_seq = 51;
update tblenterprise set ent_recuit = '웹개발' where enterprise_seq = 51;

-- 협력 기업 삭제
delete from tblenterprise where enterprise_seq = 51;









