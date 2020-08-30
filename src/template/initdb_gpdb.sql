/*
Greenplum databse initialize sql file

Type   : PGSQL/Greenplum
Author : tang
Date   : 2020-04-24 15:15:56
*/
-- ----------------------------
-- modify user gpadmin password
-- ----------------------------
ALTER ROLE "gpadmin" WITH PASSWORD 'g0csWpW78Sm2';

-- ----------------------------
-- create user
-- ----------------------------
DROP USER IF EXISTS "study";
CREATE ROLE "study" login PASSWORD '123321' NOINHERIT;

-- ----------------------------
-- create database
-- ----------------------------
DROP DATABASE IF EXISTS "studydb";
CREATE DATABASE "studydb" owner "study";
