/*
数据规范
1. 入场SQL  主要是create
2. 查询SQL
3. 清场SQL  主要是drop
  - 存储过程等
  - 视图表
  - 表示关联关系的表
  - 普通表
*/
SHOW TABLES;
SHOW DATABASES;
USE tmp;

CREATE TABLE task(
  id INT,
  name VARCHAR(150)
) COMMENT '任务表';
INSERT INTO task VALUES (1,'薪水普查');
INSERT INTO task VALUES (2,'环保调研');
INSERT INTO task VALUES (3,'污水治理');
INSERT INTO task VALUES (4,'4个现代化建设');

CREATE TABLE dept(
  id int,
  name VARCHAR(150)
) COMMENT '单位表';
INSERT INTO dept VALUES (1,'聊城'),(2,'德州'),(3,'滨州'),(4,'济南'),(5,'淄博'),(6,'莱芜'),(7,'泰安'),(8,'菏泽');

CREATE TABLE dept_task(
  dept_id int,
  task_id INT
)COMMENT '单位任务表';
INSERT INTO dept_task VALUES (1,1),(1,2),(1,3),(2,1),(2,3),(3,1),(3,3),(4,4),(4,2),(5,3),(5,2),(6,2),(7,2);

-- 查询每个市的任务
SELECT
  dp.name,
  group_concat(tk.name)
FROM dept_task dt
  JOIN dept dp ON dt.dept_id = dp.id
  JOIN task tk ON dt.task_id = tk.id
GROUP BY dp.name;

-- 查询每个任务，都有哪些市要完成
SELECT tk.name,dp.name
FROM dept_task dt
  JOIN dept dp ON dt.dept_id = dp.id
  JOIN task tk ON dt.task_id = tk.id
ORDER BY tk.id,dp.id;

-- 查询每个城市和自己相关的任务
SELECT tk.name
FROM dept_task dt
  JOIN dept dp ON dt.dept_id = dp.id
  JOIN task tk ON dt.task_id = tk.id
WHERE dp.id = 1;

-- 清场
DROP TABLE  IF EXISTS dept_task;
DROP TABLE  IF EXISTS dept;
DROP TABLE  IF EXISTS dept;