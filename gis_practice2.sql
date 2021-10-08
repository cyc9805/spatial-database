--집계구 경계 데이터 보기
select *, ST_Transform(geom, 4326) from bnd_oa

select * from adm_sgg
select * from adm_umd
select * from moct_node
select * from moct_link
select * from land_value
select * from building

--ST_Transform(도형 컬럼, 변환하고자 하는 좌표계ID)
--5179 좌표계로 구축된 데이터를 4326 좌표계로 변경해서 별도의 컬럼으로 표현
--5179: 구 지리원 TM 중부원점(우리나라) 좌표계
--4326: wgs84 (국제적으로 사용되는)
--도형 컬럼의 표기(WKB , WKT)
--st_text: st_makepoint(-70,40)
select st_astext(st_makepoint(40,50))
select 
ST_Astext(geom), 
ST_Transform(geom, 4326), 
ST_AsText(ST_Transform(geom, 4326)) --4326 으로 변환한후 wkb 에서 wkt 로 바꾸는 구문
from bnd_oa limit 10;

select 
St_astext(geom),
st_transform(geom, 4326),
st_astext(st_transform(geom, 4326))
from bnd_oa limit 1;
select * from dem;

-- raster 타입의 컬럼
-- 하나의 타입이 하나의 투플(데이터 row)
select count(*) from dem

-- 버스 정류장 테이블 생성 
CREATE TABLE bus_stop (
id varchar(10), name varchar(50), x numeric,
y numeric
);


select * from bus_stop

--geometry 컬럼 생성
alter table bus_stop add column geom geometry

--경위도 좌표 컬럼을 이용하여 포인트 데이터 생성 
update bus_stop
set geom = ST_SetSRID(ST_MakePoint(x, y), 4326);

--ST_MakePoint(x,y): x,y 컬럼을 이용하여 포인트 데이터 생성
--ST_SetSRID(geom, 좌표계id): 도형 데이터의 좌표계 정의

-- 공공자전거 대여소 테이블 생성
CREATE TABLE public_bicycle
(
id integer,
name varchar(50), sgg varchar(10), address varchar(100), y numeric,
x numeric, date date,
capa_lcd integer,
capa_qr integer );

select * from public_bicycle
alter table public_bicycle add column geom geometry; 
update public_bicycle
set geom = ST_SetSRID(ST_MakePoint(x, y), 4326);

-- 집계구 인구 테이블 생성 
CREATE TABLE bnd_oa_pop 
(
base_year integer,
tot_oa_cd varchar(100), 
item varchar(20),
pop numeric
);

select * from bnd_oa_pop