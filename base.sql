-- Table: public.conversation

-- DROP TABLE IF EXISTS public.conversation;

CREATE TABLE IF NOT EXISTS public.conversation
(
    id SERIAL NOT NULL,
    conversation_timestamp timestamp without time zone NOT NULL,
    uid text COLLATE pg_catalog."default" NOT NULL,
    ip text COLLATE pg_catalog."default" NOT NULL,
    domain text COLLATE pg_catalog."default" NOT NULL,
    browser_lang text COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    external_uid text COLLATE pg_catalog."default",
    CONSTRAINT conversation_pkey PRIMARY KEY (id)
)

-- Table: public.conversation_action

-- DROP TABLE IF EXISTS public.conversation_action;

CREATE TABLE IF NOT EXISTS public.conversation_action
(
    id SERIAL NOT NULL,
    action_timestamp timestamp without time zone NOT NULL,
    conversation_id bigint NOT NULL,
    tool text COLLATE pg_catalog."default" NOT NULL,
    tool_input text COLLATE pg_catalog."default" NOT NULL,
    tool_output text COLLATE pg_catalog."default" NOT NULL,
    log text COLLATE pg_catalog."default",
    status text COLLATE pg_catalog."default",
    cost numeric(12,6),
    tokens integer,
    CONSTRAINT conversation_action_pkey PRIMARY KEY (id),
    CONSTRAINT conversation_action_conversation_id_fk FOREIGN KEY (conversation_id)
        REFERENCES public.conversation (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

-- Table: public.conversation_event

-- DROP TABLE IF EXISTS public.conversation_event;

CREATE TABLE IF NOT EXISTS public.conversation_event
(
    id SERIAL NOT NULL,
    event_timestamp timestamp without time zone NOT NULL,
    conversation_id bigint NOT NULL,
    event text COLLATE pg_catalog."default",
    log text COLLATE pg_catalog."default",
    CONSTRAINT conversation_event_pkey PRIMARY KEY (id),
    CONSTRAINT conversation_event_fk FOREIGN KEY (conversation_id)
        REFERENCES public.conversation (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

-- Table: public.conversation_message

-- DROP TABLE IF EXISTS public.conversation_message;

CREATE TABLE IF NOT EXISTS public.conversation_message
(
    id SERIAL NOT NULL,
    message_timestamp timestamp without time zone NOT NULL,
    conversation_id bigint NOT NULL,
    sender text COLLATE pg_catalog."default" NOT NULL,
    receiver text COLLATE pg_catalog."default" NOT NULL,
    content text COLLATE pg_catalog."default" NOT NULL,
    tokens integer,
    cost numeric(12,6),
    CONSTRAINT conversation_message_pkey PRIMARY KEY (id),
    CONSTRAINT conversation_message_fk FOREIGN KEY (conversation_id)
        REFERENCES public.conversation (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

-- Table: public.company

-- DROP TABLE IF EXISTS public.company;

CREATE TABLE IF NOT EXISTS public.company
(
    id SERIAL NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    domain character varying(255) COLLATE pg_catalog."default",
    max_ai_messages integer,
    model text COLLATE pg_catalog."default",
    identity text COLLATE pg_catalog."default",
    rules_to_do text COLLATE pg_catalog."default",
    rules_to_not_do text COLLATE pg_catalog."default",
    CONSTRAINT company_pkey PRIMARY KEY (id)
)

-- Table: public.company_chatbot_bye

-- DROP TABLE IF EXISTS public.company_chatbot_bye;

CREATE TABLE IF NOT EXISTS public.company_chatbot_bye
(
    id SERIAL NOT NULL,
    lang character varying(10) COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    company_id integer,
    CONSTRAINT company_chatbot_bye_pkey PRIMARY KEY (id),
    CONSTRAINT company_chatbot_bye_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_chatbot_name

-- DROP TABLE IF EXISTS public.company_chatbot_name;

CREATE TABLE IF NOT EXISTS public.company_chatbot_name
(
    id SERIAL NOT NULL,
    lang character varying(10) COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    company_id integer,
    CONSTRAINT company_chatbot_name_pkey PRIMARY KEY (id),
    CONSTRAINT company_chatbot_name_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_chatbot_welcome

-- DROP TABLE IF EXISTS public.company_chatbot_welcome;

CREATE TABLE IF NOT EXISTS public.company_chatbot_welcome
(
    id SERIAL NOT NULL,
    lang character varying(10) COLLATE pg_catalog."default",
    message text COLLATE pg_catalog."default",
    company_id integer,
    CONSTRAINT company_chatbot_welcome_pkey PRIMARY KEY (id),
    CONSTRAINT company_chatbot_welcome_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_field

-- DROP TABLE IF EXISTS public.company_field;

CREATE TABLE IF NOT EXISTS public.company_field
(
    id SERIAL NOT NULL,
    name character varying(255) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    company_id integer,
    datatype character varying(50) COLLATE pg_catalog."default",
    use_llm boolean,
    CONSTRAINT company_field_pkey PRIMARY KEY (id),
    CONSTRAINT company_field_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_field_example

-- DROP TABLE IF EXISTS public.company_field_example;

CREATE TABLE IF NOT EXISTS public.company_field_example
(
    id SERIAL NOT NULL,
    field_id integer,
    input text COLLATE pg_catalog."default",
    output text COLLATE pg_catalog."default",
    CONSTRAINT company_field_example_pkey PRIMARY KEY (id),
    CONSTRAINT company_field_example_field_id_fkey FOREIGN KEY (field_id)
        REFERENCES public.company_field (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_field_value

-- DROP TABLE IF EXISTS public.company_field_value;

CREATE TABLE IF NOT EXISTS public.company_field_value
(
    id SERIAL NOT NULL,
    company_field_id integer,
    value character varying(255) COLLATE pg_catalog."default",
    description character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT company_field_value_pkey PRIMARY KEY (id),
    CONSTRAINT company_field_value_company_field_id_fkey FOREIGN KEY (company_field_id)
        REFERENCES public.company_field (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_prompt

-- DROP TABLE IF EXISTS public.company_prompt;

CREATE TABLE IF NOT EXISTS public.company_prompt
(
    id SERIAL NOT NULL,
    sequence integer,
    name character varying(255) COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    company_id integer,
    CONSTRAINT company_prompt_pkey PRIMARY KEY (id),
    CONSTRAINT company_prompt_company_id_fkey FOREIGN KEY (company_id)
        REFERENCES public.company (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

-- Table: public.company_prompt_rule

-- DROP TABLE IF EXISTS public.company_prompt_rule;

CREATE TABLE IF NOT EXISTS public.company_prompt_rule
(
    id SERIAL NOT NULL DEFAULT,
    parent_id integer,
    company_prompt_id integer,
    company_field_id integer,
    operator character varying(10) COLLATE pg_catalog."default",
    value text COLLATE pg_catalog."default",
    unary_operator character varying(10) COLLATE pg_catalog."default",
    logic_operator character varying(10) COLLATE pg_catalog."default",
    "position" integer,
    CONSTRAINT company_prompt_rule_pkey PRIMARY KEY (id),
    CONSTRAINT company_prompt_rule_company_field_id_fkey FOREIGN KEY (company_field_id)
        REFERENCES public.company_field (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT company_prompt_rule_company_prompt_id_fkey FOREIGN KEY (company_prompt_id)
        REFERENCES public.company_prompt (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
