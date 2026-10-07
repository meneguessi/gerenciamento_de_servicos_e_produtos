--table para o funcionario cadastrar todos os clientes
create table cliente (
id_cliente int identity(1,1) primary key,
nome varchar(150) not null,
telefone varchar(11) not null,
CPF varchar(11) unique not null
);

-- table para o funcionario da mecanica ter um controle dos veiculos 
create table veiculo(
id_veiculo int identity(1,1) primary key,
id_cliente int, -- para associar o carro ao seu respectivo cliente 
placa varchar(7) unique,
modelo varchar(40) not null,
ano date not null,
cor varchar(30) not null
constraint fk_cliente_veiculo 
	foreign key (id_cliente)
		references cliente (id_cliente)
);

-- mecanico responsavel por fazer os consertos dos carros
create table mecanico(
id_mecanico int identity(1,1) primary key,
nome varchar(100) not null,
telefone varchar(11) not null,
especialidade varchar(100) not null
);

-- table para cadastro de todos os produtos 
create table produto(
id_produto int identity(1,1) primary key,
nome varchar(100) not null,
preco decimal(8,2) not null,
descricao varchar(200) not null,
);

-- table para identificarmos quantos produtos tem no estoque e tambem para contro de rico minimo no estoque
create table estoque(
id_estoque int identity(1,1) primary key,
id_produto int,
quantidade_atual int not null,
quantidade_min int default(5),
nome_responsavel varchar(100) not null,
constraint fk_produto_estoque
	foreign key (id_produto)
		references produto (id_produto)
);

-- serve para ser um catalogo com os serviços pre estabelecidos que a mecanica faz e os valores padroes de cada 
create table servico(
id_servico int identity(1,1) primary key,
descricao varchar (200) not null,
valor_padrao decimal(8,2)
);

/*  Essa table serve para controlar toda a movimentação do estoque, como se fosse um extrato 
	com o tipo para indicar se chegou mercadoria ou se o mecanico usou no carro tendo o motivo para indicação
	tendo o id da id_os para quando tiver uma saida o mecanico não precisar dar o motivo já que vai estar vinculada a um serviço, se for uma entrada o motivo será util
*/
create table movimentacao_estoque(
id_movimentacao int identity(1,1) primary key,
id_estoque int,
id_os int,
tipo varchar(10) check(tipo in('entrada','saida')) not null,
quantidade_movimentacao int not null,-- Colocar uma trigger para quando movimentar mudar o atributo estoque_atual de 'estoque'
data_movimentacao date not null,
motivo varchar(100) not null,
constraint fk_movimentacao_estoque
	foreign key (id_estoque)
		references estoque (id_estoque),
constraint fk_movimentacao_os
	foreign key (id_os)
		references ordem_servico (id_os)
);


--serve como uma ordem de serviço mesmo para controle de serviços na mecanica 
create table ordem_servico(
id_os int identity(1,1) primary key,
id_veiculo int,
id_mecanico int,
data_abertura datetime not null,
date_fechamento datetime not null,
status varchar(15) check(status in('orçamento','aprovado','finalizado')),
valor_total decimal(8,2),
constraint fk_os_veiculo
	foreign key (id_veiculo)
		references veiculo (id_veiculo),
constraint fk_os_mecanico
	foreign key (id_mecanico)
		references mecanico (id_mecanico)
);

--serve para saber os produtos que foram usados em x ordens de serviços 
create table produto_os(
id_produto_os int identity(1,1) primary key,
id_os int,
id_produto int,
quantidade int not null,
valor_unitario decimal(8,2) not null,
constraint fk_os
	foreign key (id_os)
		references ordem_servico (id_os),
constraint fk_produto_os 
	foreign key (id_produto)
		references produto (id_produto)
);

/* como um carro pode fazer vario servicos essa table serve para ter um controle de varios serviços diferentes para a mesma os
por exemplo: Ela diz: "Na OS nº 10, foi feito o Serviço nº 1". Na linha de baixo ela anota: "Na mesma OS nº 10, também foi feito o Serviço nº 2"
*/
create table servico_os(
id_servico_os int identity(1,1) primary key,
id_os int,
id_servico int,
valor_cobrado decimal(8,2) not null,
constraint fk_os_servico_os
	foreign key (id_os)
		references ordem_servico (id_os),
constraint fk_servico
	foreign key (id_servico)
		references servico (id_servico)
);
