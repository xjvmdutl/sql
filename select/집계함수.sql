select avg(salary),sum(salary)-- 집계함수들은 올수 있다, 다만 1행만 나오기 떄문에 다른 컬럼이 오면 안된다 
							  -- mysql은 에러가 나지 않는다(주의)
from salaries
where emp_no='10060';-- 해당 조건을 만족하는 튜플만 조건 집계함수적용
select avg(salary) as avg_salary,sum(salary),emp_no-- group by에 참여하는 값만이 올 있다
from salaries
where to_date='9999-01-01' -- and avg(salary) >40000 -- where절에는 집계함수가 올수 없다=>결과를 집계한뒤에 사용할수 있기 떄문
group by emp_no
having avg(salary) > 40000 -- 따라서 having절에서 조건을 주는 것이다.
order by avg_salary asc; 
-- order by avg(salary) asc;-- 집계가 다 끝난 테이블을 가지고 정렬 해야한다.
-- 집계를 2번 하는 것이 아니라 이름이다. --~~별로라는 말이 나오면 group by 생각해야 한다.
-- 각 사원별로 평균연봉 출력
select emp_no,avg(salary)
from salaries
group by emp_no
order by avg(salary) desc;
-- 각 현재 Manager 직책 사원에 대한 평균 연봉은? [과제] join이 필요하기 떄문에 현재 못함
select avg(a.salary)
from salaries a,titles b
where a.emp_no = b.emp_no -- 조인 조건(1)
	and a.to_date='9999-01-01' -- row 선택조건1,현재 직원
    and b.to_date='9999-01-01'-- row 선택조건2,현재 직원
    and b.title='Manager'; -- row 선택조건3, 직책이 Manager
-- 현재 직책별 사원에 대한 평균 연봉은? [과제] join이 필요하기 떄문에 현재 못함
select b.title,avg(a.salary) as '평균 연봉' -- 직책별 연봉
from salaries a,titles b
where a.emp_no = b.emp_no -- 조인 조건(1)
	and a.to_date='9999-01-01' -- row 선택조건1,현재 직원
    and b.to_date='9999-01-01'-- row 선택조건2,현재 직원
group by b.title
order by avg(a.salary) desc;

-- 사원별 몇 번의 직책 변경이 있었는지 조회
select emp_no,count(*) 
from titles
group by emp_no
order by count(*) desc; -- 가장 많이 바뀐놈이 위로
select * from titles where emp_no =438918;

-- 각 사원별로 평균연봉 출력하되 50,000불 이상인 직원만 출력
select avg(salary),emp_no 
from salaries
group by emp_no
having avg(salary)>50000
order by avg(salary);

-- [과제]현재 직책별로 평균 연봉과 인원수를 구하되 직책별로 인원이 100명 이상인 직책만 출력하세요.=>join
select c.title as 직책,avg(a.salary) as 평균연봉,count(b.emp_no) as 인원수
from salaries a, employees b,titles c
where a.emp_no = b.emp_no
	and b.emp_no = c.emp_no
    and c.to_date = '9999-01-01'
group by c.title
having count(b.emp_no) >= 100
order by count(b.emp_no) desc;
-- [과제]현재 부서별로 현재 직책이 Engineer인 직원들에 대해서만 평균급여를 구하세요.
select avg(c.salary) as 평균급여, d.dept_name as 부서
from titles a, dept_emp b,salaries c, departments d
where a.emp_no = b.emp_no
	and b.emp_no = c.emp_no
    and d.dept_no = b.dept_no
    and a.to_date='9999-01-01'
    and b.to_date='9999-01-01'
    and a.title = 'Engineer'
group by d.dept_name
order by avg(c.salary) desc;
-- [과제]현재 직책별로 급여의 총합을 구하되 Engineer직책은 제외하세요 
-- 단, 총합이 2,000,000,000이상인 직책만 나타내며 급여총합에 대해서 내림차순(DESC)로 정렬하세요.
select a.title, sum(b.salary)
from titles a, salaries b
where a.emp_no = b.emp_no -- full-scan, n-1개의 조인 조건이 있어야 한다.
	and a.to_date = '9999-01-01'
    and b.to_date = '9999-01-01'
    and a.title != 'Engineer'
group by a.title
having sum(b.salary) > 2000000000
order by sum(b.salary) desc;
