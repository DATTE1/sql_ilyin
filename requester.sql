--1) Количество клиентов по тарифам
SELECT t.tariff_name, COUNT(c.client_id) AS client_count
FROM client c
JOIN contract ct ON c.client_id = ct.client_id
JOIN tariff t ON ct.tariff_id = t.tariff_id
GROUP BY t.tariff_name;

--2) Клиенты с роутерами, а также статус их роутеров
SELECT c.name, r.router_status
FROM client c
LEFT JOIN router r ON c.router_id = r.router_id
WHERE c.router_id IS NOT NULL;

--3) Клиенты с истекающим доступом в ближайшие 7 дней
SELECT c.name, c.phone, a.access_end_date, 
       (a.access_end_date - CURRENT_DATE) AS days_left
FROM client c
JOIN payment p ON c.client_id = p.client_id
JOIN access a ON p.payment_id = a.payment_id
WHERE a.access_end_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '7 days'
ORDER BY days_left ASC;

--4) Тарифы, у которых больше 3 клиентов
SELECT t.tariff_name, COUNT(c.client_id) AS client_count
FROM client c
JOIN contract ct ON c.client_id = ct.client_id
JOIN tariff t ON ct.tariff_id = t.tariff_id
GROUP BY t.tariff_name
HAVING COUNT(c.client_id) > 3
ORDER BY client_count DESC;

--5) Тарифы клиентов и клиенты, у которых скорость загрузки больше 100 Мбит/с
SELECT c.name, c.phone, t.tariff_name, t.download_speed
FROM client c
JOIN contract ct ON c.client_id = ct.client_id
JOIN tariff t ON ct.tariff_id = t.tariff_id
WHERE t.download_speed > 100;

--6) Количество платежей у клиентов, у которых больше одного платежа
SELECT c.name, COUNT(p.payment_id) AS payment_count
FROM client c
JOIN payment p ON c.client_id = p.client_id
GROUP BY c.name
HAVING COUNT(p.payment_id) > 1;

--7) Тарифы, количество клиентов и средняя сумма платежа по каждому тарифу
SELECT t.tariff_name,
       COUNT(DISTINCT c.client_id) AS client_count,
       AVG(t.tariff_price) AS avg_payment
FROM tariff t
LEFT JOIN contract ct ON t.tariff_id = ct.tariff_id
LEFT JOIN client c ON ct.client_id = c.client_id
GROUP BY t.tariff_name
ORDER BY client_count desc;

--8) Тарифы по убыванию цены
select tariff_name, tariff_price
from tariff
order by tariff_price desc;

--9) Количество клиентов без услуг выдачи роутера
select COUNT(*) as clients_without_router
from client
where router_id is NULL;

--10) Клиенты с самым дорогим на данный момент тарифом
select c.name, c.phone, t.tariff_name, t.tariff_price
from client c
join contract ct on c.client_id = ct.client_id
join tariff t on ct.tariff_id = t.tariff_id
where t.tariff_price = (select MAX(tariff_price) from tariff)
order by c.name;

--11) Оконная функция: ранжирование тарифов по количеству подключенных клиентов
SELECT t.tariff_name, COUNT(ct.client_id) AS client_count,
       RANK() OVER (ORDER BY COUNT(ct.client_id) DESC) AS rank
FROM tariff t
LEFT JOIN contract ct ON t.tariff_id = ct.tariff_id
GROUP BY t.tariff_name
ORDER BY client_count DESC;
