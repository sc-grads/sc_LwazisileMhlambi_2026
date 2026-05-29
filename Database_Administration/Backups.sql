Create Table SQLBackupRestoreTest (
ID Int not null primary key,
loginname varchar(100) not null,
logindate datetime not null default getdate()
)

insert into SQLBackupRestoreTest (ID, loginname) values (1, 'test1')
insert into SQLBackupRestoreTest (ID, loginname) values (2, 'test2')
insert into SQLBackupRestoreTest (ID, loginname) values (3, 'test3')
insert into SQLBackupRestoreTest (ID, loginname) values (4, 'test4')
insert into SQLBackupRestoreTest (ID, loginname) values (5, 'test5')

select * from SQLBackupRestoreTest

--Full Back up 5 Rows

insert into SQLBackupRestoreTest (ID, loginname) values (6, 'test6')
insert into SQLBackupRestoreTest (ID, loginname) values (7, 'test7')
insert into SQLBackupRestoreTest (ID, loginname) values (8, 'test8')
insert into SQLBackupRestoreTest (ID, loginname) values (9, 'test9')
insert into SQLBackupRestoreTest (ID, loginname) values (10, 'test10')

--Diff Backup 10 rows

insert into SQLBackupRestoreTest (ID, loginname) values (11, 'test11')
insert into SQLBackupRestoreTest (ID, loginname) values (12, 'test12')
insert into SQLBackupRestoreTest (ID, loginname) values (13, 'test13')

--tran log back - 1 up 13 rows

insert into SQLBackupRestoreTest (ID, loginname) values (14, 'test14')
insert into SQLBackupRestoreTest (ID, loginname) values (15, 'test15')
insert into SQLBackupRestoreTest (ID, loginname) values (16, 'test16')
insert into SQLBackupRestoreTest (ID, loginname) values (17, 'test17')

--tran log back - 2 up 17 rows

insert into SQLBackupRestoreTest (ID, loginname) values (18, 'test18')
insert into SQLBackupRestoreTest (ID, loginname) values (19, 'test19')
insert into SQLBackupRestoreTest (ID, loginname) values (20, 'test20')
insert into SQLBackupRestoreTest (ID, loginname) values (21, 'test21')
insert into SQLBackupRestoreTest (ID, loginname) values (22, 'test22')
insert into SQLBackupRestoreTest (ID, loginname) values (23, 'test23')
insert into SQLBackupRestoreTest (ID, loginname) values (24, 'test24')
insert into SQLBackupRestoreTest (ID, loginname) values (25, 'test25')
insert into SQLBackupRestoreTest (ID, loginname) values (26, 'test26')
insert into SQLBackupRestoreTest (ID, loginname) values (27, 'test27')


