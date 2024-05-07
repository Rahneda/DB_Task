create table Ares(
    area_id serial primary key ,
    name varchar not null
);

create table Country(
    country_id serial primary key ,
    name varchar not null
);

create table Difficulty_Level(
    difficulty_level_id serial primary key ,
    level varchar not null
);

create table Equipment(
    equipment_id serial primary key ,
    name varchar not null ,
    description varchar not null
)

create table Climber (
    climber_id serial primary key,
    name varchar not null ,
    address varchar not null
);

create table Climb (
    climb_id serial primary key,
    climber_id int not null ,
    mountain_id int not null ,
    start_date date not null ,
    end_date date not null
);

create table Mountain(
    mountain_id serial primary key ,
    name varchar not null ,
    country_id int not null ,
    area_id int not null ,

    constraint fk_country_id
                     foreign key (country_id)
                     references Country(country_id),
    constraint fk_area_id
                     foreign key (area_id)
                     references Ares(area_id)
);

