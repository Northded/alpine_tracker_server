-- Create ENUM types with English values
CREATE TYPE difficultylevel AS ENUM ('Low', 'Medium', 'High', 'Extreme');
CREATE TYPE experiencelevel AS ENUM ('Beginner', 'Amateur', 'Experienced', 'Professional');
CREATE TYPE ascentstatus AS ENUM ('Planned', 'InProgress', 'Completed', 'Cancelled');

-- Create mountains table
CREATE TABLE mountains (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    height INTEGER NOT NULL,
    location VARCHAR NOT NULL,
    difficulty difficultylevel NOT NULL
);

-- Create climbers table
CREATE TABLE climbers (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    experience experiencelevel NOT NULL,
    nationality VARCHAR NOT NULL
);

-- Create groups table
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    formation_date DATE NOT NULL
);

-- Create ascents table
CREATE TABLE ascents (
    id SERIAL PRIMARY KEY,
    mountain_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    date DATE NOT NULL,
    status ascentstatus NOT NULL,
    notes VARCHAR,
    CONSTRAINT ascents_mountain_id_fkey FOREIGN KEY (mountain_id) 
        REFERENCES mountains(id) ON DELETE CASCADE,
    CONSTRAINT ascents_group_id_fkey FOREIGN KEY (group_id) 
        REFERENCES groups(id) ON DELETE CASCADE
);

-- Create group_climbers table
CREATE TABLE group_climbers (
    group_id INTEGER NOT NULL,
    climber_id INTEGER NOT NULL,
    PRIMARY KEY (group_id, climber_id),
    CONSTRAINT group_climbers_group_id_fkey FOREIGN KEY (group_id) 
        REFERENCES groups(id) ON DELETE CASCADE,
    CONSTRAINT group_climbers_climber_id_fkey FOREIGN KEY (climber_id) 
        REFERENCES climbers(id) ON DELETE CASCADE
);

-- Create indexes
CREATE INDEX ix_mountains_id ON mountains(id);
CREATE INDEX ix_mountains_name ON mountains(name);
CREATE INDEX ix_climbers_id ON climbers(id);
CREATE INDEX ix_groups_id ON groups(id);
CREATE INDEX ix_ascents_id ON ascents(id);
