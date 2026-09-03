create table student80(
student80id int(5) primary key,
student80name varchar(20)not null,
DOB date default null,
gender varchar(10),
info80id int(5),
CONSTRAINT UQ_student80name UNIQUE(student80name),
CONSTRAINT FK_info80id FOREIGN KEY(info80id)
references info80(info80id)
);
desc student80;
