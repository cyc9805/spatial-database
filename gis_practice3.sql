--시군구 테이블
--shp 파일을 테이블로 변환하면, gid 라는 기본키가 자동으로 생성
select adm_sect_c, ST_Transform(geom, 4326) from adm_sgg limit 2;

select ST_Transform(geom, 4326) from public_bicycle
-- 전체 데이터 카운트 
select count(*) from adm_sgg

-- 11215 검색
--텍스트의 경우, 입력/검색 '' 적용
select * from adm_sgg where adm_sect_c='11215'
select *, ST_Transform(geom,4326) from adm_sgg where adm_sect_c='11215'

-- 데이터 삭제
-- delete from 테이블 where 조건
delete from adm_sgg where gid=2

-- 읍면동 테이블
-- 동 코드, 동 이름, 시군구 코드, 동 geometry
-- 구와 동의 관계(기본키-외래키), 외래키 컬럼: col_adm_se
select *, ST_Transform(geom, 4326) from adm_umd limit 2
select count(*) from adm_umd

-- 조인
-- 구-동 테이블을 조인(467)
-- 구 기준: adm_sect_c, 동 기준: col_adm_se
-- select 컬럼들 from 테이블 a join 테이블 b on a.컬럼=b.컬럼
select *, ST_Transform(b.geom, 4326)
from adm_sgg as a
join adm_umd as b
on a.adm_sect_c = b.col_adm_se
order by sgg_nm

--집계구 테이블
-- 기준일, 집계구 코드
select *, ST_Transform(geom,4326) from bnd_oa limit 10

-- 집계구의 총인구 테이블
select * from bnd_oa_pop limit 10


-- 집계구 경계 및 인구 조인
select *, ST_Transform(x.geom,4326) 
from bnd_oa as x
join bnd_oa_pop as y
on x.tot_reg_cd = y.tot_oa_cd
limit 5



-- 전농동의 인구 

-- 공간 조인(spatial join) 

-- select 컬럼(들), 함수 from 테이블 a join 테이블 b on 공간 조인 함수 

-- ST_Intersects(geom a, geom b) -> a와 b가 접해있으면 return(true) 

 

select *, ST_Transform(x.geom, 4326), ST_Transform(z.geom, 4326) 

from bnd_oa as x 

join bnd_oa_pop as y 

on x.tot_reg_cd = y.tot_oa_cd -- 속성조인 

join adm_umd as z 

on ST_Intersects(x.geom, z.geom) -- 공간조인 

where z.emd_nm = '전농동' 

 

-- 집계함수 

-- sum: 컬럼의 합 구하기 

select sum(pop) 

from bnd_oa as x 

join bnd_oa_pop as y 

on x.tot_reg_cd = y.tot_oa_cd 

join adm_umd as z 

on ST_Intersects(x.geom, z.geom) 

where z.emd_nm = '전농동' 

 

 

-- ST_Centroid(geometry) 입력된 도형의 중심점 계산 

-- ST_Within(geom a, geom b) a가 b에 완벽히 포함되어 있으면 return 

select *, ST_Transform(x.geom, 4326), ST_Transform(z.geom, 4326) 

from bnd_oa as x 

join bnd_oa_pop as y 

on x.tot_reg_cd = y.tot_oa_cd -- 속성조인 

join adm_umd as z 

on ST_Within(ST_Centroid(x.geom), z.geom) -- 공간조인 

where z.emd_nm = '전농동' 

 

select sum(pop) 

from bnd_oa as x 

join bnd_oa_pop as y 

on x.tot_reg_cd = y.tot_oa_cd -- 속성조인 

join adm_umd as z 

on ST_Within(ST_Centroid(x.geom), z.geom) -- 공간조인 

where z.emd_nm = '전농동' 

select distinct y.emd_nm
from moct_link as x
join adm_umd as y
on st_intersects(x.geom, st_transform(y.geom, 5186))
where x.road_name = '강변북로'

select * from bnd_oa_pop as x join bnd_oa as y on x.tot_oa_cd=y.tot_reg_cd



select * from bus_stop

select z.name, z.geom
from (select *,st_transform(lv.geom,4326) as geom2 from land_value as lv
order by a9
desc limit 100) as x
join building as y 
on st_intersects(x.geom2, st_transform(y.geom, 4326))
join bus_stop as z
on st_within(x.geom2, st_transform(st_buffer(st_transform(y.geom, 5174),500),4326))
