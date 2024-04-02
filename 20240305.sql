-- ddl(creat, drop, alter) -- auto commit
create table member(
name VARCHAR2(10),
userid VARCHAR2(10),
pwd VARCHAR2(10),
email VARCHAR2(20),
phone char(13),
admin number(1) DEFAULT 0,  -- 0:사용자, 1:관리자
PRIMARY key (userid)
);
-- dml -- 직접 commit
insert into member values('조조', 'somi', '1234', 'jo@naver.com', '010-1111-2222',0);
insert into member values('관우', 'sang12', '1234', 'gma@naver.com', '010-1111-2222',1);
insert into member values('손권', 'light', '1234', 'youn@naver.com', '010-1111-2222',1);
insert into member values('간홍', 'light2', '1234', 'youn@naver.com', '010-1111-2222',1);
DELETE FROM MEMBER WHERE USERID = 'LIGHT2';
commit;

select * from member;