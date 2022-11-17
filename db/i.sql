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
 PNR varchar(255);
--  tickets varchar(255);
--  ticket varchar(255);
 temp_name varchar(255);
 counter integer;
 berth_num integer;
 coach_num integer;
 temp_type varchar(255);
 

BEGIN
  -- ! refractor the var names
  temp_date := new.date; 
  temp_train_id := new.train_id; 
  temp_pref := new.pref; 
  temp_num_passenger := new.num_passenger; 
  temp1:= CONCAT('t_',temp_date,'_',temp_train_id);
  -- tickets := CONCAT('pnrs_',temp_date,'_',temp_train_id);
  
 

  EXECUTE 'SELECT * from '
  || quote_ident(temp1)
  INTO temp_row;

  -- ! error handling
  if temp_pref = 'ac' then
    if ( temp_num_passenger + temp_row.filled_ac_count <= 18*temp_row.num_ac) then
        starting_seat_num := temp_row.filled_ac_count;
        -- PNR:= CONCAT(temp_date,temp_train_id,starting_seat_num,'0');
        -- ticket := CONCAT('passenger_',PNR);
        -- EXECUTE 'create table if not exists '
        -- || quote_ident(tickets)
        -- || ' (
        --   pnr varchar(255),
        --   date varchar(255),
        --   train_id varchar(255),
        --   num_passenger integer,
        --   primary key (pnr)
        -- )';
        -- EXECUTE 'insert into '
        -- || quote_ident(tickets)
        -- || '(
        --   pnr,
        --   date,
        --   train_id,
        --   num_passenger
        -- ) values ('
        -- || quote_literal(PNR) || ','
        -- || quote_literal(temp_date) || ','
        -- || quote_literal(temp_train_id) || ','
        -- || quote_literal(temp_num_passenger) || ')'
        -- ;


        -- EXECUTE 'create table if not exists '
        -- || quote_ident(ticket)
        -- || ' (
        --   name varchar(255),
        --   pref varchar(255),
        --   type varchar(255),
        --   coach_num integer,
        --   berth_num integer,
        --   primary key (coach_num,berth_num)
        -- )';

        
         
            -- counter := 0;
        
            -- while counter <temp_num_passenger loop
            --   berth_num := (starting_seat_num+counter)%18+1;
            --   if(berth_num%6=0) then
            --     temp_type := 'SU';
            --   elsif (berth_num%6=1) then
            --     temp_type := 'LB';
            --   elsif (berth_num%6=2) then
            --     temp_type := 'LB';
            --   elsif (berth_num%6=3) then
            --     temp_type := 'UB';
            --   elsif (berth_num%6=4) then
            --     temp_type := 'UB';
            --   elsif (berth_num%6=5) then
            --     temp_type := 'SL';
            --   end if;
            --   coach_num := (starting_seat_num+counter)/18+1;

            --   temp_name := split_part(new.names,',',counter+1);

<<<<<<< HEAD
            --   -- EXECUTE 'insert into '
            --   -- || quote_ident(ticket)
            --   -- || ' (
            --   --   name ,
            --   --   pref ,
            --   --   type ,
            --   --   coach_num ,
            --   --   berth_num 
            --   -- ) values ('
            --   -- || quote_literal(temp_name) || ','
            --   -- || quote_literal(temp_pref) || ','
            --   -- || quote_literal(temp_type) || ','
            --   -- || quote_literal(coach_num) || ','
            --   -- || quote_literal(berth_num) || ')'
            --   -- ;
=======
            --   EXECUTE 'insert into '
            --   || quote_ident(ticket)
            --   || ' (
            --     name ,
            --     pref ,
            --     type ,
            --     coach_num ,
            --     berth_num 
            --   ) values ('
            --   || quote_literal(temp_name) || ','
            --   || quote_literal(temp_pref) || ','
            --   || quote_literal(temp_type) || ','
            --   || quote_literal(coach_num) || ','
            --   || quote_literal(berth_num) || ')'
            --   ;
>>>>>>> d85c41666bc8cd95d260e8d16f8043edd64c30ca

            --   counter := counter+1;
            -- end loop;

       
        -- EXECUTE 'select * from '
        -- || quote_ident(tickets) 
        -- || ' where pnr = '
        -- || quote_literal(PNR)
        -- ;

        -- EXECUTE 'select * from '
        -- || quote_ident(ticket) 
        -- ;




        EXECUTE 'Update  '
        || quote_ident(temp1)
        || ' set filled_ac_count = '  
        || quote_literal( temp_num_passenger + temp_row.filled_ac_count )
        || ' where date = ' 
        || quote_literal(temp_date)
        ;
    else 
      raise exception using message = 'SEATS UNAVAILABLE!!',errcode = 'P3333';
    end if;



  else
    if ( temp_num_passenger + temp_row.filled_slr_count <= 24*temp_row.num_slr) then
      starting_seat_num := temp_row.filled_slr_count ;
<<<<<<< HEAD
      -- PNR:= CONCAT(temp_date,temp_train_id,starting_seat_num,'1');
=======
      PNR:= CONCAT(temp_date,temp_train_id,starting_seat_num,'1');
>>>>>>> d85c41666bc8cd95d260e8d16f8043edd64c30ca
      -- ticket := CONCAT('passenger_',PNR);
      -- EXECUTE 'create table if not exists '
      -- || quote_ident(tickets)
      -- || ' (
      --   pnr varchar(255),
      --   date varchar(255),
      --   train_id varchar(255),
      --   num_passenger integer,
      --   primary key (pnr)
      -- )';
      -- EXECUTE 'insert into '
      -- || quote_ident(tickets)
      -- || '(
      --   pnr,
      --   date,
      --   train_id,
      --   num_passenger
      -- ) values ('
      -- || quote_literal(PNR) || ','
      -- || quote_literal(temp_date) || ','
      -- || quote_literal(temp_train_id) || ','
      -- || quote_literal(temp_num_passenger) || ')'
      -- ;


      -- EXECUTE 'create table if not exists '
      -- || quote_ident(ticket)
      -- || ' (
      --   name varchar(255),
      --   pref varchar(255),
      --   type varchar(255),
      --   coach_num integer,
      --   berth_num integer,
      --   primary key (coach_num,berth_num)
      -- )';

      
        
      -- counter := 0;
  
      -- while counter <temp_num_passenger loop
      --   berth_num := (starting_seat_num+counter)%24+1;
      --   if(berth_num%8=0) then
      --     temp_type := 'SU';
      --   elsif (berth_num%8=1) then
      --     temp_type := 'LB';
      --   elsif (berth_num%8=2) then
      --     temp_type := 'MB';
      --   elsif (berth_num%8=3) then
      --     temp_type := 'UB';
      --   elsif (berth_num%8=4) then
      --     temp_type := 'LB';
      --   elsif (berth_num%8=5) then
      --     temp_type := 'MB';
      --   elsif (berth_num%8=6) then
      --     temp_type := 'UB';
      --   elsif (berth_num%8=7) then
      --     temp_type := 'SL';
      --   end if;
      --   coach_num := (starting_seat_num+counter)/24+1+temp_row.num_ac;

      --   temp_name := split_part(new.names,',',counter+1);
<<<<<<< HEAD
        -- EXECUTE 'insert into '
        -- || quote_ident(ticket)
        -- || ' (
        --   name ,
        --   pref ,
        --   type ,
        --   coach_num ,
        --   berth_num 
        -- ) values ('
        -- || quote_literal(temp_name) || ','
        -- || quote_literal(temp_pref) || ','
        -- || quote_literal(temp_type) || ','
        -- || quote_literal(coach_num) || ','
        -- || quote_literal(berth_num) || ')'
        -- ;

        -- counter := counter+1;
=======
      --   EXECUTE 'insert into '
      --   || quote_ident(ticket)
      --   || ' (
      --     name ,
      --     pref ,
      --     type ,
      --     coach_num ,
      --     berth_num 
      --   ) values ('
      --   || quote_literal(temp_name) || ','
      --   || quote_literal(temp_pref) || ','
      --   || quote_literal(temp_type) || ','
      --   || quote_literal(coach_num) || ','
      --   || quote_literal(berth_num) || ')'
      --   ;

      --   counter := counter+1;
>>>>>>> d85c41666bc8cd95d260e8d16f8043edd64c30ca
      -- end loop;
        
      EXECUTE 'Update  '
        || quote_ident(temp1)
        || ' set filled_slr_count = '  
        || quote_literal( temp_num_passenger + temp_row.filled_slr_count )
        || ' where date = ' 
        || quote_literal(temp_date)
        ;
    else 
      raise exception using message = 'SEATS UNAVAILABLE!!',errcode = 'P3333';
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
  -- raise notice '%',temp_train_id;

  temp1 := CONCAT('t_',temp_date,'_',temp_train_id); 
  -- raise exception '%',temp1;
  temp2 := CONCAT('bookingq_',temp_date,'_',temp_train_id);
  -- raise exception '%',temp2;
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
    || quote_literal(0) ||','
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
      names text,
      primary key (req_id)
    )';




    EXECUTE 'create trigger '  
    || quote_ident(temp3)
    ||' before insert on '
    || quote_ident(temp2)
    || ' for each row execute procedure check_avail_pro()';



	RETURN NEW;
END;
$$;

CREATE TRIGGER create_train_table
  AFTER insert
  ON date_train_records
  FOR EACH row
  EXECUTE PROCEDURE make_train_table();



-- ! by admin
-- ! date need to be parsed properly





-- insert into date_train_records (date, train_id,num_ac,num_slr) values ('11132002','12234',23,22);
-- insert into date_train_records (date, train_id,num_ac,num_slr) values ('13132002','02231',22,23);
-- insert into bookingq_11132002_12234 (date, train_id, num_passenger,pref,names,ages, genders) values ('11132002','12234',4,'ac','A,B,C,D','18,19,20,7','M,M,F,F');
-- insert into bookingq_11132002_12234 (date, train_id, num_passenger,pref,names,ages, genders) values ('11132002','12234',4,'ac','E,F,G,H','18,19,20,7','M,M,F,F');
