-- create database railway_reservation_system;
drop table date_train_records;
create table date_train_records(
    date varchar(255) not null,
    train_id varchar(255) not null,
    num_ac integer,
    num_slr integer,
    primary key (date,train_id)
);

-- ! changes
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
 starting_seat_num integer;
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
  -- ! error handling
  if temp_pref = 'ac' then
    if ( temp_num_passenger + temp_row.filled_ac_count <= 18*temp_row.num_ac) then
        starting_seat_num := temp_row.filled_ac_count +1;

        EXECUTE 'Update  '
        || quote_ident(temp1)
        || ' set filled_ac_count = '  
        || quote_literal( temp_num_passenger + temp_row.filled_ac_count )
        || ' where date = ' 
        || quote_literal(temp_date)
        ;
    else 
      raise notice 'SEATS UNAVAILABLE!!😭';
    end if;
  else
    if ( temp_num_passenger + temp_row.filled_slr_count <= 24*temp_row.num_slr) then
      starting_seat_num := temp_row.filled_slr_count +1;
      EXECUTE 'Update  '
        || quote_ident(temp1)
        || ' set filled_slr_count = '  
        || quote_literal( temp_num_passenger + temp_row.filled_slr_count )
        || ' where date = ' 
        || quote_literal(temp_date)
        ;
    else 
      raise notice 'SEATS UNAVAILABLE!!😭';
    end if; 
  end if;


	RETURN NEW;
END;
$$;









CREATE OR REPLACE FUNCTION make_train_table()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
$$
declare 
  temp_train_id varchar(255);
  temp_date varchar(255);
  temp_num_ac integer ;
  temp_num_slr integer ;
  temp1 varchar(255);
  temp2 varchar(255);
  temp3 varchar(255);
  
BEGIN
  temp_train_id := new.train_id;
  temp_date := new.date;
  temp_num_ac := new.num_ac;
  temp_num_slr := new.num_slr;


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
      filled_ac_count integer default 0,
      filled_slr_count integer default 0,
      primary key (train_id),
      CONSTRAINT fk_date_train_records
        FOREIGN KEY(date,train_id) 
	        REFERENCES date_train_records(date,train_id)
    )';

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
    || quote_literal(temp_date) || ','
    || quote_literal(temp_train_id) || ','
    || quote_literal(temp_num_ac) || ','
    || quote_literal(temp_num_slr) ||','
    || quote_literal(10) ||','
    || quote_literal(0) ||')'

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




    EXECUTE 'create trigger '  
    || quote_ident(temp3)
    ||' before insert on '
    || quote_ident(temp2)
    || ' for each row execute procedure check_avail_pro()';

  -- ! remove
  raise notice '% ',temp1;


	RETURN NEW;
END;
$$;

CREATE TRIGGER create_train_table
  AFTER insert
  ON date_train_records
  FOR EACH row
  EXECUTE PROCEDURE make_train_table();



-- ! by admin
insert into date_train_records (date, train_id,num_ac,num_slr) values ('11_13_2002','12234',23,22);
insert into date_train_records (date, train_id,num_ac,num_slr) values ('13_13_2002','12231',22,23);
insert into bookingq_11_13_2002_12234 (date, train_id, num_passenger,pref) values ('11_13_2002','12234',4,'ac');