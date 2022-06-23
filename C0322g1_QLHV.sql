
create table test(
testid int not null primary key,
Subtestname varchar(60)
);

create table student(
RN int not null primary key,
Name varchar(50) not null,
Age int(4)
);

create table studenttest(
testid int, foreign key (testid) references test(testid),
RN int, foreign key (RN) references student(RN),
Date datetime,
mark float,
primary key(testid,RN)
);

insert into test value(1,'EPC'),(2,'DWMX'),(3,'SQL1'),(4,'SQL2');

insert into student value(1,'Nguyen Hong Ha',20),(2,'Truong Ngoc Anh',30),
(3,'Tuan Minh',25),(4,'Dan Truong',22);

insert into studenttest value(1,1,'2006-07-17',8),(1,2,'2006-07-18',5),(1,3,'2006-07-19',7),
(2,1,'2006-07-17',7),(2,2,'2006-07-18',4),(2,3,'2006-07-19',2),(3,1,'2006-07-17',10)
,(3,3,'2006-07-19',1);

-- câu 2:
create view allStudent as
select student.name as 'Student Name', test.Subtestname as 'Test Name', studenttest.mark, studenttest.date
from student join studenttest on studenttest.RN = student.RN 
			 join test on test.testid = studenttest.testid;
             
-- Câu 3:
select * 
from student 
where not exists (select * from studenttest where studenttest.RN = student.RN);

select student.*
from student left join studenttest on studenttest.RN = student.RN 
where mark is null;

-- Câu 4:
select *
from allStudent
where mark < 5;

-- Câu 5:
select student.name as 'Student Name', avg(mark) as 'Điểm Trung Bình'
from student join studenttest on studenttest.RN = student.RN 
group by student.name
order by `Điểm Trung Bình` desc;

-- Câu 6: 
select student.name as 'Student Name', avg(mark) as 'Điểm Trung Bình'
from student join studenttest on studenttest.RN = student.RN 
group by student.name
order by `Điểm Trung Bình` desc
limit 1;

-- Câu 7:
select test.Subtestname as 'Tên môn học', max(Studenttest.mark) as 'Điểm cao nhất'
from Studenttest join test on test.testid = studenttest.testid
group by test.Subtestname
order by test.Subtestname;

-- Câu 8:
select student.name as 'Student Name',if(test.Subtestname is null,'chưa học môn nào', test.Subtestname) as 'Tên Môn Học'
from student left join studenttest on studenttest.RN = student.RN 
			 left join test on test.testid = studenttest.testid;
             
-- Câu 9:
update student set age = age + 1 where RN > 0; 

-- Câu 10;
alter table student add status varchar(10);

-- Câu 11:
update student set status = if(age < 30, 'Young','old') where RN > 0; 

-- Câu 12:
create view allStudent as
select student.name as 'Student Name', test.Subtestname as 'Test Name', studenttest.mark, studenttest.date
from student join studenttest on studenttest.RN = student.RN 
			 join test on test.testid = studenttest.testid;
        
-- Câu 13:
DELIMITER $$
CREATE TRIGGER tgSetStatus 
 before UPDATE on student
 FOR EACH ROW
BEGIN
	set new.status = if(new.age < 30, 'Young','old'); 
END
$$

-- Câu 14:
CREATE VIEW view1 as
SELECT s.Name ,t.Subtestname ,st.mark
FROM Student as s 
		LEFT JOIN studenttest as st on s.RN=st.RN 
        LEFT JOIN Test as t on st.testid =t.testid;

drop procedure spViewStatus;
DELIMITER $$
CREATE procedure spViewStatus(IN nameHV varchar(50), IN nameMH varchar(50),OUT output1 varchar(50),out output2 float)
BEGIN
DECLARE diem float;
	if nameHV not in (select Name from Student) or nameMH not in(select Subtestname from test) then
		set output1='Khong tìm thấy';
	else
		SELECT Mark INTO diem FROM view1 WHERE view1.Name=nameHV and view1.Subtestname=nameMH;
            set output2=diem;
 			IF diem>=5 then
				SET output1='Đỗ';
			ELSEIF diem<5 then
				SET output1='Trượt';
			ELSE
				SET output1='Chưa thi';
			end if;
	end if;
END$$


call spViewStatus('Nguyen Hong Ha','SQL1',@a,@b);

select @a as 'trạng thái' , @b as 'Điểm thi';