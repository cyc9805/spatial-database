--포인트, 좌표계
--9 인터섹션 매트릭스(모델)

-- ST_SRID(geometry): 주어진 geometry 좌표계 확인
-- ST_Buffer(geometry, distance): 주어진 geometry 의 좌표계 유의, 거리 유닛 고려
select ST_SRID(geom) from bus_stop limit 1
select ST_Buffer(geom,10) from bus_stop limit 1
select ST_Transfrom(ST_Buffer(ST_Transform(geom,5184)),10),4326) from bus_stop limit 1

-- 공간 인덱스
-- 공간 인덱스를 통해 처리 시간 감소
select * from land_value as x
join (select ST_Buffer(ST_transform(
	ST_setSRID(ST_makepoint(127, 37.5),4326),5174),500) as geom) as y
on ST_intersects(x.geom,y.geom)


--2021.03.29
--네트워트 분석, 래스터 활용
--연결성이 고려된 라인 데이터
--현실 도로 --> 점과 선으로 모델링, 그래프의 이론에 기초 G(v,e), 용량, 방향 등이 고려되면 네트워크 
--최단경로 탐색(차량용 내비게이션), 네트워크 버퍼(service area)

-- 링크 데이터 속성들
select link_id, f_node, t_node, ST_Length(geom) from moct_link limit 1
-- 시립대 앞 노드 1050025400
select ST_transform(geom,4326) from moct_node where node_id='1050025400'
-- 시립대 앞 노드로부터 출발되는 링크들
select link_id, f_node, t_node, ST_transform(geom,4326) from moct_link
where f_node='1050025400'


-- 최단경로 탐색 알고리즘 

-- pgr_dijkstra(sql 링크 테이블, int 출발노드, int 도착노드) 

-- 코스트의 합이 최소인 경로를 도출 

-- 링크 테이블 'SELECT id, source, target, cost FROM edge_table' 

-- CAST(x as y): x 컬럼의 데이터 타입을 y 타입으로 바꿈 

 

select  

CAST(link_id as bigint) as id,  

CAST(f_node as bigint) as source,  

CAST(t_node as bigint) as target,  

CAST(ST_Length(geom) as bigint) as cost 

from moct_link 

 

-- 시립대 1050025400 

-- 청량리 1050023700 

-- 서울역 1020034700 

-- 강남역 1210033600 

-- 신도림 1160042800 

 

select * from pgr_dijkstra( 

'select  

CAST(link_id as bigint) as id,  

CAST(f_node as bigint) as source,  

CAST(t_node as bigint) as target,  

CAST(ST_Length(geom) as bigint) as cost 

from moct_link',  

1050025400,  

1050023700) 

 

select y.seq, x.road_name, ST_Transform(x.geom, 4326) 

from moct_link as x 

join 

(select * from pgr_dijkstra( 

'select  

CAST(link_id as bigint) as id,  

CAST(f_node as bigint) as source,  

CAST(t_node as bigint) as target,  

ST_Length(geom) as cost  

from moct_link',  

1050025400,  

1160042800)) as y 

on CAST(x.link_id as bigint) = y.edge 

order by seq 

 

-- 네트워크 버퍼 

-- pgr_drivingDistance(sql 링크 테이블, int 출발노드, distance) 

 
select ST_Transform(x.geom, 4326) 

from moct_link as x 

join 

(select * from pgr_drivingDistance( 

'select  

CAST(link_id as bigint) as id,  

CAST(f_node as bigint) as source,  

CAST(t_node as bigint) as target,  

ST_Length(geom) as cost 

from moct_link',  

1050025400,  

500)) as y 

on CAST(x.link_id as bigint) = y.edge 

 
-- convexhull: 주어진 포인트를 포함하는 가장 작은 다각형

select ST_ConvexHull(ST_Collect(c.geom)) 

from  

(select ST_Transform(x.geom, 4326) as geom  

from moct_node as x 

join ( 

SELECT * FROM pgr_drivingDistance( 

    'SELECT  

CAST(link_id as bigint) as id,  

CAST(f_node as bigint) as source,  

CAST(t_node as bigint) as target,  

ST_Length(geom) as cost  

FROM moct_link', 

    1050025400, 1500 

)) as y 

on CAST(x.node_id as bigint) = y.node) as c 

-- 레스터와 벡터의 조인
-- DEM(DTM): 지형의 높이(표고)
-- DSM: 지물까지 고려한 높이

-- 동대문구의 평균 높이는? 최대 높이는?
select (stats).*
from (
select 
	ST_summaryStats(ST_Clip(x.rast,ST_transform(y.geom, 5186))) as stats, y.geom
from dem as x
join (select * from adm_sgg where sgg_nm='동대문구') as y
on ST_Intersects(x.rast, ST_Transform(y.geom, 5186))) as z

select * 
from dem as x
join (select * from adm_sgg where sgg_nm = '동대문구') as y
on ST_intersects(x.rast, ST_Transform(y.geom, 5186))