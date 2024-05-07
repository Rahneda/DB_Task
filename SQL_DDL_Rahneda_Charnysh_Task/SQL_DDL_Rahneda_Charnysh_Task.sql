create table Climb (
    climb_id serial primary key,
    climber_id int,
    mountain_id int,
    start_date date,
    end_date date
);

create table Climber (
    climber_id serial primary key,
    name varchar,
    address varchar
);

