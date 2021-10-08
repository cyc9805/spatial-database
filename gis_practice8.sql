-- Substring 

-- group by, union 

-- Intersection null, empty geometry 

 

 

 

-- geometry ST_ClosestPoint(geometry g1, geometry g2); 

-- Returns the 2-dimensional point on g1 that is closest to g2. This is the first point of the shortest line. 

 

select *, ST_SRID(geom) from bus_stop limit 1 -- 4326 

select count(*) from bus_stop -- 11280 

select *, ST_SRID(geom) from public_bicycle limit 1 --4326 

select count(*) from public_bicycle -- 2082 

 

-- 각 버스 정류장으로부터 가장 가까운 따릉이 대여소 찾기 

-- 1번 버스 정류장 - 12번 따릉이 대여소 

-- 11280  

-- 2082 

select x.id, ST_ClosestPoint(y.geom, x.geom) 

from  

bus_stop as x,  

(select ST_Union(geom) as geom from public_bicycle) as y 

 

select right(a6, 1) from land_value limit 1 

-- 필지, a6 컬럼의 끝 텍스트 -> 지목 

select * from land_value limit 100 

 

-- 서울 필지의 지목별 필지 수를 계산하시오. 

select right(a6, 1) as "지목", count(*) 

from land_value 

group by right(a6, 1) 

order by count(*) desc 

 

-- ST_Intersects: T/F, 두 데이터가 접해있다면 T 

-- ST_Intersection  

-- geography ST_Intersection( geography geogA , geography geogB ); 

-- Returns a geometry representing the point-set intersection of two geometries. In other words, that portion of geometry A and geometry B that is shared between the two geometries. 

-- If the geometries do not share any space (are disjoint), then an empty geometry collection is returned. 

 

select * from bus_stop limit 1 

select *, ST_SRID(geom) from adm_umd limit 1 --5179 

 

-- 버스 정류장 버퍼 500 지역으로 인터센션하기 

select count(*) from ( 

select y.geom, y.emd_nm 

from (select * from bus_stop limit 1) as x 

join adm_umd as y 

on ST_Intersects(ST_Buffer(ST_Transform(x.geom, 5179), 500), y.geom) 

) as r1 

 

select count(*) from ( 

select y.emd_nm, ST_Intersection(ST_Transform(x.geom, 5179), y.geom) 

from 

(select * from bus_stop limit 1) as x, adm_umd as y) as r1 

 

select count(*) from adm_umd 

 

 

 

select y.emd_nm, ST_Intersection(ST_Buffer(ST_Transform(x.geom, 5179), 500), y.geom) 

from 

(select * from bus_stop limit 1) as x, adm_umd as y 

where ST_IsEmpty(ST_Intersection(ST_Buffer(ST_Transform(x.geom, 5179), 500), y.geom)) = 'f' 