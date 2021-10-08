-- 래스터 
-- DEM(DTM, DSM) 
-- DEM(DTM): 지형의 표고 
-- DSM: 건물, 산림의 높이 등 지형 위에 존재하는 지물들의 높이도 고려된 데이터 

select * from dem 

-- 하나의 row는 하나의 타일을 의미, 본 예제에서는 100 * 100 cells 
-- 래스터와 폴리곤의 조인 
-- 예시) 동대문구의 표고에 대한 기술통계 
-- 기술통계: 데이터의 요약 -> 평균, 범위, 최대/최대/최빈 

-- 1. 좌표계 체크 ST_SRID 

select ST_SRID(rast) from dem limit 1 -- 5186 
select ST_SRID(geom) from adm_sgg limit 1 -- 5179 

 

-- 2. 래스터를 주어진 폴리곤 영역으로 자르기 
-- 공통된 영역의 속성을 추출할 때 -> 공간조인(예시. ST_Intersects) 
-- select A.a, B.b from A join B 
-- on 공간함수(A.geom, B.geom) 
-- 여기서 공간함수의 출력 데이터 타입은? Boolean 

 
-- Boolean 결과를 출력하지 않는 공간함수를 이용한 연산 
-- select 공간함수(A.geom, B.geom) 
-- from A, B 

 

-- DEM 래스터를 동대문구 영역만큼 Clip하기 

-- ST_Clip(raster rast, geometry geom): raster를 geometry 영역만큼 추출 

select ST_Clip(x.rast, ST_Transform(y.geom, 5186)) 

from dem as x, (select * from adm_sgg where sgg_nm='동대문구') as y 



-- ST_Union: 공간 데이터의 병합 

select ST_Union(ST_Clip(x.rast, ST_Transform(y.geom, 5186))) 
from dem as x, (select * from adm_sgg where sgg_nm='동대문구') as y 

 

-- ST_Polygon: 래스터의 폴리곤화 

select ST_Polygon(ST_Union(ST_Clip(x.rast, ST_Transform(y.geom, 5186))))

from dem as x, (select * from adm_sgg where sgg_nm='동대문구') as y 

 

select ST_Transform(geom,4326) from adm_sgg where sgg_nm='동대문구' 

 

-- 3. 래스터의 각 셀 값에 대한 기술통계(데이터 요약) 

-- ST_SummaryStats(rast) 

-- Returns summarystats consisting of count, sum, mean, stddev, min, max for a given raster band of a raster or raster coverage. 

select (summary).*  
from 
(select ST_SummaryStats(ST_Union(ST_Clip(x.rast, ST_Transform(y.geom, 5186)))) as summary 
from dem as x, (select * from adm_sgg where sgg_nm='동대문구') as y) as result 
 

select (summary).*, map  
from 
(select  
  ST_SummaryStats(ST_Union(ST_Clip(x.rast, ST_Transform(y.geom, 5186)))) as summary, 
  ST_Union(ST_Transform(y.geom, 4326)) as map 
from dem as x, (select * from adm_sgg where sgg_nm='용산구') as y) as result 

