CREATE TABLE tariff (
    tariff_id SERIAL PRIMARY KEY,    
    tariff_name VARCHAR(50) NOT NULL,                   
    tariff_price DECIMAL(10,2) CHECK (tariff_price > 0),     
    download_speed INT CHECK (download_speed >= 0),
    upload_speed INT CHECK (upload_speed >= 0)
);

CREATE TABLE router (
    router_id SERIAL PRIMARY KEY,
    router_status VARCHAR(20) DEFAULT 'online'
);

CREATE TABLE client (
    client_id SERIAL PRIMARY KEY,       
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL CHECK (phone ~ '^(\+7|8)[-\s]?\(?\d{3}\)?[-\s]?\d{3}[-\s]?\d{2}[-\s]?\d{2}$'),
    address TEXT NOT NULL,
    passport_data VARCHAR(50) NOT NULL CHECK (passport_data ~ '^[0-9]{4}\s?[0-9]{6}$'),
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,
    router_id INT,
    FOREIGN KEY (router_id) REFERENCES router(router_id)
);

CREATE TABLE contract (
    contract_id SERIAL PRIMARY KEY,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,                
    end_date DATE NOT NULL CHECK (start_date < end_date),
    client_id INT NOT NULL,
    tariff_id INT NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (tariff_id) REFERENCES tariff(tariff_id)
);

CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TABLE access (
    access_id SERIAL PRIMARY KEY,
    payment_id INT NOT NULL,
    tariff_id INT NOT NULL,
    access_start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    access_end_date DATE NOT NULL DEFAULT CURRENT_DATE + INTERVAL '30 days',
    CHECK (access_start_date < access_end_date),
    FOREIGN KEY (payment_id) REFERENCES payment(payment_id),
    FOREIGN KEY (tariff_id) REFERENCES tariff(tariff_id)
);
