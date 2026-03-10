-- Script de correcao de colunas na tabela configuracao_estoque

do $$
begin
    -- 1. Garantir que a coluna importacao_separador_campo (singular) exista
    if not exists (
        select 1 
        from information_schema.columns 
        where table_name = 'configuracao_estoque' 
        and column_name = 'importacao_separador_campo'
    ) then
        -- Se existir a versão plural, renomeia
        if exists (
            select 1 
            from information_schema.columns 
            where table_name = 'configuracao_estoque' 
            and column_name = 'importacao_separador_campos'
        ) then
            alter table public.configuracao_estoque rename column importacao_separador_campos to importacao_separador_campo;
        else
            -- Se não existir nenhuma, cria a singular
            alter table public.configuracao_estoque add column importacao_separador_campo character varying default ',';
        end if;
    end if;

    -- 2. Garantir outras colunas novas
    if not exists (
        select 1 
        from information_schema.columns 
        where table_name = 'configuracao_estoque' 
        and column_name = 'bipagem_codigo_alternativo'
    ) then
        alter table public.configuracao_estoque add column bipagem_codigo_alternativo text default 'N';
    end if;

    if not exists (
        select 1 
        from information_schema.columns 
        where table_name = 'configuracao_estoque' 
        and column_name = 'importacao_incluir_codigo_alternativo'
    ) then
        alter table public.configuracao_estoque add column importacao_incluir_codigo_alternativo boolean default false;
    end if;

    if not exists (
        select 1 
        from information_schema.columns 
        where table_name = 'configuracao_estoque' 
        and column_name = 'exportacao_incluir_codigo_alternativo'
    ) then
        alter table public.configuracao_estoque add column exportacao_incluir_codigo_alternativo boolean default false;
    end if;

    -- 3. Garantir codigo_alternativo na tabela products
    if not exists (
        select 1 
        from information_schema.columns 
        where table_name = 'products' 
        and column_name = 'codigo_alternativo'
    ) then
        alter table public.products add column codigo_alternativo text null;
    end if;

end $$;
