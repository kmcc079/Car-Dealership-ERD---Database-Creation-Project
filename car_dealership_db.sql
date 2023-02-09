--Once the database has been created, students should create their own database inside of DBeaver. 
--Also, once the database and the tables are created, each student should have AT LEAST 2 pieces/records of data inside of the tables. 
--(You can add more if you want)
--At least 2 of the inserts should come from a stored function. (You can always add more if you want)


-- create dealership
create table dealership (
	dealership_id SERIAL primary key,
	address VARCHAR(150),
	contact_number VARCHAR(15),
	email VARCHAR(100)
);

-- create customer
create table customer (
	customer_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	address VARCHAR(150),
	contact_number VARCHAR(15),
	email VARCHAR(100),
	billing_info VARCHAR(150)
);

-- create parts
create table parts (
	part_id SERIAL primary key,
	part_name VARCHAR(100),
	quantity NUMERIC(5,2),
	cost_ NUMERIC(6,2)
);

--create salesperson
create table salesperson (
	salesperson_id SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	dealership_id INTEGER,
	foreign key (dealership_id) references dealership(dealership_id)
);

-- create mechanic
create table mechanic (
	mechanic_ic SERIAL primary key,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	dealership_id INTEGER,
	foreign key (dealership_id) references dealership(dealership_id)
);

-- create car
-- POST-NOTE!!! In order to have a vin read like an actual vin CANNOT USE SERIAL FOR PRIMARY KEY. MUST USE VARCHAR(17)
create table car (
	vin SERIAL primary key,
	make VARCHAR(75),
	model VARCHAR(100),
	year_ INTEGER,
	engine VARCHAR(6),
	color VARCHAR(50),
	dealership_id INTEGER,
	foreign key (dealership_id) references dealership(dealership_id)
);

-- create service
create table service (
	service_id SERIAL primary key,
	service_name VARCHAR(100),
	cost_ NUMERIC(7,2),
	dealership_id INTEGER,
	foreign key (dealership_id) references dealership(dealership_id)
);

-- create invoice
create table invoice (	
	invoice_num SERIAL primary key,
	cost_ NUMERIC(8,2),
	total_bal NUMERIC(8,2),
	salesperson_id INTEGER,
	customer_id INTEGER,
	vin INTEGER,
	foreign key (salesperson_id) references salesperson(salesperson_id),
	foreign key (customer_id) references customer(customer_id),
	foreign key (vin) references car(vin)
);



-- fix column name in mechanic table:
alter table mechanic 
rename column mechanic_ic to mechanic_id;

-- create service_ticket
create table service_ticket (
	ticket_num SERIAL primary key,
	cost_ NUMERIC(7,2),
	total_bal NUMERIC(7,2),
	service_id INTEGER,
	part_id INTEGER,
	mechanic_id INTEGER,
	vin INTEGER,
	customer_id INTEGER,
	foreign key (service_id) references service(service_id),
	foreign key (part_id) references parts(part_id),
	foreign key (mechanic_id) references mechanic(mechanic_id),
	foreign key (vin) references car(vin),
	foreign key (customer_id) references customer(customer_id)
);

-- create service record
create table service_record (
	record_id SERIAL primary key,
	dealership_id INTEGER,
	vin INTEGER,
	ticket_num INTEGER,
	foreign key (dealership_id) references dealership(dealership_id),
	foreign key (vin) references car(vin),
	foreign key (ticket_num) references service_ticket(ticket_num)
);

--Inserting data into tables:
insert into dealership (
	dealership_id,
	address,
	contact_number,
	email
) values (
	1,
	'111 Cake Dr, Brownie, AZ',
	'111-222-3333',
	'dealership@email.com'
);

insert into dealership (
	dealership_id,
	address,
	contact_number,
	email
) values (
	2,
	'222 Ducky Tr, Quack, DE',
	'222-333-4444',
	'duckydealer@email.com'
);

insert into customer (
	customer_id,
	first_name,
	last_name,
	address,
	contact_number,
	email,
	billing_info
) values (
	1,
	'Janie',
	'Phant',
	'1212 Ele Ln, Chess, MN',
	'123-123-1234',
	'jphant@email.com',
	'1111-2222-1111-2222'
);

create or replace function add_customer(_customer_id INTEGER, _first_name VARCHAR(100), 
_last_name VARCHAR(100), _address VARCHAR(150),_contact_number VARCHAR(15), 
_email VARCHAR(100), _billing_info VARCHAR(150))
returns void
as $MAIN$
begin 
	insert into customer(customer_id, first_name, last_name, address, contact_number,
	email, billing_info)
	values (_customer_id, _first_name, _last_name, _address, _contact_number,
	_email, _billing_info);
end;
$MAIN$
language plpgsql;

insert into parts (
	part_id,
	part_name,
	quantity,
	cost_
) values (
	1,
	'Oil Pan Gasket',
	1.00,
	52.00
);

create or replace function add_part(_part_id INTEGER, _part_name VARCHAR(100), 
_quantity numeric(5,2), _cost_ numeric(6,2))
returns void
as $MAIN$
begin 
	insert into parts(part_id, part_name, quantity, cost_)
	values (_part_id, _part_name, _quantity, _cost_);
end;
$MAIN$
language plpgsql;

insert into salesperson (
	salesperson_id,
	first_name,
	last_name,
	dealership_id
) values (
	1,
	'Bubba',
	'Jones',
	2
);

insert into salesperson (
	salesperson_id,
	first_name,
	last_name,
	dealership_id
) values (
	2,
	'Nika',
	'Mahones',
	1
);

insert into mechanic (
	mechanic_id,
	first_name,
	last_name,
	dealership_id
) values (
	1,
	'Leigh',
	'Smith',
	1
);

create or replace function add_mechanic(_mechanic_id INTEGER, _first_name VARCHAR(100), 
_last_name VARCHAR(100), _dealership_id INTEGER)
returns void
as $MAIN$
begin 
	insert into mechanic(mechanic_id, first_name, last_name, dealership_id)
	values (_mechanic_id, _first_name, _last_name, _dealership_id);
end;
$MAIN$
language plpgsql;

insert into car (
	vin,
	make,
	model,
	year_,
	engine,
	color,
	dealership_id
) values (
	1,
	'Jeep',
	'Wrangler',
	2017,
	3.60,
	'Crazy Plum Purple',
	2
), (
	2,
	'Toyota',
	'4Runner',
	2019,
	4.00,
	'Voodoo Blue',
	1	
);

insert into service (
	service_id,
	service_name,
	cost_,
	dealership_id
) values (
	1,
	'Oil Pan Gasket Replacement',
	'150.99',
	1
), (
	2,
	'Passenger Airbag Recall Replacement',
	'0.00',
	2
);

insert into invoice (	
	invoice_num,
	cost_,
	total_bal,
	salesperson_id,
	customer_id,
	vin
) values (
	1,
	38000.00,
	42995.71,
	1,
	1,
	1
); 

create or replace function add_invoice(_invoice_num INTEGER, _cost_ NUMERIC(8,2), _total_bal numeric(8,2), _salesperson_id INTEGER, _customer_id INTEGER, _vin INTEGER)
returns void
as $MAIN$
begin 
	insert into invoice(invoice_num, cost_, total_bal, salesperson_id, customer_id, vin)
	values (_invoice_num, _cost_, _total_bal, _salesperson_id, _customer_id, _vin);
end;
$MAIN$
language plpgsql;

--incorrectly named a parameter:
--drop function add_invoice;

insert into service_ticket (
	ticket_num,
	cost_,
	total_bal,
	service_id,
	part_id,
	mechanic_id,
	vin,
	customer_id
) values (
	1,
	202.99,
	230.99,
	1,
	1,
	1,
	1,
	1	
);

create or replace function add_ticket(_ticket_num INTEGER, _cost_ NUMERIC(7,2), _total_bal numeric(7,2), _service_id INTEGER, _part_id INTEGER, _mechanic_id INTEGER,
_vin INTEGER, _customer_id INTEGER)
returns void
as $MAIN$
begin 
	insert into service_ticket(ticket_num, cost_, total_bal, service_id, part_id,  mechanic_id, vin, customer_id)
	values (_ticket_num, _cost_, _total_bal, _service_id, _part_id,  _mechanic_id, _vin, _customer_id);
end;
$MAIN$
language plpgsql;

insert into service_record (
	record_id,
	dealership_id,
	vin,
	ticket_num
) values (
	1,
	2,
	1,
	1
);

create or replace function add_record(_record_id INTEGER, _dealership_id INTEGER, _vin INTEGER, _ticket_num INTEGER)
returns void
as $MAIN$
begin 
	insert into service_record(record_id, dealership_id, vin, ticket_num)
	values (_record_id, _dealership_id, _vin, _ticket_num);
end;
$MAIN$
language plpgsql;

-- Add data:
select add_customer(2, 'Mikey', 'Oneye', '222 Monsters Inc Blvd, Doors, HI', 
'999-999-9999', 'mikeymonster@email.com', '9999-0000-9999-0000');

select add_customer(3, 'Dewey', 'Dec', '333 Library Books, System, CA', 
'888-999-0000', 'ddec@email.com', '0987-0987-0987-0987');
--select * from customer

select add_part(2, 'Passenger Airbag', 1, 0.00);
--select * from parts

select add_mechanic(2, 'Corey', 'OConnor', 2);
--select * from mechanic

select add_invoice(2, 100000.00, 120987.99, 2, 2, 2);
--select * from invoice

select add_ticket(2, 0.00, 0.00, 2, 2, 2, 2, 2);
--select * from service_ticket;

select add_record(2, 1, 2, 2);
select * from service_record;


