-- 동대문구에 위치한 따릉이 대여소 데이터를 검색하시오.

-- 속성을 이용한 필터링
select * from public_bicycle where sgg='동대문구'

-- 공간조인
-- 두 데이터의 좌표계가 달라, 중첩 연산이 불가능
select * from public_bicycle as x
join adm_sgg as y
on ST_Within(x.geom, y.geom)

-- 좌표계 통일 후, 중첩 연산 수행
-- ST_Transform(geometry g1, integer srid): 좌표변환
select x.geom from public_bicycle as x
join adm_umd as y
on ST_Within(x.geom, ST_Transform(y.geom,4326))
where y.emd_nm = '휘경동'

