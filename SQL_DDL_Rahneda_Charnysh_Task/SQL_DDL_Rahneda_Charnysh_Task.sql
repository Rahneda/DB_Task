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

create table Climb_Type(
    climb_type_id serial primary key ,
    climber_id int not null ,
    mountain_id int not null ,

    constraint fk_climber_id
                       foreign key (climber_id)
                       references Climber(climber_id),
    constraint fk_mountain_id
                       foreign key (mountain_id)
                       references Mountain(mountain_id)
);

create table Climb(
    climb_id serial primary key,
    climber_id int not null ,
    mountain_id int not null ,
    start_date date not null ,
    end_date date not null,
    created_at timestamp with time zone default current_timestamp,
    updated_at timestamp with time zone default current_timestamp,

    constraint fk_climber_id
                  foreign key (climber_id)
                  references Climber(climber_id),

    constraint fk_mountain_id
                  foreign key (mountain_id)
                  references Mountain(mountain_id)
);

create table Climb_Difficulty(
    climb_id int not null ,
    difficulty_level_id int not null ,

    constraint fk_climb_id
                             foreign key (climb_id)
                             references Climb(climb_id),

    constraint fk_difficulty_level_id
                             foreign key (difficulty_level_id)
                             references Difficulty_Level(difficulty_level_id)
);

create table Climb_Equipment(
    climb_id int not null ,
    equipment_id int not null ,

    constraint fk_climb_id
                            foreign key (climb_id)
                            references Climb(climb_id),
    constraint fk_equipment_id
                            foreign key (equipment_id)
                            references Equipment(equipment_id)
);