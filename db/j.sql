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
Create function check_time(t1 varchar(255),t2 varchar(255),d1 varchar(255),d2 varchar(255))  
returns varchar(255)
language plpgsql  
as  
$$  
Declare  
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
Begin 
   year1 := split_part(d1,'-',3);
   mon1 := split_part(d1,'-',2);
   day1 := split_part(d1,'-',1);
   year2 := split_part(d2,'-',3);
   mon2 := split_part(d2,'-',2);
   day2 := split_part(d2,'-',1);
   hr1 := split_part(t1,':',1);
   min1 := split_part(t1,':',2);
   hr2 := split_part(t2,':',1);
   min2 := split_part(t2,':',2);
   raise notice '%',year1;
   raise notice '%',year2;
   raise notice '%',mon1;
   raise notice '%',mon2;
   raise notice '%',day1;
   raise notice '%',day2;
   raise notice '%',hr1;
   raise notice '%',hr2;
   raise notice '%',min1;
   raise notice '%',min2;
    if(year1>year2) then 
        return 'false';
    elsif (year1<year2) then return 'true';
    else 
        if(mon1 > mon2) then return 'false';
        elsif (mon1 < mon2) then return 'true';
        else
            if (day1 > day2) then return 'false';
            elsif (day1 < day2) then return 'true';
            else 
                if(hr1 > hr2) then return 'false';
                elsif (hr1 < hr2) then return 'true';
                else 
                    if(min1 > min2) then return 'false';
                    elsif (min1 < min2) then return 'true';
                    else return 'true';
                    end if;
                end if;
            end if;
        end if;
    end if;

End;  
$$; 

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
 Begin
    for outer_ptr in select * from routes
    loop 
        for inner_ptr in select * from routes
        loop 
            year1 := split_part(outer_ptr.dest_arrival_date,'-',3);
            mon1 := split_part(outer_ptr.dest_arrival_date,'-',2);
            day1 := split_part(outer_ptr.dest_arrival_date,'-',1);
            year2 := split_part(inner_ptr.src_departure_date,'-',3);
            mon2 := split_part(inner_ptr.src_departure_date,'-',2);
            day2 := split_part(inner_ptr.src_departure_date,'-',1);
            hr1 := split_part(outer_ptr.dest_arrival_time,':',1);
            min1 := split_part(outer_ptr.dest_arrival_time,':',2);
            hr2 := split_part(inner_ptr.src_departure_time,':',1);
            min2 := split_part(inner_ptr.src_departure_time,':',2);
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
                if(year1>year2) then
                elsif (year1<year2) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                else             
                    if(mon1 > mon2) then 
                    elsif (mon1 < mon2) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                    else
                        if (day1 > day2) then 
                        elsif (day1 < day2) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                        else 
                            if(hr1 > hr2) then 
                            elsif (hr1 < hr2) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
                            else 
                                if(min1 > min2) then
                                elsif (min1 < min2) then insert into one_stop values (outer_ptr.train_id, inner_ptr.train_id, outer_ptr.src,outer_ptr.dest,inner_ptr.dest,outer_ptr.src_departure_time,outer_ptr.dest_arrival_time,inner_ptr.src_departure_time,inner_ptr.dest_arrival_time,outer_ptr.src_departure_date,outer_ptr.dest_arrival_date,inner_ptr.src_departure_date,inner_ptr.dest_arrival_date );
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


