
\restrict qer7tFG5fUAijrsvIr2L5EypOmvlq4KsgoXA3FWIbKadBES09zaAaELarMSRh7S


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE TYPE public.ascentstatus AS ENUM (
    'Запланировано',
    'В процессе',
    'Завершено',
    'Отменено'
);



CREATE TYPE public.difficultylevel AS ENUM (
    'Низкая',
    'Средняя',
    'Высокая',
    'Экстремальная'
);



CREATE TYPE public.experiencelevel AS ENUM (
    'Новичок',
    'Любитель',
    'Опытный',
    'Профессионал'
);


SET default_tablespace = '';

SET default_table_access_method = heap;


CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);



CREATE TABLE public.ascents (
    id integer NOT NULL,
    mountain_id integer NOT NULL,
    group_id integer NOT NULL,
    date date NOT NULL,
    status public.ascentstatus NOT NULL,
    notes character varying
);



CREATE SEQUENCE public.ascents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.ascents_id_seq OWNED BY public.ascents.id;



CREATE TABLE public.climbers (
    id integer NOT NULL,
    name character varying NOT NULL,
    experience public.experiencelevel NOT NULL,
    nationality character varying NOT NULL
);



CREATE SEQUENCE public.climbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.climbers_id_seq OWNED BY public.climbers.id;



CREATE TABLE public.equipment (
    id integer NOT NULL,
    name character varying NOT NULL,
    equipment_type character varying NOT NULL,
    condition character varying,
    purchase_date date
);



CREATE SEQUENCE public.equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;



CREATE TABLE public.group_climbers (
    group_id integer NOT NULL,
    climber_id integer NOT NULL
);



CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    formation_date date NOT NULL
);



CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;



CREATE TABLE public.mountains (
    id integer NOT NULL,
    name character varying NOT NULL,
    height integer NOT NULL,
    location character varying NOT NULL,
    difficulty public.difficultylevel NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



CREATE SEQUENCE public.mountains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.mountains_id_seq OWNED BY public.mountains.id;



ALTER TABLE ONLY public.ascents ALTER COLUMN id SET DEFAULT nextval('public.ascents_id_seq'::regclass);



ALTER TABLE ONLY public.climbers ALTER COLUMN id SET DEFAULT nextval('public.climbers_id_seq'::regclass);



ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);



ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);



ALTER TABLE ONLY public.mountains ALTER COLUMN id SET DEFAULT nextval('public.mountains_id_seq'::regclass);



ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);



ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.climbers
    ADD CONSTRAINT climbers_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_pkey PRIMARY KEY (group_id, climber_id);



ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);



ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);



ALTER TABLE ONLY public.mountains
    ADD CONSTRAINT mountains_name_key UNIQUE (name);



ALTER TABLE ONLY public.mountains
    ADD CONSTRAINT mountains_pkey PRIMARY KEY (id);



CREATE INDEX ix_ascents_id ON public.ascents USING btree (id);



CREATE INDEX ix_climbers_id ON public.climbers USING btree (id);



CREATE INDEX ix_equipment_id ON public.equipment USING btree (id);



CREATE INDEX ix_groups_id ON public.groups USING btree (id);



CREATE INDEX ix_groups_name ON public.groups USING btree (name);



CREATE INDEX ix_mountains_id ON public.mountains USING btree (id);



CREATE INDEX ix_mountains_name ON public.mountains USING btree (name);



ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_mountain_id_fkey FOREIGN KEY (mountain_id) REFERENCES public.mountains(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_climber_id_fkey FOREIGN KEY (climber_id) REFERENCES public.climbers(id) ON DELETE CASCADE;



ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;



\unrestrict qer7tFG5fUAijrsvIr2L5EypOmvlq4KsgoXA3FWIbKadBES09zaAaELarMSRh7S

