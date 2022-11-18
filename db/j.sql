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