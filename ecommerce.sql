-- criação de banco de dados para o cenário de E-commerce
CREATE database ecommerce;
USE ecommerce;

-- TABELA CLIENTE
CREATE TABLE clients (
	idClient INT AUTO_INCREMENT PRIMARY KEY,
    cname VARCHAR(20),
    clastname VARCHAR(20),
    CPF CHAR(11) NOT NULL,
    CNPJ CHAR(18),
    CONSTRAINT unique_cpf_client UNIQUE(CPF),
    CONSTRAINT unique_cnpj_client UNIQUE(CNPJ),
    adress VARCHAR(30)
);

ALTER TABLE clients AUTO_INCREMENT=1;

-- TABELA PRODUTO
-- size = dimensões do produto
CREATE TABLE product (
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    pname VARCHAR(20),
    classfication_kids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    avaliation FLOAT DEFAULT 0,
    size VARCHAR (10)
);

-- TABELA PAGAMENTO
CREATE TABLE payment(
	idClient INT,
    idPayment INT,
    typePayment ENUM('Card', 'PIX', 'Boleto'),
	limitAvaible FLOAT,
    PRIMARY KEY(idClient, idPayment)
);

-- TABELA PEDIDO
CREATE TABLE orders(
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
	idOrderClient INT,
    orderStatus ENUM('Confirmed','Canceled','Processing') NOT NULL,
    orderDescription VARCHAR(255),
    shippingPrice FLOAT DEFAULT 10,
    paymentCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_orders_client FOREIGN KEY(idOrderClient) REFERENCES clients(idClient)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

-- TABELA ESTOQUE
CREATE TABLE productStorage(
	idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    category ENUM('Confirmed','Canceled','Processing') NOT NULL,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- TABELA FORNECEDOR
CREATE TABLE supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR (255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE(CNPJ)
);

-- TABELA VENDEDOR
CREATE TABLE seller(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    abstName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR (9),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE(CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE(CPF)
);

CREATE TABLE productSeller(
	idPseller INT,
    idPproduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY(idPseller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY(idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY(idPproduct) REFERENCES product(idProduct)
);

CREATE TABLE productOrder(
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Avaible','Unavaible') DEFAULT 'Avaible',
    PRIMARY KEY(idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_seller FOREIGN KEY(idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_product FOREIGN KEY(idPOorder) REFERENCES orders(idOrder)
);

CREATE TABLE storageLocation(
	idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY(idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY(idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY(idLstorage) REFERENCES productStorage(idProductStorage)
);

CREATE TABLE productSupplier(
	idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY(idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY(idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_sproduct FOREIGN KEY(idPsProduct) REFERENCES product(idProduct)
);
