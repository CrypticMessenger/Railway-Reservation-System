-- create database train_schedule;
drop table routes;
drop table one_stop;
create table routes(
    train_id varchar(255) not null,
    src varchar(255),
    dest varchar(255),
    src_departure_time varchar(255),
    dest_arrival_time varchar(255),
    src_departure_date varchar(255),
    dest_arrival_date varchar(255)
);
--insert into routes(train_id,src,dest,arrival_time,departure_time,arrival_date,departure_date)values ("12141","ABC asd","BCD","05:30","06:30","02-55-89","05-58-98");

create table one_stop(
    train1_id varchar(255),
    train2_id varchar(255),
    src varchar(255),
    stop varchar(255),
    dest varchar(255),
    src_departure_time varchar(255),
    stop_arrival_time varchar(255),
    stop_departure_time varchar(255),
    dest_arrival_time varchar(255),
    doj varchar(255),
    stop_doj_1 varchar(255),
    stop_doj_2 varchar(255),
    eoj varchar(255)
);


CREATE FUNCTION intval(character varying) RETURNS integer AS $$

SELECT
CASE
    WHEN length(btrim(regexp_replace($1, '[^0-9]', '','g')))>0 THEN btrim(regexp_replace($1, '[^0-9]', '','g'))::integer
    ELSE 0
END AS intval;

$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;


create function my_function() 
returns void 
language plpgsql 
as 
 $$
 declare
    outer_ptr record;
    inner_ptr record;
    year1 varchar(255) ;
    year2 varchar(255) ;
    mon1 varchar(255) ;
    mon2 varchar(255) ;
    day1 varchar(255) ;
    day2 varchar(255) ;
    hr1 varchar(255) ;
    hr2 varchar(255) ;
    min1 varchar(255) ;
    min2 varchar(255) ;
    year11 integer ;
    year22 integer ;
    mon11 integer ;
    mon22 integer ;
    day11 integer ;
    day22 integer ;
    hr11 integer ;
    hr22 integer ;
    min11 integer ;
    min22 integer ;
 Begin
    for outer_ptr in select * from routes
    loop 
        for inner_ptr in select * from routes
        loop 
            year1 := split_part(outer_ptr.dest_arrival_date,'-',3);
            year11:=intval(year1);
            mon1 := split_part(outer_ptr.dest_arrival_date,'-',2);
            mon11 := intval(mon1);
            day1 := split_part(outer_ptr.dest_arrival_date,'-',1);
            day11 :=intval(day1);
            year2 := split_part(inner_ptr.src_departure_date,'-',3);
            year22 :=intval(year2);
            mon2 := split_part(inner_ptr.src_departure_date,'-',2);
            mon22:=intval(mon2);
            day2 := split_part(inner_ptr.src_departure_date,'-',1);
            day22:=intval(day2);
            hr1 := split_part(outer_ptr.dest_arrival_time,':',1);
            hr11:=intval(hr1);
            min1 := split_part(outer_ptr.dest_arrival_time,':',2);
            min11:=intval(min1);
            hr2 := split_part(inner_ptr.src_departure_time,':',1);
            hr22:=intval(hr2);
            min2 := split_part(inner_ptr.src_departure_time,':',2);
            min22:=intval(min2);

            -- raise exception '%',year1;
            -- raise exception '%',year2;
            -- raise exception '%',mon1;
            -- raise exception '%',mon2;
            -- raise exception '%',day1;
            -- raise exception '%',day2;
            -- raise exception '%',hr1;
            -- raise exception '%',hr2;
            -- raise exception '%',min1;
            -- raise exception '%',min2;
            --  r1.dest as stop, r2.dest as dest,r1.src_departure_time as src_dept_time,r1.dest_arrival_time as stop_arrival_time,r2.src_departure_time as stop_dept_time,
            --  r2.dest_arrival_time as dest_arrival_time,
            --   r1.src_departure_date as doj, r1.dest_arrival_date as stop_doj_1,r2.src_departure_date as stop_doj_2, r2.dest_arrival_date as eoj  
            if outer_ptr.train_id != inner_ptr.train_id and outer_ptr.dest = inner_ptr.src then
                if(year11>year22) then
                elsif (year11<year22) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                else             
                    if(mon11 > mon22) then 
                    elsif (mon11 < mon22) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                    else
                        if (day11 > day22) then 
                        elsif (day11 < day22) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                        else 
                            if(hr11 > hr22) then 
                            elsif (hr11 < hr22) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                            else 
                                if(min11 > min22) then
                                elsif (min11 < min22) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                                else insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                                end if;
                            end if;
                        end if;
                    end if;
                end if; 
            end if;
        end loop;
    end loop;
End;
 $$;

