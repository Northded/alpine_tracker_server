
CREATE TYPE difficultylevel AS ENUM ('Низкая', 'Средняя', 'Высокая', 'Экстремальная');
CREATE TYPE experiencelevel AS ENUM ('Новичок', 'Любитель', 'Опытный', 'Профессионал');
CREATE TYPE ascentstatus AS ENUM ('Запланировано', 'В процессе', 'Завершено', 'Отменено');

CREATE TABLE mountains (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    height INTEGER NOT NULL,
    location VARCHAR NOT NULL,
    difficulty difficultylevel NOT NULL
);

CREATE TABLE climbers (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    experience experiencelevel NOT NULL,
    nationality VARCHAR NOT NULL
);

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL UNIQUE,
    formation_date DATE NOT NULL
);

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

CREATE TABLE group_climbers (
    group_id INTEGER NOT NULL,
    climber_id INTEGER NOT NULL,
    PRIMARY KEY (group_id, climber_id),
    CONSTRAINT group_climbers_group_id_fkey FOREIGN KEY (group_id) 
        REFERENCES groups(id) ON DELETE CASCADE,
    CONSTRAINT group_climbers_climber_id_fkey FOREIGN KEY (climber_id) 
        REFERENCES climbers(id) ON DELETE CASCADE
);

CREATE INDEX ix_mountains_id ON mountains(id);
CREATE INDEX ix_mountains_name ON mountains(name);
CREATE INDEX ix_climbers_id ON climbers(id);
CREATE INDEX ix_groups_id ON groups(id);
CREATE INDEX ix_groups_name ON groups(name);
CREATE INDEX ix_ascents_id ON ascents(id);
