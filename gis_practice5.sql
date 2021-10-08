-- 서울시에서 가장 비싼 땅(개별공시지가)
select ST_Transform(geom,4326), a9, a2, a0 from land_value 
order by a9 desc limit 100

-- 가장 비싼 땅 위에 올라간 건물들
select ST_Transform(x.geom, 4326), x.a12, ST_Transform(y.geom, 4326)
from building as x
join (
select geom, a9, a2, a0 from land_value 
order by a9 desc limit 50) as y
on ST_Intersects(x.geom, y.geom)

-- ST_SRID: 좌표계 검색
select ST_SRID(geom) from adm_sgg limit 1 --5174
select ST_SRID(geom) from land_value limit 10 --5174

-- 강남구에서 가장 비싼 땅
select * from land_value as x
join
(select * from adm_sgg where sgg_nm='강남구') as y
on ST_Intersects(ST_transform(x.geom,4326), ST_transform(y.geom,4326))

-- ST_Buffer, 좌표계의 길이(거리) 단위에 유의! 
-- id가 1001인 버스 정류장 주변 500m 이내에 위치하는 따릉이 대여소 
select y.* 
from (select * from bus_stop where id='1001') as x 
join public_bicycle as y 
on ST_Within(y.geom,   
 ST_Transform( 
 ST_Buffer(ST_Transform(x.geom, 5174), 500),4326))  
 
 