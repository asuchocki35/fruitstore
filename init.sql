CREATE DATABASE IF NOT EXISTS fruitstore;
USE fruitstore;

CREATE TABLE IF NOT EXISTS fruit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    price FLOAT
);

INSERT INTO fruit (name, price) VALUES 
('Apple', 2.00),
('Orange', 1.50),
('Banana', 3.50),
('Mango', 5.00),
('Kiwi', 0.50);
