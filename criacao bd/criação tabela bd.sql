CREATE TABLE public.arquivos (
	id_arquivo serial4 NOT NULL,
	titulo varchar(100) NOT NULL,
	extensao varchar(20) NOT NULL,
	arquivo bytea NOT NULL,
	CONSTRAINT pk_arquivos PRIMARY KEY (id_arquivo)
);