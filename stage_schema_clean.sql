);
);
);
);
);
);
);
);
);
);
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);
    ADD CONSTRAINT ascents_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;
    ADD CONSTRAINT ascents_mountain_id_fkey FOREIGN KEY (mountain_id) REFERENCES public.mountains(id) ON DELETE CASCADE;
    ADD CONSTRAINT ascents_pkey PRIMARY KEY (id);
    ADD CONSTRAINT climbers_pkey PRIMARY KEY (id);
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);
    ADD CONSTRAINT group_climbers_climber_id_fkey FOREIGN KEY (climber_id) REFERENCES public.climbers(id) ON DELETE CASCADE;
    ADD CONSTRAINT group_climbers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;
    ADD CONSTRAINT group_climbers_pkey PRIMARY KEY (group_id, climber_id);
    ADD CONSTRAINT groups_name_key UNIQUE (name);
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);
    ADD CONSTRAINT mountains_name_key UNIQUE (name);
    ADD CONSTRAINT mountains_pkey PRIMARY KEY (id);
ALTER SEQUENCE public.ascents_id_seq OWNED BY public.ascents.id;
ALTER SEQUENCE public.ascents_id_seq OWNER TO postgres;
ALTER SEQUENCE public.climbers_id_seq OWNED BY public.climbers.id;
ALTER SEQUENCE public.climbers_id_seq OWNER TO postgres;
ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;
ALTER SEQUENCE public.equipment_id_seq OWNER TO postgres;
ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;
ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;
ALTER SEQUENCE public.mountains_id_seq OWNED BY public.mountains.id;
ALTER SEQUENCE public.mountains_id_seq OWNER TO postgres;
ALTER TABLE ONLY public.alembic_version
ALTER TABLE ONLY public.ascents
ALTER TABLE ONLY public.ascents
ALTER TABLE ONLY public.ascents
ALTER TABLE ONLY public.ascents ALTER COLUMN id SET DEFAULT nextval('public.ascents_id_seq'::regclass);
ALTER TABLE ONLY public.climbers
ALTER TABLE ONLY public.climbers ALTER COLUMN id SET DEFAULT nextval('public.climbers_id_seq'::regclass);
ALTER TABLE ONLY public.equipment
ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);
ALTER TABLE ONLY public.group_climbers
ALTER TABLE ONLY public.group_climbers
ALTER TABLE ONLY public.group_climbers
ALTER TABLE ONLY public.groups
ALTER TABLE ONLY public.groups
ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);
ALTER TABLE ONLY public.mountains
ALTER TABLE ONLY public.mountains
ALTER TABLE ONLY public.mountains ALTER COLUMN id SET DEFAULT nextval('public.mountains_id_seq'::regclass);
ALTER TABLE public.alembic_version OWNER TO postgres;
ALTER TABLE public.ascents OWNER TO postgres;
ALTER TABLE public.climbers OWNER TO postgres;
ALTER TABLE public.equipment OWNER TO postgres;
ALTER TABLE public.group_climbers OWNER TO postgres;
ALTER TABLE public.groups OWNER TO postgres;
ALTER TABLE public.mountains OWNER TO postgres;
ALTER TYPE public.ascentstatus OWNER TO postgres;
ALTER TYPE public.difficultylevel OWNER TO postgres;
ALTER TYPE public.experiencelevel OWNER TO postgres;
    AS integer
    AS integer
    AS integer
    AS integer
    AS integer
    CACHE 1;
    CACHE 1;
    CACHE 1;
    CACHE 1;
    CACHE 1;
    climber_id integer NOT NULL
    condition character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
CREATE INDEX ix_ascents_id ON public.ascents USING btree (id);
CREATE INDEX ix_climbers_id ON public.climbers USING btree (id);
CREATE INDEX ix_equipment_id ON public.equipment USING btree (id);
CREATE INDEX ix_groups_id ON public.groups USING btree (id);
CREATE INDEX ix_groups_name ON public.groups USING btree (name);
CREATE INDEX ix_mountains_id ON public.mountains USING btree (id);
CREATE INDEX ix_mountains_name ON public.mountains USING btree (name);
CREATE SEQUENCE public.ascents_id_seq
CREATE SEQUENCE public.climbers_id_seq
CREATE SEQUENCE public.equipment_id_seq
CREATE SEQUENCE public.groups_id_seq
CREATE SEQUENCE public.mountains_id_seq
CREATE TABLE public.alembic_version (
CREATE TABLE public.ascents (
CREATE TABLE public.climbers (
CREATE TABLE public.equipment (
CREATE TABLE public.group_climbers (
CREATE TABLE public.groups (
CREATE TABLE public.mountains (
CREATE TYPE public.ascentstatus AS ENUM (
CREATE TYPE public.difficultylevel AS ENUM (
CREATE TYPE public.experiencelevel AS ENUM (
    date date NOT NULL,
    difficulty public.difficultylevel NOT NULL,
    equipment_type character varying NOT NULL,
    experience public.experiencelevel NOT NULL,
    formation_date date NOT NULL
    group_id integer NOT NULL,
    group_id integer NOT NULL,
    height integer NOT NULL,
    id integer NOT NULL,
    id integer NOT NULL,
    id integer NOT NULL,
    id integer NOT NULL,
    id integer NOT NULL,
    INCREMENT BY 1
    INCREMENT BY 1
    INCREMENT BY 1
    INCREMENT BY 1
    INCREMENT BY 1
    location character varying NOT NULL,
    mountain_id integer NOT NULL,
    name character varying NOT NULL,
    name character varying NOT NULL,
    name character varying NOT NULL,
    name character varying NOT NULL,
    nationality character varying NOT NULL
    NO MAXVALUE
    NO MAXVALUE
    NO MAXVALUE
    NO MAXVALUE
    NO MAXVALUE
    NO MINVALUE
    NO MINVALUE
    NO MINVALUE
    NO MINVALUE
    NO MINVALUE
    notes character varying
    purchase_date date
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_encoding = 'UTF8';
SET client_min_messages = warning;
SET default_table_access_method = heap;
SET default_tablespace = '';
SET idle_in_transaction_session_timeout = 0;
SET lock_timeout = 0;
SET row_security = off;
SET standard_conforming_strings = on;
SET statement_timeout = 0;
SET xmloption = content;
    START WITH 1
    START WITH 1
    START WITH 1
    START WITH 1
    START WITH 1
    status public.ascentstatus NOT NULL,
    version_num character varying(32) NOT NULL
    'В процессе',
    'Высокая',
    'Завершено',
    'Запланировано',
    'Любитель',
    'Низкая',
    'Новичок',
    'Опытный',
    'Отменено'
    'Профессионал'
    'Средняя',
    'Экстремальная'
