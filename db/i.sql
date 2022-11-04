-- create database railway_reservation_system;
drop table date_train_records;
create table date_train_records(
    date varchar(255) not null,
    train_id varchar(255) not null,
    num_ac integer,
    num_slr integer,
    primary key (date,train_id)
);






CREATE OR REPLACE FUNCTION check_avail_pro()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
declare 
 temp_date varchar(255);
 temp_train_id varchar(255);
 temp_pref varchar(255);
 temp_num_passenger integer;
 temp1 varchar(255);
 temp_row record;

BEGIN
  temp_date := new.date; 
  temp_train_id := new.train_id; 
  temp_pref := new.pref; 
  temp_num_passenger := new.num_passenger; 
  temp1:= CONCAT('t_',temp_date,'_',temp_train_id);
 

  EXECUTE 'SELECT * from '
  || quote_ident(temp1)
  INTO temp_row;

 raise notice '% ',temp_row.train_id;


  


	RETURN NEW;
END;
$$;








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
  temp2 varchar(255);
  temp3 varchar(255);
  
BEGIN
  temp_train_id := new.train_id;
  temp_date := new.date;
  temp1 := CONCAT('t_',temp_date,'_',temp_train_id);
  temp2 := CONCAT('bookingq_',temp_date,'_',temp_train_id);
  temp3 := CONCAT('seats_avail_check_',temp_date,'_',temp_train_id);
  EXECUTE 'create table if not exists '
    || quote_ident(temp1)
    || ' (
      date varchar(255),
      train_id varchar(255),
      num_ac integer,
      num_slr integer,
      filled_ac_count integer,
      filled_slr_count integer,
      primary key (train_id),
      CONSTRAINT fk_date_train_records
        FOREIGN KEY(date,train_id) 
	        REFERENCES date_train_records(date,train_id)
    )';
-- ! chages here
  EXECUTE 'insert into '
    || quote_ident(temp1)
    || '(
      date,
      train_id,
      num_ac,
      num_slr,
      filled_ac_count ,
      filled_slr_count 
    ) values ('
    || quote_ident(temp_date) || ','
    || quote_ident(temp_train_id) || ','
    || quote_ident() || ','
    || quote_ident(temp_train_id)
    ;

   EXECUTE 'create table if not exists '
    || quote_ident(temp2)
    || ' (
      req_id SERIAL,
      date varchar(255),
      train_id varchar(255),
      num_passenger integer,
      pref varchar(255),
      primary key (req_id)
    )';




    EXECUTE 'create trigger'  
    || quote_ident(temp3)
    ' before insert on'
    || quote_ident(temp2)
    || 'for each row execute procedure check_avail_pro()';

  -- ! remove
  raise notice '% ',temp1;


	RETURN NEW;
END;
$$;

CREATE TRIGGER create_train_table
  BEFORE insert
  ON date_train_records
  FOR EACH row
  EXECUTE PROCEDURE make_train_table();

CREATE TRIGGER create_pnr_tickets
  BEFORE insert
  ON date_train_records
  FOR EACH row
  EXECUTE PROCEDURE make_train_table();

-- ! by admin
insert into date_train_records (date, train_id) values ('11_13_2002','12234');
insert into date_train_records (date, train_id) values ('13_13_2002','12231');


