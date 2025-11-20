--
-- PostgreSQL database dump
--

\restrict UbnU5cOdya6wwYx4gDeJwD3DhLKZgF6zyp8zkVgQgAzRogG12ddl4TGdgX39jpk

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

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

--
-- Name: ascentstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.ascentstatus AS ENUM (
    'Запланировано',
    'В процессе',
    'Завершено',
    'Отменено'
);


--
-- Name: difficultylevel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.difficultylevel AS ENUM (
    'Низкая',
    'Средняя',
    'Высокая',
    'Экстремальная'
);


--
-- Name: experiencelevel; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.experiencelevel AS ENUM (
    'Новичок',
    'Любитель',
    'Опытный',
    'Профессионал'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: ascents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ascents (
    id integer NOT NULL,
    mountain_id integer NOT NULL,
    group_id integer NOT NULL,
    date date NOT NULL,
    status public.ascentstatus NOT NULL,
    notes character varying
);


--
-- Name: ascents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ascents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ascents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ascents_id_seq OWNED BY public.ascents.id;


--
-- Name: climbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.climbers (
    id integer NOT NULL,
    name character varying NOT NULL,
    experience public.experiencelevel NOT NULL,
    nationality character varying NOT NULL
);


--
-- Name: climbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.climbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: climbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.climbers_id_seq OWNED BY public.climbers.id;


--
-- Name: equipment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.equipment (
    id integer NOT NULL,
    name character varying NOT NULL,
    equipment_type character varying NOT NULL,
    condition character varying,
    purchase_date date
);


--
-- Name: equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.equipment_id_seq OWNED BY public.equipment.id;


--
-- Name: group_climbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_climbers (
    group_id integer NOT NULL,
    climber_id integer NOT NULL
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying NOT NULL,
    formation_date date NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: mountains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mountains (
    id integer NOT NULL,
    name character varying NOT NULL,
    height integer NOT NULL,
    location character varying NOT NULL,
    difficulty public.difficultylevel NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: mountains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mountains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mountains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mountains_id_seq OWNED BY public.mountains.id;


--
-- Name: ascents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ascents ALTER COLUMN id SET DEFAULT nextval('public.ascents_id_seq'::regclass);


--
-- Name: climbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.climbers ALTER COLUMN id SET DEFAULT nextval('public.climbers_id_seq'::regclass);


--
-- Name: equipment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipment ALTER COLUMN id SET DEFAULT nextval('public.equipment_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: mountains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mountains ALTER COLUMN id SET DEFAULT nextval('public.mountains_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: ascents ascents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_pkey PRIMARY KEY (id);


--
-- Name: climbers climbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.climbers
    ADD CONSTRAINT climbers_pkey PRIMARY KEY (id);


--
-- Name: equipment equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (id);


--
-- Name: group_climbers group_climbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_pkey PRIMARY KEY (group_id, climber_id);


--
-- Name: groups groups_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_name_key UNIQUE (name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: mountains mountains_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mountains
    ADD CONSTRAINT mountains_name_key UNIQUE (name);


--
-- Name: mountains mountains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mountains
    ADD CONSTRAINT mountains_pkey PRIMARY KEY (id);


--
-- Name: ix_ascents_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_ascents_id ON public.ascents USING btree (id);


--
-- Name: ix_climbers_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_climbers_id ON public.climbers USING btree (id);


--
-- Name: ix_equipment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_equipment_id ON public.equipment USING btree (id);


--
-- Name: ix_groups_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_groups_id ON public.groups USING btree (id);


--
-- Name: ix_groups_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_groups_name ON public.groups USING btree (name);


--
-- Name: ix_mountains_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_mountains_id ON public.mountains USING btree (id);


--
-- Name: ix_mountains_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_mountains_name ON public.mountains USING btree (name);


--
-- Name: ascents ascents_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: ascents ascents_mountain_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ascents
    ADD CONSTRAINT ascents_mountain_id_fkey FOREIGN KEY (mountain_id) REFERENCES public.mountains(id) ON DELETE CASCADE;


--
-- Name: group_climbers group_climbers_climber_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_climber_id_fkey FOREIGN KEY (climber_id) REFERENCES public.climbers(id) ON DELETE CASCADE;


--
-- Name: group_climbers group_climbers_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_climbers
    ADD CONSTRAINT group_climbers_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict UbnU5cOdya6wwYx4gDeJwD3DhLKZgF6zyp8zkVgQgAzRogG12ddl4TGdgX39jpk

