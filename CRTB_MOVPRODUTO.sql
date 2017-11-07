#ESQUEMA FOLHA #######################################################

CREATE TABLE T_FUNCIONARIO (
	MATRIC NUMBER(5) NOT NULL,
	NOME VARCHAR2(30) NOT NULL,
	DAT_ADMISS DATE,
	COD_DEPTO NUMBER NOT NULL,
	CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(MATRIC)
);

COMMENT ON TABLE T_FUNCIONARIO IS 'TABELA DE FUNCIONÁRIOS';
COMMENT ON COLUMN T_FUNCIONARIO.MATRIC IS 'ID DO FUNCIONÁRIO, CHAVE PRIMARIA';
COMMENT ON COLUMN T_FUNCIONARIO.NOME IS 'NOME DO FUNCIONÁRIO';
COMMENT ON COLUMN T_FUNCIONARIO.DAT_ADMISS IS 'DATA DE ADMISSÃO';
COMMENT ON COLUMN T_FUNCIONARIO.COD_DEPTO IS 'DEPARTAMENTO DO FUNC, CHAVE ESTRANGEIRA';

CREATE TABLE T_DEPARTAMENTO (
	COD_DEPTO NUMBER NOT NULL,
	NOM_DEPTO VARCHAR2(30) NOT NULL,
	SIGLA_DEPTO VARCHAR2(5),
	CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY(COD_DEPTO)
);

COMMENT ON TABLE T_DEPARTAMENTO  IS 'TABELA DE DEPARTAMENTOS';
COMMENT ON COLUMN T_DEPARTAMENTO.COD_DEPTO IS 'ID DO DEPARTAMENTO, CHAVE PRIMARIA';
COMMENT ON COLUMN T_DEPARTAMENTO.NOM_DEPTO IS 'NOME DO DEPARTAMENTO';
COMMENT ON COLUMN T_DEPARTAMENTO.SIGLA_DEPTO IS 'SIGLA DO DEPARTAMENTO';


ALTER TABLE T_FUNCIONARIO ADD CONSTRAINT FK_FUNC_DEPTO
FOREIGN KEY (COD_DEPTO) REFERENCES T_DEPARTAMENTO(COD_DEPTO);

GRANT REFERENCES, SELECT ON T_FUNCIONARIO TO ESTOQUE;

GRANT REFERENCES, SELECT ON T_FUNCIONARIO TO VENDAS;


#ESQUEMA ESTOQUE ################################################################

CREATE TABLE T_PRODUTO (
	COD_PRODUTO NUMBER(5) NOT NULL,
	NOM_PRODUTO VARCHAR2(30) NOT NULL,
	CD_GRUPO_PROD NUMBER(2) NOT NULL,
	CD_UNIDADE_MEDIDA VARCHAR2(3) NOT NULL,
	VL_UNITARIO NUMBER(7,2),
	SALDO_ESTOQUE NUMBER(7,2),
	QTD_ESTOQUE_MIN NUMBER(7,2),
	QTD_PTO_PEDIDO NUMBER(7,2),
	CONSTRAINT PK_PRODUTO PRIMARY KEY (COD_PRODUTO)

COMMENT ON TABLE T_PRODUTO IS 'TABELA DE PRODUTOS';
COMMENT ON COLUMN T_PRODUTO.COD_PRODUTO IS 'ID DOS PRODUTOS, CHAVE PRIMARIA';
COMMENT ON COLUMN T_PRODUTO.NOM_PRODUTO IS 'DESCRIÇÃO DO PRODUTO';
COMMENT ON COLUMN T_PRODUTO.CD_GRUPO_PROD IS 'CHAVE ESTRANGEIRA DA T_GRUPO_PROD';
COMMENT ON COLUMN T_PRODUTO.CD_UNID_MEDIDA IS 'CHAVE ESTRANGEIRA DA T_UNIDADE_MEDIDA';
COMMENT ON COLUMN T_PRODUTO.VL_UNITARIO IS 'VALOR DO PRODUTO';
COMMENT ON COLUMN T_PRODUTO.SALDO_ESTOQUE IS 'QUANTIDADE EM ESTOQUE';
COMMENT ON COLUMN T_PRODUTO.QTD_ESTOQUE_MIN IS 'QUANTIDADE MINIMA EM ESTOQUE';
COMMENT ON COLUMN T_PRODUTO.QTD_PTO_PEDIDO IS 'QUANTIDADE DE PEDIDO';

CREATE TABLE T_GRUPO_PROD (
	CD_GRUPO_PROD NUMBER(2) NOT NULL,
	DS_GRUPO_PROD VARCHAR2(30),
	CONSTRAINT PK_GRUPO_PROD PRIMARY KEY (CD_GRUPO_PROD)
);

COMMENT ON TABLE T_GRUPO_PROD IS 'TABELA DE PRODUTOS POR GRUPO';
COMMENT ON COLUMN T_GRUPO_PROD.CD_GRUPO_PROD IS 'ID DO GRUPO, CHAVE PRIMARIA';
COMMENT ON COLUMN T_GRUPO_PROD.DS_GRUPO_PROD IS 'DESCRIÇÃO DO GRUPO DE PRODUTOS';

CREATE TABLE T_UNIDADE_MEDIDA (
	CD_UNID_MEDIDA VARCHAR2(3) NOT NULL,
	DS_UNID_MEDIDA VARCHAR2(20),
	CONSTRAINT PK_UNID_MEDIDA PRIMARY KEY (CD_UNID_MEDIDA)
);

COMMENT ON TABLE T_UNIDADE_MEDIDA IS 'TABELA UNIDADE DE MEDIDAS';
COMMENT ON COLUMN T_UNIDADE_MEDIDA.CD_UNID_MEDIDA IS 'ID DA UNIDADE DE MEDIDA, CHAVE PRIMARIA';
COMMENT ON COLUMN T_UNIDADE_MEDIDA.DS_UNID_MEDIDA IS 'DESCRIÇÃO';

CREATE TABLE T_MOV_PRODUTO (
	COD_PRODUTO NUMBER(5) NOT NULL,
	NUM_MOVIM NUMBER(5) NOT NULL,
	DAT_MOVIM DATE,
	TIP_MOVIM CHAR(1),
	QTD_MOVIM NUMBER(3),
	MATR_FUNC_MOV NUMBER NOT NULL(5),
	CONSTRAINT PK_MOV_PRODUTO PRIMARY KEY (COD_PRODUTO, NUM_MOVIM)
);

COMMENT ON TABLE T_MOV_PRODUTO IS 'TABELA MOVIMENTO DOS PRODUTOS';
COMMENT ON COLUMN T_MOV_PRODUTO.COD_PRODUTO IS 'ID DOS PRODUTOS, CHAVE ESTRANGEIRA T_PRODUTO';
COMMENT ON COLUMN T_MOV_PRODUTO.NUM_MOVIM IS 'ID DO MOVIMENTO, CHAVE PRIMARIA';
COMMENT ON COLUMN T_MOV_PRODUTO.DAT_MOVIM IS 'DATA DO MOVIMENTO';
COMMENT ON COLUMN T_MOV_PRODUTO.TIP_MOVIM IS 'MOVIMENTO DE ENTRADA OU SAÍDA';
COMMENT ON COLUMN T_MOV_PRODUTO.QTD_MOVIM IS 'QUANTIDADE EM MOVIMENTO';
COMMENT ON COLUMN T_MOV_PRODUTO.MATR_FUNC_MOV IS 'MATRICULA DO FUNCIONARIO RESP-2º CHAVE ESTRANG';


ALTER TABLE T_PRODUTO ADD CONSTRAINT FK_PRODUTO_GRUPO 
FOREIGN KEY (CD_GRUPO_PROD) REFERENCES T_GRUPO_PROD(CD_GRUPO_PROD);

ALTER TABLE T_PRODUTO ADD CONSTRAINT FK_PRODUTO_UNID_MEDIDA 
FOREIGN KEY (CD_UNID_MEDIDA) REFERENCES T_UNIDADE_MEDIDA(CD_UNID_MEDIDA);

ALTER TABLE T_MOV_PRODUTO ADD CONSTRAINT FK_MOV_PRODUTO_PRODUTO 
FOREIGN KEY (COD_PRODUTO) REFERENCES T_PRODUTO(COD_PRODUTO);

# APÓS CRIAR ESQUEMA FOLHA 
ALTER TABLE T_MOV_PRODUTO ADD CONSTRINT FK_MOV_PRODUTO_FUNC
FOREIGN KEY (MATR_FUNC_MOV) REFERENCES FOLHA.T_FUNCIONARIO (MATRIC);

GRANT REFERENCES, SELECT ON T_PRODUTO TO VENDAS;

 
#ESQUEMA VENDAS ###############################################################

CREATE TABLE T_ITEM_NF (
	NUM_NF NUMBER(7) NOT NULL,
	COD_PRODUTO NUMBER(5),
	QTDE NUMBER(9,2),
	VL_UNITARIO NUMBER(9,2)
	CONSTRAINT PK_ITENS_NF PRIMARY KEY(NUM_NF)
);

COMMENT ON TABLE T_ITEM_NF IS 'TABELA ITENS NOTA FISCAL';
COMMENT ON COLUMN T_ITEM_NF.NUM_NF IS 'CHAVE ESTRANGEIRA TABELA NOTA FISCAL';
COMMENT ON COLUMN T_ITEM_NF.COD_PRODUTO IS 'CHAVE ESTRANGEIRA TABELA PRODUTO';
COMMENT ON COLUMN T_ITEM_NF.QTDE IS 'QUANTIDADE DE ITENS NA NOTA FISCAL';
COMMENT ON COLUMN T_ITEM_NF.VL_UNITARIO IS 'VALOR POR UNIDADE';

CREATE TABLE T_NOTA_FISCAL (
	NUM_NF NUMBER(7),
	DATA_NF DATE,
	COD_CLIENTE NUMBER(5),
	MATR_FUNC_EMI NUMBER(5),
	CONSTRAINT PK_ITENS_NF PRIMARY KEY(NUM_NF)
);

COMMENT ON TABLE T_NOTA_FISCAL IS 'TABELA NOTA FISCAL';
COMMENT ON COLUMN T_NOTA_FISCAL.NUM_NF IS 'ID DA NOTA FISCAL, CHAVE PRIMARIA';
COMMENT ON COLUMN T_NOTA_FISCAL.DATA_NF IS 'DATA DA NOTA';
COMMENT ON COLUMN T_NOTA_FISCAL.COD_CLIENTE IS 'CHAVE ESTRANGEIRA DA TABELA CLIENTE';
COMMENT ON COLUMN T_NOTA_FISCAL.MATR_FUNC_EMI IS 'CHAVE ESTRANGEIRA DA TABELA FUNCIONARIO';


CREATE TABLE T_CLIENTE (
	COD_CLIENTE NUMBER(5),
	NOME_CLIENTE VARCHAR2(30),
	CONSTRAINT PK_CLIENTE PRIMARY KEY(COD_CLIENTE)
);

COMMENT ON TABLE T_CLIENTE IS 'TABELA DE CLIENTES';
COMMENT ON COLUMN T_CLIENTE.COD_CLIENTE IS 'ID DO CLIENTE, CHAVE PRIMARIA';
COMMENT ON COLUMN T_CLIENTE.NOME_CLIENTE IS 'NOME DO CLIENTE';


ALTER TABLE T_NOTA_FISCAL ADD CONSTRAINT FK_NF_CLIENTE
FOREIGN KEY (COD_CLIENTE) REFERENCES T_CLIENTE(COD_CLIENTE);

ALTER TABLE T_ITEM_NF ADD CONSTRAINT FK_NF_NUMERO_NF
FOREIGN KEY (NUM_NF) REFERENCES T_NOTA_FISCAL(NUM_NF);

# APÓS CRIAR ESQUEMA FOLHA
ALTER TABLE T_NOTA_FISCAL ADD CONSTRAINT FK_NF_FUNC
FOREIGN KEY (MATR_FUNC_EMI) REFERENCES FOLHA.T_FUNCIONARIO (MATRIC);

ALTER TABLE T_ITEM_NF ADD CONSTRAINT FK_ITEM_NF_PRODUTO
FOREIGN KEY (COD_PRODUTO) REFERENCES ESTOQUE.T_PRODUTO (COD_PRODUTO);