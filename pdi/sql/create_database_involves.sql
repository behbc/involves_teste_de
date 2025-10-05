-- Bruno Baldez
-- bruno.behbc@gmail.com

CREATE DATABASE involves;

-- SELECT session_user, current_database();

-- Datasource:
CREATE SCHEMA bronze;
-- set search_path = "bronze"

-- dataset colunas
-- ['ID_DATASET', 'ID_PONTO_VENDA', 'NOME_PONTO_VENDA',
--        'PERFIL_PONTO_VENDA', 'DATA', 'ID_LINHA_PRODUTO', 'NOME_LINHA_PRODUTO',
--        'MARCA_LINHA_PRODUTO', 'TIPO_COLETA', 'VALOR']
CREATE TABLE bronze.dataset_disponibilidade(
        ID_DATASET INT NOT NULL, -- PRIMARY KEY,
        ID_PONTO_VENDA INT NOT NULL,
        NOME_PONTO_VENDA VARCHAR NOT NULL,
        PERFIL_PONTO_VENDA VARCHAR NOT NULL,
        DATA VARCHAR NOT NULL,
        ID_LINHA_PRODUTO INT NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        MARCA_LINHA_PRODUTO VARCHAR NOT NULL,
        TIPO_COLETA VARCHAR NOT NULL,
        VALOR VARCHAR
);


-- Dimensoes:
CREATE SCHEMA silver;
-- set search_path="silver"

-- dim_calendario colunas
-- ['DATA', 'DATA_DT', 'ANO', 'MES', 'DIA']
CREATE TABLE silver.dim_calendario(
        DATA VARCHAR NOT NULL PRIMARY KEY,
        DATA_DT DATE, -- NOT NULL,
        ANO INT, -- NOT NULL,
        MES INT, -- NOT NULL,
        DIA INT -- NOT NULL
);

-- dim_pdv colunas
-- ['ID_PONTO_VENDA', 'NOME_PONTO_VENDA', 'PERFIL_PONTO_VENDA']
CREATE TABLE silver.dim_pdv(
        ID_PONTO_VENDA INT NOT NULL PRIMARY KEY,
        NOME_PONTO_VENDA VARCHAR NOT NULL,
        PERFIL_PONTO_VENDA VARCHAR NOT NULL
);

-- dim_linha_produto colunas
-- ['ID_LINHA_PRODUTO', 'NOME_LINHA_PRODUTO', 'MARCA_LINHA_PRODUTO']
CREATE TABLE silver.dim_linha_produto(
        ID_LINHA_PRODUTO INT NOT NULL PRIMARY KEY,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        MARCA_LINHA_PRODUTO VARCHAR NOT NULL
);

-- Fatos:

-- ft_disponibilidade colunas
-- ['DATA', 'ID_PONTO_VENDA', 'ID_LINHA_PRODUTO', 'TIPO_COLETA', 'VALOR',
--        'ANO', 'MES', 'DIA', 'NOME_PONTO_VENDA', 'PERFIL_PONTO_VENDA',
--        'NOME_LINHA_PRODUTO', 'MARCA_LINHA_PRODUTO']
CREATE TABLE silver.fact_disponibilidade(
        DATA VARCHAR NOT NULL,
        ANO INT NOT NULL,
        MES INT NOT NULL,
        DIA INT NOT NULL,
        ID_PONTO_VENDA INT NOT NULL,
        NOME_PONTO_VENDA VARCHAR NOT NULL,
        PERFIL_PONTO_VENDA VARCHAR NOT NULL,
        ID_LINHA_PRODUTO INT NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        MARCA_LINHA_PRODUTO VARCHAR NOT NULL,
        TIPO_COLETA VARCHAR NOT NULL,
        VALOR VARCHAR
);

CREATE SCHEMA gold;
-- set search_path="gold"

-- ft_disp_a colunas
-- ['MES', 'NOME_LINHA_PRODUTO', 'COUNT_DIAS_PRESENCA_LINHA_PRODUTO']
CREATE TABLE gold.fact_disp_lp(
        MES INT NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        COUNT_DIAS_PRESENCA_LINHA_PRODUTO INT NOT NULL
);

-- ft_disp_b colunas
-- ['MES', 'NOME_PONTO_VENDA', 'NOME_LINHA_PRODUTO',
--        'COUNT_DIAS_PRESENCA_LINHA_PRODUTO']
CREATE TABLE gold.fact_disp_lp_pdv(
        MES INT NOT NULL,
        NOME_PONTO_VENDA VARCHAR NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        COUNT_DIAS_PRESENCA_LINHA_PRODUTO INT NOT NULL
);

-- ft_ponto_extra_a colunas
-- ['MES', 'NOME_LINHA_PRODUTO', 'SUM_PONTOS_EXTRAS']
CREATE TABLE gold.fact_pe_lp(
        MES INT NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        SUM_PONTOS_EXTRAS INT NOT NULL
);

-- ft_ponto_extra_b colunas
-- ['MES', 'NOME_PONTO_VENDA', 'NOME_LINHA_PRODUTO', 'SUM_PONTOS_EXTRAS']
CREATE TABLE gold.fact_pe_lp_pdv(
        MES INT NOT NULL,
        NOME_PONTO_VENDA VARCHAR NOT NULL,
        NOME_LINHA_PRODUTO VARCHAR NOT NULL,
        SUM_PONTOS_EXTRAS INT NOT NULL
);


-- DELETE FROM bronze.datasource_disponibilidade
-- WHERE 1=1;


-- SELECT * FROM bronze.dataset_disponibilidade;
-- SELECT * FROM silver.dim_pdv;
-- SELECT * FROM silver.dim_linha_produto;
-- SELECT * FROM silver.dim_calendario;
-- SELECT * FROM silver.fact_disponibilidade;
-- SELECT * FROM gold.fact_disp_lp;
-- SELECT * FROM gold.fact_disp_lp_pdv;
-- SELECT * FROM gold.fact_pe_lp;
-- SELECT * FROM gold.fact_pe_lp_pdv;

SELECT COUNT(*) FROM bronze.dataset_disponibilidade;
SELECT COUNT(*) FROM silver.dim_pdv;
SELECT COUNT(*) FROM silver.dim_linha_produto;
SELECT COUNT(*) FROM silver.dim_calendario;
SELECT COUNT(*) FROM silver.fact_disponibilidade;
SELECT COUNT(*) FROM gold.fact_disp_lp;
SELECT COUNT(*) FROM gold.fact_disp_lp_pdv;
SELECT COUNT(*) FROM gold.fact_pe_lp;
SELECT COUNT(*) FROM gold.fact_pe_lp_pdv;


--    date_creation DATE NOT NULL DEFAULT CURRENT_DATE,
--    progress DECIMAL NOT NULL DEFAULT 0.0,
--    id_project_type INT NOT NULL REFERENCES app.project_types(id)