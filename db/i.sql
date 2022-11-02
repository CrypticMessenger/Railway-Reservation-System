-- create database railway_reservation_system;
drop table date_train_records;
create table date_train_records(
    date varchar(255) not null,
    train_id varchar(255) not null,
    primary key (date,train_id)
);
 

-- todo: dynamic variable name and create table
CREATE OR REPLACE FUNCTION make_train_table()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
declare 
  temp_train_id varchar(255);
  temp_date varchar(255);
  temp1 varchar(255);
BEGIN
  temp_train_id := new.train_id;
  temp_date := new.date;
  temp1 := CONCAT(temp_date,'_',temp_train_id);
  raise notice '% ',temp1;


	RETURN NEW;
END;
$$;

CREATE TRIGGER create_train_table
  BEFORE insert
  ON date_train_records
  FOR EACH row
  EXECUTE PROCEDURE make_train_table();

insert into date_train_records (date, train_id) values ('2002-11-13','123354');


